#! /bin/bash

apt-get -qq install -y gnupg curl
apt-get -qq remove mongodb
apt-get -qq purge mongodb
apt-get -qq autoremove

curl -fsSL https://pgp.mongodb.com/server-7.0.asc | \
   gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor

echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] http://repo.mongodb.org/apt/debian bullseye/mongodb-org/7.0 main" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list

apt-get -qq update
apt-get -qq install -y mongodb-org

export INTERNAL_IP=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')

service mongod stop
sleep 10
echo "mongod stopped"
chown -R mongodb:mongodb /var/lib/mongodb /var/log/mongodb /tmp/mongodb-*.sock
sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/g' /etc/mongod.conf
# Its on 2 lines, It's normal, I need the newline
sed -i 's/#replication:/replication:\
  replSetName: "rs0"/' /etc/mongod.conf


export INTERNAL_IP=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
gcloud compute instance-groups list-instances ${cluster_name} --region europe-west9 > instances.txt && sed -i '1d' instances.txt && cat instances.txt
service mongod start
sleep 10
echo "mongod started"

count=$(wc -l < instances.txt)
seconds=$(($count*5+20))
current_hostname=$(hostname)
current_zone=''
sleep $seconds
filename="instances.txt"
min_ip=0
min_value=''
primary_host=''

echo "parsing instances file"
while read -r line
do
  row="$line"
  IFS=' '
  read -ra array <<< "$row"
  ip=$(ping -c 1 $${array[0]}.$${array[1]}.c.gen-archi.internal | head -1 | grep -Eo '?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*')
  oc4=$${ip##*.}
  if [ -z "$min_value" ]
  then
    min_value=$oc4
    min_ip=$ip
    primary_host=$${array[0]}
    primary_zone=$${array[1]}
  fi
  if [ $min_value -gt $oc4 ]
  then
    min_value=$oc4
    min_ip=$ip
    primary_host=$${array[0]}
    primary_zone=$${array[1]}
  fi
done < "$filename"

echo "starting configuration"
if [ "$current_hostname" = "$primary_host" ]
  then
  echo "initiating primary"
  echo "current_hostname => $current_hostname"
  echo "primary_host => $primary_host"
  mongosh --eval "rs.initiate()"
  mongosh --eval "cfg = rs.conf(); cfg.members[0].host = \"$(hostname -I | awk '{$1=$1;print}'):27017\"; rs.reconfig(cfg)"
else
  echo "sleeping 30 secs"
  sleep 30
  echo gcloud compute ssh "$primary_host --zone $primary_zone" -- "\" mongosh --eval 'rs.add(\\\""$INTERNAL_IP:27017\\\"")'\"" > add_secondary.sh
  runuser -u kart2f1_genarchi -- sh add_secondary.sh
  sleep 15  
  # runuser -u kart2f1_genarchi -- sh add_secondary.sh
  # sleep 15
  clustered=$(mongosh --eval "rs.status().errmsg" | sed '$!d')
  string="no replset config has been received"
  # Verify if the current node is added to replica set or not.
  # If there is any issue while adding node to replica set then find out master node among the nodes present in MIG and add current node on that primary node.
  if [ "$clustered" = "$string" ]; then
    echo "not added"
    filename="instances.txt"
    while read -r line
    do
      row="$line"
      IFS=' '
      read -ra array <<< "$row"
      primary_found=$(mongosh --host $${array[0]}.$${array[1]}.c.gen-archi.internal --eval "rs.isMaster().primary" | sed '$!d' | grep -Eo '?([0-9]*\.){3}[0-9]*')
      if [ -n "$primary_found" ]; then
        filename2="instances.txt"
        while read -r line2
          do
            row2="$line2"
            IFS=' '
            read -ra array2 <<< "$row2"
            ip2=$(ping -c 1 $${array2[0]}.$${array2[1]}.c.gen-archi.internal | head -1 | grep -Eo '?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*')
            if [ "$ip2" = "$primary_found" ]; then
              echo gcloud compute ssh "$primary_host --zone $primary_zone" -- "\" mongosh --eval 'rs.add(\\\""$INTERNAL_IP:27017\\\"")'\"" > add_secondary2.sh
              runuser -u kart2f1_genarchi -- sh add_secondary2.sh
              sleep 5
              # runuser -u kart2f1_genarchi -- sh add_secondary2.sh
              break
            fi
        done < "$filename2"
        clustered2=$(mongosh --eval "rs.status().errmsg" | sed '$!d')
        if [ "$clustered2" = "$string" ]; then
          break
        fi
      fi
    done < "$filename"
  else
    echo "added"
  fi
fi

echo '* * * * * root if [ "$(ps -ef | grep mongo | wc -l)"="3" ]; then echo "all is well" > /state.txt; else service mongod restart fi' > /var/spool/cron/crontabs/root
chmod 0600 /var/spool/cron/crontabs/root