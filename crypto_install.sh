
#!/bin/bash
################################################################################
# Author: gregmag
#
# Web: www.swisscryptopool.ch
#
# Program:
#   After entering coin name and github link automatically build coin
# BTC Donation: 
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

cd ~/CoinBuilds

output "This script install a crypto currency on your system!"
output ""
read -e -p "Enter the symbole of the coin : " coin
read -e -p "Enter the name of the coin : " coinname
read -e -p "Enter the name of the daemon : " coindaemon
read -e -p "Enter the name of the directory : " coindir
read -e -p "Enter the link of the bootstrap : " coinboot

cd "${coin}"
cd src

sudo strip ${coindaemon}
sudo cp ${coindaemon} /usr/bin

if [ -f ${coinname}-cli ]; then
    sudo strip ${coinname}-cli
    sudo cp ${coinname} /usr/bin
fi
if [ -f ${coinname}-tx ]; then
    sudo strip ${coinname}-tx
    sudo cp ${coinname} /usr/bin
fi

cd ..
cd ..
cd ..

/usr/bin/${coindaemon}

sudo nano ${coindir}/${coinname}.conf

if [[ "$coinboot" != "" ]]; then
    sudo wget -P ${coindir} ${coinboot}
fi

sudo chown -R greg ${coindir}/

echo '
[Unit]
Description='"${coinname}"' daemon
After=network.target

[Service]
ExecStart=/usr/bin/'"${coindaemon}"' -daemon -conf=/home/greg/'"${coindir}"'/'"${coinname}"'.conf

RuntimeDirectory='"${coindir}"'
User=greg
Type=forking
PIDFile=/home/greg/'"${coindir}"'/'"${coindaemon}"'.pid
Restart=on-failure
PrivateTmp=true

[Install]
WantedBy=multi-user.target
' | sudo -E tee /usr/lib/systemd/system/${coinname}.service >/dev/null 2>&1


sudo systemctl daemon-reload



cd /var/web/images/
sudo curl -Lo coin-${coin}.png https://www.cryptopia.co.nz/Content/Images/Coins/${coin}-small.png


if [[ "$coinboot" != "" ]]; then
    sudo wget -P ${coindir} ${coinboot}
else
    output "Decompress bootstrap and type :"
    output "sudo systemctl start ${coinname}"
    output "sudo systemctl enable ${coinname}"
fi
output ""
output "Finished !"
