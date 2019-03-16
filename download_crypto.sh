#!/bin/bash


cd /Users/kevin/Data/Stocks/Data/

wget https://coinmetrics.io/data/btc.csv

wget https://coinmetrics.io/data/ltc.csv

wget https://coinmetrics.io/data/eth.csv

wget https://coinmetrics.io/data/bch.csv #bitcoin cash

wget https://coinmetrics.io/data/doge.csv

#wget https://coinmetrics.io/data/etc.csv

wget https://coinmetrics.io/data/btg.csv



mv /Users/kevin/Data/Stocks/Data/btc.csv /Users/kevin/Data/Stocks/Data/BTC.csv 
#rm /Users/kevin/Data/Stocks/Data/btc.csv

mv /Users/kevin/Data/Stocks/Data/ltc.csv /Users/kevin/Data/Stocks/Data/LTC.csv 
#rm /Users/kevin/Data/Stocks/Data/ltc.csv

mv /Users/kevin/Data/Stocks/Data/eth.csv /Users/kevin/Data/Stocks/Data/ETH.csv 
#rm /Users/kevin/Data/Stocks/Data/eth.csv

mv /Users/kevin/Data/Stocks/Data/bch.csv /Users/kevin/Data/Stocks/Data/BCH.csv 

mv /Users/kevin/Data/Stocks/Data/doge.csv /Users/kevin/Data/Stocks/Data/DOGE.csv 

#mv /Users/kevin/Data/Stocks/Data/etc.csv /Users/kevin/Data/Stocks/Data/ETC.csv 

mv /Users/kevin/Data/Stocks/Data/btg.csv /Users/kevin/Data/Stocks/Data/BTG.csv 


exit