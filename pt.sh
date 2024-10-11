#!/bin/bash
#Student name: Ricky Woon
#Student code: S37
#Class code: CFC130124
#Trainer: Kar Wei

#Function for ftp bruteforce 
brute_ftp () {
	ftp=$(cat $outdir/nmap.txt | grep -w ftp | wc -l)
	ftpp=$(cat $outdir/nmap.txt | grep -w ftp | awk '{print $1}' | head -n 1 | awk -F/ '{print $1}')
		if [[ $ftp -gt 0 ]]; then
			echo "Attacking FTP, please wait..."
			#Hides attack process, save result as ftp.txt
			hydra -L $UL -P $PL $network -s $ftpp ftp -vV -o $outdir/ftp.txt > /dev/null 2>&1
			echo "Attack completed, displaying results:"
			echo ''
			cat $outdir/ftp.txt
			sleep 5
		fi
}

#Function for ssh bruteforce 
brute_ssh () {
	ssh=$(cat $outdir/nmap.txt | grep -w ssh | wc -l)
	sshp=$(cat $outdir/nmap.txt | grep -w ssh | awk '{print $1}' | head -n 1 | awk -F/ '{print $1}')
		if [[ $ssh -gt 0 ]]; then
			echo "Attacking SSH, please wait..."
			#Hides attack process, save result as ssh.txt
			hydra -L $UL -P $PL $network -s $sshp ssh -vV -o $outdir/ssh.txt > /dev/null 2>&1
			echo "Attack completed, displaying results:"
			echo ''
			cat $outdir/ssh.txt
			sleep 5
		fi
}

#Function for telnet bruteforce 
brute_tel () {
	tel=$(cat $outdir/nmap.txt | grep -w telnet | wc -l)
	telp=$(cat $outdir/nmap.txt | grep -w telnet | awk '{print $1}' | head -n 1 | awk -F/ '{print $1}')
		if [[ $tel -gt 0 ]]; then
			echo "Attacking TELNET, please wait..."
			#Hides attack process, save result as telnet.txt
			medusa -h $network -U $UL -P $PL -M telnet -n $telp -t 4 -O $outdir/telnet.txt > /dev/null 2>&1
			echo "Attack completed, displaying results:"
			echo ''
			cat $outdir/telnet.txt
			sleep 5
		fi
}

#Function for rdp bruteforce 
brute_rdp () {
	rdp=$(cat $outdir/nmap.txt | grep -w rdp | wc -l)
	rdpp=$(cat $outdir/nmap.txt | grep -w rdp | awk '{print $1}' | head -n 1 | awk -F/ '{print $1}')
		if [[ $rdp -gt 0 ]]; then
			echo "Attacking RDP, please wait..."
			#Hides attack process, save result as rdp.txt
			hydra -L $UL -P $PL $network -s $rdpp rdp -vV -o $outdir/rdp.txt > /dev/null 2>&1
			echo "Attack completed, displaying results:"
			echo ''
			cat $outdir/rdp.txt
			sleep 5
		fi
}

#Introduction
echo "Welcome to project: Vulner"
echo "This is a script that scans for open ports, finding out weak passwords, and performs vulnerability assessment(Full)."
echo ''

#Get from user a network to scan.
echo "Please provide a network to scan:"
read network

echo ''

#Check if input matches a network format.
regex='^([0-9]{1,3}[\.]){3}[0-9]{1,3}'

if [[ "$network" =~ $regex ]]; then
  echo "Network to scan is: $network"
else
  echo "Invalid input! Please provide a valid network to scan, exiting now!"
  exit
fi

echo ''

#Get from user a name for the output directory.
echo "Please provide a name for the output directory:"
read outdir
mkdir $outdir
echo ''
echo "Name of output directory is: $outdir"

echo ''

#Allow the user to choose 'Basic' or 'Full'.
echo "Choose type of scan: A (BASIC) or B (FULL)."
read option
echo ''

