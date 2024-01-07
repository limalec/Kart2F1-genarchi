#! /bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get -qq update
apt-get -qq -y install git npm > /dev/null
git clone https://github.com/limalec/Kart2F1-genarchi.git
cd Kart2F1-genarchi/todolist/frontend || exit 1
npm ci
export API_URL=${back-ip}:3000
npm run build
npx serve -s build -p 80 &