//Подключитесь к удаленному серверу или запустите скрипт на локальной машине.
//подключение к серверу

    ssh root@yourip

//for example 
// ssh root@176.123.112.222

//перейдите на сайт  https://faucet.arweave.net/ создать кошелек и скачть .json
//переименовать файл в arweave.json

    scp path/myfile user@ip_adree:/full/path/to/new/location/

//for example
// scp /Users/a1/Downloads/arweave.json root@176.123.112.222/root/

//установите wget

    sudo apt-get install wget
    
//запустите скрипт, введя команду. 

    wget -q -O KYVE_protokol.sh https://github.com/n1ck1ng/nodes/blob/main/KYVE/KYVE_protokol.sh && chmod +x KYVE_protokol.sh && sudo /bin/bash KYVE_protokol.sh
