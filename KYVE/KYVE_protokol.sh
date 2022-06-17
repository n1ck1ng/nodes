#!/bin/bash
clear
curl -s https://raw.githubusercontent.com/n1ck1ng/files/main/logo.sh | \
	bash && sleep 1
	
sudo apt-get update && \
sudo apt-get upgrade -y

sudo apt-get install wget unzip jq -y

read -p "Enter POOL number: " POOL

case $POOL in

# THIS IS MOONBEAM
	0)
		REP_NAME="evm" && BIN="kyve-evm" && NAME="moonbeam"
		;;
# THIS IS AVALANCHE
	1)
		REP_NAME="evm" && BIN="kyve-evm" && NAME="avalanche"
		;;
#THIS IS STACKS
	2)
		REP_NAME="stacks" && BIN="kyve-stx" && NAME="stacks"
		;;
# THIS IS BITCOIN
	3)
		REP_NAME="bitcoin" && BIN="kyve-btc" && NAME="bitcoin"
		;;
# THIS IS SOLANA
	4)
		REP_NAME="solana" && BIN="kyve-sol" && NAME="solana"
		;;
# THIS IS ZILLIQA
	5)
		REP_NAME="zilliqa" && BIN="kyve-zil" && NAME="zilliqa"
		;;
# THIS IS NEAR
	6)
		REP_NAME="near" && BIN="kyve-near" && NAME="near"
		;;
# THIS IS CELO
	7)
		REP_NAME="celo" && BIN="kyve-celo" && NAME="celo"
		;;
# THIS IS EVMOS EVM
	8)
		REP_NAME="evm" && BIN="kyve-evm" && NAME="evmos evm"
		;;
# THIS IS COSMOS
	9)
		REP_NAME="cosmos" && BIN="kyve-cosmos" && NAME="cosmos"
		;;
# THIS IS INJECTIVE
	10)
		REP_NAME="cosmos" && BIN="kyve-cosmos" && NAME="injective"
		;;
# THIS IS EVMOS COSMOS
	11)
		REP_NAME="cosmos" && BIN="kyve-cosmos" && NAME="evmos cosmos"
		;;
# THIS IS AXELAR
	12)
		REP_NAME="cosmos" && BIN="kyve-cosmos" && NAME="axelar"
		;;
# THIS IS AURORA
	13)
		REP_NAME="evm" && BIN="kyve-evm" && NAME="aurora"
		;;
# THIS IS CRONOS
	14)
		REP_NAME="cosmos" && BIN="kyve-cosmos" && NAME="cronos"
		;;
# THIS IS TERRA
	15)
		REP_NAME="cosmos" && BIN="kyve-cosmos" && NAME="terra"
		;;
# THIS IS UMEE
	16)
		REP_NAME='cosmos' && BIN='kyve-cosmos' && NAME='umee'
		;;
# THIS IS POLKADOT
	17)
		REP_NAME="substrate" && BIN="kyve-substrate" && NAME="polkadot"
		;;
esac


VER=$(wget -qO- https://api.github.com/repos/kyve-org/${REP_NAME}/releases/latest | jq -r ".tag_name") && \
wget https://github.com/kyve-org/${REP_NAME}/releases/download/${VER}/kyve-linux.zip && \
unzip kyve-linux.zip && \
rm -Rvf kyve-linux.zip __MACOSX && \
chmod u+x kyve-linux && \
mv kyve-linux /usr/bin/${BIN} && \
printf "\n\
Everything's alright, isn't it,mon ami?\n\
Name: $NAME.\n\
Number of pool: $POOL.\n\
Binaric: $BIN.\n\
Binaric version: v $($BIN --version).\n\n"


read -p "Enter your SEED phrase: " SEED
printf "\n"
read -p "Enter SELFSTAKE:" STAKE


sudo tee <<EOF >/dev/null /etc/systemd/system/kyved.service
[Unit]
Description=Kyve Node
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which $BIN) \\
--poolId $POOL \\
--mnemonic "$SEED" \\
--initialStake $STAKE \\
--keyfile /root/arweave.json \\
--network korellia \\
--space 10000000000 \\
--verbose
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF

sleep 1
sudo systemctl daemon-reload && \
sudo systemctl enable kyved && \
sudo systemctl restart kyved
sleep 2
sudo journalctl -u kyved -f -o cat
#anyway merci romanov