case $option in

	a|A)
		echo "You have chosen BASIC. Performing TCP scan now, please wait..."
		echo ''
		#Hides scanning process, save result as nmap.txt
		sudo nmap -sV -p- $network -oN $outdir/nmap.txt > /dev/null 2>&1
		#Display results
		echo "Displaying scanned results for 30s:"
		sleep 5
		echo ''
		cat $outdir/nmap.txt
		sleep 30
		echo ''
		echo "Performing UDP scan now, please wait..."
		echo ''
		#Hides scanning process, save result as masscan.txt
		sudo masscan -pU:1-65535 $network --rate=50000 -oG $outdir/masscan.txt > /dev/null 2>&1
		#Display results
		echo "Displaying scanned results for 30s:"
		sleep 5
		echo ''
		cat $outdir/masscan.txt
		sleep 30
		echo ''
		#Start of bruteforcing stage
		echo "Commencing bruteforce, please provide file path to custom userlist or the provided userlist to be used (eg. /home/kali/xxx)"
		read UL
		echo "Please provide file path to custom passwordlist or the provided passwordlist to be used (eg. /home/kali/xxx)"
		read PL
		echo ''
		echo "Commencing attack, this may take a while, please wait..."
		echo ''
		brute_ftp
		echo ''
		brute_ssh
		echo ''
		brute_tel
		echo ''
		brute_rdp
		echo ''
		sleep 5
		echo "BASIC scan completed."
	;;
	
	b|B)
		echo "You have chosen FULL. Performing TCP scan now, please wait..."
		echo ''
		#Hides scanning process, save result as nmap.txt
		sudo nmap -sV -p- $network -oN $outdir/nmap.txt > /dev/null 2>&1
		#Display results
		echo "Displaying scanned results for 30s:"
		sleep 5
		echo ''
		cat $outdir/nmap.txt
		sleep 30
		echo ''
		echo "Performing UDP scan now, please wait..."
		echo ''
		#Hides scanning process, save result as masscan.txt
		sudo masscan -pU:1-65535 $network --rate=50000 -oG $outdir/masscan.txt > /dev/null 2>&1
		#Display results
		echo "Displaying scanned results for 30s:"
		sleep 5
		echo ''
		cat $outdir/masscan.txt
		sleep 30
		echo ''
		#Start of bruteforcing stage
		echo "Commencing bruteforce, please provide file path to custom userlist or the provided userlist to be used (eg. /home/kali/xxx)"
		read UL
		echo "Please provide file path to custom passwordlist or the provided passwordlist to be used (eg. /home/kali/xxx)"
		read PL
		echo ''
		echo "Commencing attack, this may take a while, please wait..."
		echo ''
		brute_ftp
		echo ''
		brute_ssh
		echo ''
		brute_tel
		echo ''
		brute_rdp
		echo ''
		sleep 5
		#Start of vulnerability assessment stage
		echo "Commencing vulnerability assessment, please wait..."
		echo ''
		#vulners nse script will be used to perform assessment, results saved as vulnresult.txt
		sudo nmap -sV --script vulners $network > $outdir/vulnresult.txt
		#Only exploitable results will be shown on screen, preventing information overload.
		echo "Displaying scanned results for 30s:"
		echo ''
		sleep 5
		cat $outdir/vulnresult.txt | grep *EXPLOIT*
		sleep 30
		echo ''
		echo "Full scan completed."
	;;
	
	*)
		echo "Invalid option! Exiting now!"
	;;

esac

#Allow the user the option to zip the results.
echo "Do you wish to zip the results of the scan? (Y/N)"
read zip

case $zip in

	y|Y)
		echo "Zipping results as vulners.zip, please wait..."
		zip -r vulners.zip $outdir
	;;
	
	*)
		echo "Results not zipped."
	;;
	
esac

echo ''
sleep 5
echo "You have reached the end of the program, thank you for your time, exiting now."
