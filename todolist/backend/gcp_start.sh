#! /bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get -qq update
apt-get -qq -y install git npm > /dev/null
git clone https://github.com/limalec/Kart2F1-genarchi.git
cd Kart2F1-genarchi/todolist/backend || exit 1
npm ci
pwd
sed -i 's/localhost:27017/${db-ips}/g' ./src/app.module.ts
npm run build
npm run start:prod &
