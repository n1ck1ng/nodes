#!/bin/bash

curl -s https://raw.githubusercontent.com/n1ck1ng/files/main/logo.sh | \
	bash && sleep 1

sudo apt-get update && \
sudo apt-get upgrade -y

sudo apt-get install wget unzip jq -y
POOL=17 && REP_NAME="substrate" && BIN="kyve-substrate" && NAME="polkadot"

VER=$(wget -qO- https://api.github.com/repos/kyve-org/${REP_NAME}/releases/latest | jq -r ".tag_name") && \
wget https://github.com/kyve-org/${REP_NAME}/releases/download/${VER}/kyve-linux.zip && \
unzip kyve-linux.zip && \
rm -Rvf kyve-linux.zip __MACOSX && \
chmod u+x kyve-linux && \
mv kyve-linux /usr/bin/${BIN} && \
printf "\n\
pool_name >>> ${NAME}.\n\
pool__num >>> #${POOL}.\n\
bin__name >>> ${BIN}.\n\
bin___ver >>> v$(${BIN} --version).\n\n"

STAKE=35000
read -p "Enter mnemonic: " MNEMONIC

sudo tee <<EOF >/dev/null /etc/systemd/system/kyved.service
[Unit]
Description=Kyve Node
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which $BIN) \\
--poolId $POOL \\
--mnemonic "$MNEMONIC" \\
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
