#!/bin/bash

#**********begin program**********
#======preparation for work=======

dirpath=$(pwd)
dirpath="$dirpath/task4_1.out"
ffind=$(ls -la | grep 'task4_1.out' | wc -l);
# echo "$ffind"
if [ $ffind -eq 0 ]
then
 touch $dirpath
else
cat /dev/null>$dirpath
fi

#============find data============

echo "---Hardware---">>$dirpath

#============find CPU============
string=$(lscpu | grep 'Model name:' | grep -o ':.*' | grep -o '[^:].*' | sed 's/^[ \t]*//');
echo "CPU: $string">>$dirpath

#============find RAM============
string=$(cat /proc/meminfo | grep 'MemTotal:' | grep -o ':.*' | grep -o '[^:].*' | sed 's/^[ \t]*//');
echo "RAM: $string">>$dirpath

#============find Motherboard============
string=$(dmidecode --string baseboard-product-name);
echo "Motherboard: $string">>$dirpath


#============find System Serial Number============
string=$(dmidecode | grep -A4 "Base B" | grep "Serial Number" | grep -o ':.*' | grep -o '[^:].*' | sed 's/^[ \t]*//');
echo "System Serial Number: $string">>$dirpath


echo "---System---">>$dirpath

#============find OS ============
string=$(/usr/bin/lsb_release -ircd | grep 'Description:' | grep -o ':.*' | grep -o '[^:].*' | cut -c 2-);
echo -e "OS Description: $string">>$dirpath

#============Kernel Version ============
string=$(uname -r);
echo "Kernel version: $string">>$dirpath

#============Installation date ============
string=$(tune2fs -l /dev/sda1 | grep create | grep -o ':.*' | grep -o '[^:].*' | sed 's/^[ \t]*//');
echo "Installation date: $string">>$dirpath

#============Hostname ============
string=$(hostname);
echo "Hostname: $string">>$dirpath

#============Uptime ============
string=$(uptime | grep -o '.* up' | grep -o '.*[^up]' | sed 's/^[ \t]*//');
echo "Uptime: $string">>$dirpath

#============Processes running ============
string=$(ps -A | wc -l);
echo "Processes running: $string">>$dirpath

#============User logged in ============
string=$(who| awk '{print $1}' | sed 's/^[ \t]*//');
nuser=$(id -u $string);
echo "User logged in: $nuser">>$dirpath

#============find net setting ============

echo "--- Network ---">>$dirpath

ffind=$(ls -la | grep 'tempnet' | wc -l);
# echo "$ffind"
if [ $ffind -eq 0 ]
then
 touch tempnet
else
cat /dev/null>tempnet
fi


#rm tempnet
#touch tempnet;

ifconfig | grep -v "^[[:space:],\t]" | grep -v "^$" | awk '{print $1}'>>tempnet
dev=$(cat tempnet | wc -l);

numm=0;

ifconfig | grep 'inet addr:' | cut -c 11- | sed 's/B\S*\s/ /' | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'>>tempnet


ii=$dev;

for (( i=1; i <= $ii; i++ ))
do
let i1=$i*$ii+1;
let i2=$i1+1;
#ip=$("0.0.0.0");
#
ng=$(head -n $i1 tempnet | tail -n 1 | grep '0.0.0.0' | wc -l);
echo "$ng"
if [ "$ng" -eq "1" ] 
then
let ip=('-')
else
ip=$(head -n $i1 tempnet | tail -n 1)
fi

#ng=$(head -n $i1 tempnet | tail -n 1);

ma=$(head -n $i2 tempnet | tail -n 1);
    case $ma in

   0.0.0.0)
         let ma=("-")
          ;;
     128.0.0.0)
          let ma=("1")
          ;;
     192.0.0.0)
         let  ma=("2")
          ;;
     224.0.0.0)
         let  ma=("3")
          ;; 
     240.0.0.0)
          let ma=("4")
          ;;
     248.0.0.0)
          let ma=("5")
          ;;
     252.0.0.0)
          let ma=("6")
          ;;
     254.0.0.0)
          let ma=("7")
          ;;
     255.0.0.0)
          let ma=("8")
          ;;
255.128.0.0)
          let ma=("9")
          ;;
255.192.0.0)
        let ma=("10")
          ;;
255.224.0.0)
         let ma=("11")
          ;;
255.240.0.0)
         let ma=("12")
          ;;
255.248.0.0)
          let ma=("13")
          ;;
255.252.0.0)
          let ma=("14")
          ;;
255.252.0.0)
          let ma=("15")
          ;;
255.254.0.0)
         let ma=("16")
          ;;   
255.255.128.0)
          let ma=("17")
          ;;
255.255.192.0)
          let ma=("18")
          ;;
255.255.224.0)
          let ma=("19")
          ;;
255.255.240.0)
          let ma=("20")
          ;;
255.255.248.0)
          let ma=("21")
          ;;
255.255.252.0)
         let ma=("22")
          ;;
255.255.254.0)
          let ma=("23")
          ;;
255.255.255.0)
          let ma="24"
          ;;
255.255.255.128)
          let ma=("25")
          ;;
255.255.255.192)
          let ma=("26")
          ;;
255.255.255.224)
          let ma=("27")
          ;;
255.255.255.240)
          let ma=("28")
          ;;
255.255.255.248)
          let ma=("29")
          ;;
255.255.255.252)
          let ma=("30")
          ;;
255.255.255.254)
          let ma=("31")
          ;;
255.255.255.255)
          let ma=("32")
esac


#
et=$(head -n $i tempnet | tail -n 1);
#ip=$(head -n $i1 tempnet | tail -n 1);
#ma=$(head -n $i2 tempnet | tail -n 1);
numm=$(($numm+1));
echo "<iface\#$numm $et>: $ip/$ma">>$dirpath;

done

#rm tempnet


#echo "============result============"
#cat $dirpath
