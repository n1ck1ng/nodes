// Подключитесь к удаленному серверу и запустите скрипт. 
// подключение к серверу

    ssh root@yourip

// for example 
// ssh root@176.123.112.222

// перейдите на сайт  https://faucet.arweave.net/ создать кошелек и скачть .json

// переименовать файл в arweave.json

// скопировать файл на сервер (команда выполняется на локальном устройстве)

    scp path/myfile user@ip_adree:/root/

// for example
// scp /Users/a1/Downloads/arweave.json root@176.123.112.222:/root/

// установите wget

    sudo apt-get install wget
    
// запустите скрипт, введя команду. 

    wget -q -O KYVE_protokol.sh https://raw.githubusercontent.com/n1ck1ng/nodes/main/KYVE/KYVE_protokol.sh && chmod +x KYVE_protokol.sh && sudo /bin/bash KYVE_protokol.sh
    
// введите запрашиваемые данные: номер пула, мнемонику и стейк. 




// remove validator 

sudo systemctl stop kyved && \
sudo systemctl disable kyved &&\
rm -Rvf /usr/bin/kyve* $HOME/kyve &&\
sudo rm -v /etc/systemd/system/kyved.service && \
sudo systemctl daemon-reload &&\

// reload

sudo systemctl restart kyved

// check logs

sudo journalctl -u kyved -f -o cat

