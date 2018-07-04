#!/bin/bash
################################################################################
# Author: crombiecrunch
# Current Author: mario1987

# Web: www.cryptonova.eu
#
# Program:
#   After entering coin name and github link automatically build coin
# BTC Donation: 1FKxuqNi8ZfzWHtUyLR2kogpXihbZchSuD
#
################################################################################

output() {
    printf "\E[0;33;40m"
    echo $1
    printf "\E[0m"
}

displayErr() {
    echo
    echo $1;
    echo
    exit 1;
}

sudo mkdir -p ~/CoinBuilds
cd ~/CoinBuilds

output "This script assumes you already have the dependicies installed on your system!"
output ""
read -e -p "Enter the name of the coin : " coin
read -e -p "Paste the github link for the coin : " git_hub
read -e -p "How many threads must be used at least > 1 (This depends on the number of available threads the cpu has)!! : " threads
if [[ ! -e '$coin' ]]; then
    sudo  git clone $git_hub  $coin
elif [[ ! -d ~$CoinBuilds/$coin ]]; then
    output "Coinbuilds/$coin already exists.... Skipping" 1>&2
    output "Can not continue"
    exit 0
fi

cd "${coin}"
cd src

if [ -f rpcrawtransaction.cpp ]; then

sudo sed -i 's/<const\ CScriptID\&/<CScriptID/' rpcrawtransaction.cpp
sudo sed -i 's/<CScriptID&>/<CScriptID>/g' rpcrawtransaction.cpp

fi
sudo mkdir obj/crypto
sudo mkdir -p obj/zerocoin && sudo chmod +x leveldb/build_detect_platform
cd ..
if [ -f autogen.sh ]; then
    sudo chmod +x ./autogen.sh
    sudo ./autogen.sh
    sudo chmod +x ./configure
    sudo ./configure CPPFLAGS="-I/usr/local/include"
    sudo chmod +x share/genbuild.sh
    sudo make -j $threads
    output "$coin_name finished and can be found in CoinBuilds/$coin/src/ Make sure you sudo strip Coind and coin-cli if it exists, copy to /usr/bin"
    output "Like my scripts? Please Donate to BTC Donation: 1FKxuqNi8ZfzWHtUyLR2kogpXihbZchSuD"
    exit 0
else
    cd src
    sudo mkdir -p obj
    cd leveldb
    sudo chmod +x build_detect_platform
    sudo make clean
    sudo make libleveldb.a libmemenv.a
    cd ..
    sudo make -j $threads -f makefile.unix
    output "$coin finished and can be found in CoinBuilds/$coin/src/ Make sure you sudo strip Coind and coin-cli if it exists, copy to /usr/bin"
    output "Like my scripts? Please Donate to BTC Donation: 1FKxuqNi8ZfzWHtUyLR2kogpXihbZchSuD"
    exit 0*
fi
