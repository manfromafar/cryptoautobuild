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
cd

sudo mkdir -p ~/CoinBuilds
sudo mkdir CoinBuilds
cd ~/CoinBuilds

output "This script assumes you already have the dependicies installed on your system!"
output ""
read -e -p "Enter the name of the coin : " coin
read -e -p "Paste the github link for the coin : " git_hub
read -e -p "How many threads must be used at least > 1 [1/8] depending on CPU! : " threads
read -e -p "Rename and replace to bin folder [y/n] : " replace

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
    
    getDeamon()
    {
         for deamon in `find -type f -name "*d" `; do [ -x $deamon ]; done
         echo $deamon
    }
    getCli()
    {
        for cli in `find -type f -name "*-cli" `; do [ -x $cli ]; done
        echo $cli
    }
    getTx()
    {
         for tx in `find -type f -name "*-tx" `; do [ -x $tx ]; done
         echo $tx
    }
    if [ $replace == "y" ]; then
        if [ ! -z $(getDeamon) ]; then
            Deamon=$(getDeamon)
            sudo cp $Deamon /usr/bin/$coin"Wallet"
        else
            echo "No Deamon is found"
        fi
        
        if [ ! -z $(getCli) ]; then
            Cli=$(getCli)
            sudo cp $Cli /usr/bin/$coin"Wallet-cli"
        else
            echo "No Deamon-Cli if found"
        fi
        
        if [ ! -z $(getTx) ]; then
            Tx=$(getTx)
            sudo cp $Tx /usr/bin/$coin"Wallet-tx"
        else
            echo "No Deamon-Tx is found"
        fi  
        output "$coin_name finished and can be used as "$coin"Wallet"
        output "Like my scripts? Please Donate to BTC Donation: 1FKxuqNi8ZfzWHtUyLR2kogpXihbZchSuD"
        exit 0
    else 
        output "$coin_name finished and can be found in CoinBuilds/$coin/src/ Make sure you sudo strip Coind and coin-cli if it exists, copy to /usr/bin"
        output "Like my scripts? Please Donate to BTC Donation: 1FKxuqNi8ZfzWHtUyLR2kogpXihbZchSuD"
        exit 0 
    fi
else
    cd src
    sudo mkdir -p obj
    cd leveldb
    sudo chmod +x build_detect_platform
    sudo make clean
    sudo make libleveldb.a libmemenv.a
    cd ..
    sudo make -j $threads -f makefile.unix
    getDeamon()
    {
        for deamon in `find -type f -name "*coind" `; do [ -x $deamon ]; done
        echo $deamon
    }
    getCli()
    {
        for cli in `find -type f -name "*coin-cli" `; do [ -x $cli ]; done
        echo $cli
    }
    getTx()
    {
        for tx in `find -type f -name "*coin-tx" `; do [ -x $tx ]; done
        echo $tx
    }
    if [ $replace == "y" ]; then
        if [ ! -z $(getDeamon) ]; then
            Deamon=$(getDeamon)
            sudo cp $Deamon /usr/bin/$coin"Wallet"
        else
            echo "No Deamon is found"
        fi
        if [ ! -z $(getCli) ]; then
            Cli=$(getCli)
            sudo cp $Cli /usr/bin/$coin"Wallet-cli"
        else
            echo "No Deamon-Cli if found"
        fi
       if [ ! -z $(getTx) ]; then
            Tx=$(getTx)
            sudo cp $Tx /usr/bin/$coin"Wallet-tx"
        else
            echo "No Deamon-Tx is found"
        fi  
        output "$coin_name finished and can be used as "$coin"Wallet"
        output "Like my scripts? Please Donate to BTC Donation: 1FKxuqNi8ZfzWHtUyLR2kogpXihbZchSuD"
        exit 0
    else
        output "$coin finished and can be found in CoinBuilds/$coin/src/ Make sure you sudo strip Coind and coin-cli if it exists, copy to /usr/bin"
        output "Like my scripts? Please Donate to BTC Donation: 1FKxuqNi8ZfzWHtUyLR2kogpXihbZchSuD"
        exit 0
    fi
fi
