#!/bin/bash

clear
curl -s https://raw.githubusercontent.com/n1ck1ng/files/main/logo.sh | \
	bash && sleep 1

sudo apt update && sudo apt upgrade -y

sudo apt install curl
sudo apt install git
curl https://deb.nodesource.com/setup_14.x | sudo bash
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt upgrade -y
sudo apt install nodejs=14.* yarn build-essential jq -y

read -p "Enter POOL number: " POOL_ID
read -p "Enter your SELFSTAKE: " STAKE
read -p "Enter SEED a.k.a. MNEMONIC: " SEED

echo "export POOL_ID=$POOL_ID" >> $HOME/.bash_profile
echo "export STAKE=$STAKE" >> $HOME/.bash_profile

source $HOME/.bash_profile

git clone https://github.com/kyve-org/kysor
cd $HOME/kysor


mkdir $HOME/kysor/secrets
echo $SEED > $HOME/kysor/secrets/mnemonic.txt

mv /root/arweave.json /root/kysor/secrets/arweave.json


tee $HOME/kysor/kysor.conf.ts > /dev/null <<EOF
import { IConfig } from "./src/faces";
const config: IConfig = {
  // target of the host machine, can be either "linux" or "macos"
  // important for downloading the correct binaries
  hostTarget: "linux",
  
  // whether KYSOR should auto download new binaries
  // if set to false, you have to insert the binaries manually
  autoDownload: true,
  
  // whether KYSOR should verify the checksums of downloaded binaries
  // if autoDownload is false this option can be ignored
  verifyChecksums: true,
  
  // settings for protocol node
  // notice that mnemonic and keyfile is missing, those need to be files under the secrets directory
  protocolNode: {
    // the ID of the pool you want to join as a validator
    // an overview of all pools can be found here -> https://app.kyve.network
    poolId: $POOL_ID,
    
    // the network you want to run on
    // currently only the testnet network "korellia" is available
    network: "korellia",
    
    // the amount of $KYVE you want to stake
    // will only get applied if you are not a validator yet
    // once you are a validator you can manage your stake in the KYVE app
    initialStake: $STAKE,
    
    // the amount of bytes the node can use at max to cache data
    // 1000000000 equals 1 GB which is usually enough
    space: 1000000000,
    
    // specify verbose logging
    // is often recommended in order to have a more detailed insight
    verbose: true,
  },
};

export default config;
EOF

cd $HOME/kysor
yarn install
yarn build

sudo tee <<EOF >/dev/null /etc/systemd/system/kyved.service
[Unit]
Description=Protocol Node
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$HOME/kysor
ExecStart=yarn start
Restart=on-failure
RestartSec=3
LimitNOFILE=4096
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload && sudo systemctl enable kyved && sudo systemctl start kyved

journalctl -u kyved -f -o cat

# anyway merci https://teletype.in/@bitdealer91/5lrNopqh68k#mS7Q
