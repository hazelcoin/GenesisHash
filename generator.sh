#!/bin/bash -e
# Copyright William Chew
# This script will 
# 1. Install python and dependencies (If you already have them please remark them out)
# 2. clone GenesisH0 and mine the genesis blocks of main, test and regtest networks (this may take about an hour.  Ctrl-C if it takes too long but ignore the lengthy time displayed by python)

#install python and dependencies
sudo apt-get install python -y
sudo apt-get install python-pip -y
sudo pip install construct==2.5.2 scrypt

# Genesis.py parameters 
COIN_NAME="Batamcoin"
NEWS="The Times 27/Feb/2019 Dozens buried by landslide at unlicensed Indonesia gold mine"
GENESIS_REWARD_PUBKEY=04B3DFC8EA627DF0F1B9D4C3FC8BCB6F8D1147282B5F9AC8A0086CD3B42DDAB8B3B5FAC62BF4EEBA4AFE285DF583ABBAA08D7D58FF33DD098851B3FF86A5A14A7E # I've replaced the pubkey for Batamcoin

generate_hashes()
{
    if [ ! -d GenesisH0 ]; then
        git clone https://github.com/lhartikk/GenesisH0
        pushd GenesisH0
    else
        pushd GenesisH0
        git pull
    fi

    if [ ! -f ${COIN_NAME}-main.txt ]; then
        echo "Mining genesis block... this should take about 30mins depending on your CPU... Ctrl-C if it takes too long but ignore the lengthy time displayed by python"
        python genesis.py -a scrypt -z \"$NEWS\" -p $GENESIS_REWARD_PUBKEY 2>&1 | tee ${COIN_NAME}-main.txt
    else
        echo "Genesis block has already been mined!"
        cat ${COIN_NAME}-main.txt
    fi

    if [ ! -f ${COIN_NAME}-test.txt ]; then
        echo "Mining genesis block of test network...this should take no longer than 30mins depending on your CPU..."
        python genesis.py -a scrypt -z \"$NEWS\" -p $GENESIS_REWARD_PUBKEY 2>&1 | tee ${COIN_NAME}-test.txt
    else
        echo "Genesis block has already been mined!"
        cat ${COIN_NAME}-test.txt
    fi

    if [ ! -f ${COIN_NAME}-regtest.txt ]; then
        echo "Mining genesis block of regtest network... this should take no longer than 30mins depending on your CPU..."
         python genesis.py -a scrypt -z \"$NEWS\" -p $GENESIS_REWARD_PUBKEY 2>&1 | tee ${COIN_NAME}-regtest.txt
    else
        echo "Genesis block already been mined!"
        cat ${COIN_NAME}-regtest.txt
    fi
   
    popd
}

# call arguments verbatim
"$@"