#!/bin/bash

###
##
##            Name:  geo
##         Purpose:  Commandline tool to Find Country location from devices WAN IP using API call and check against a list of Country names.
##                   If script run with no IP/FQDN, will use your current WAN IP. 
##                   If IP or FQDN specified will process that.
##                   Dependant on cli tool jq being installed on your system.
##         Created:  2019-12-01
##   Last Modified:  2022-08-20
##         Version:  3
##          Source: https://stackoverflow.com/questions/12030316/nesting-if-in-a-for-loop
##                  https://www.programiz.com/python-programming/nested-dictionary
##                  https://stackoverflow.com/questions/50843960/curl-json-to-output-only-one-object
##                  https://stedolan.github.io/jq/tutorial/
##                  https://stackoverflow.com/questions/18709962/regex-matching-in-a-bash-if-statement
##                  https://apple.stackexchange.com/questions/237030/how-to-get-the-geolocation-of-an-ip-address-in-terminal
###

##===========================VARIABLES============================##
## Setup the colour codes.
RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

## Check if you have jq installed. Can do this via $ brew install jq
if [ ! -f "$(which jq)" ]; then
  echo -e "${RED}*** ERROR: you need to install cli tool jq to run this script ***${NOCOLOR}"
  exit 1
fi

#Variable to evaluate if letters used in the target address, such as a FQDN.
targetHasLetters="[a-zA-Z]"

## Finds WAN IP via dig command using opendns. Captures IP address only.
if test -z "$1"; then
  ##If $1 is empty, will set your current WAN IP with dig - @resolver1.opendns.com or @208.67.222.220
  wanIP=$(/usr/bin/dig +short myip.opendns.com @208.67.222.220)
elif [[ $1 =~ $targetHasLetters ]]; then
  ##Elif a hostname used. Find IP address by doing a lookup on the A record.
  domainName=$(/usr/bin/dig "$1" +short @208.67.222.220)
  wanIP=$(echo -e "$domainName" | head -1)
  if [[ -z $wanIP ]]; then
    echo -e "${RED}*** Error: $1 - Could not be resolved by 208.67.222.220 ***${NOCOLOR}" && exit 1
  fi
  echo -e "Hostname using the following IP:"
  echo -e "$domainName"
else
  ##Else just an IP address has been entered.
  wanIP=$1
fi


## I have no affiliate to freegeoip.app and this script will break if website is down.
## ipJson=$(curl -s -X GET https://freegeoip.app/json/"$wanIP") 

ipJson=$(curl -s -X GET https://ipinfo.io/"$wanIP") 

if echo -e "$ipJson" | grep "error" &> /dev/null; then
  echo -e "${RED}"
  echo -e "$ipJson" | jq -r .error
  echo -e "${NOCOLOR}INFO: Make sure to enter a valid public IP address.\nRun command on its own to use your current WAN IP address."
  exit 1
elif [ "$(echo -e "$ipJson" | jq -r .bogon)" = "true" ]; then
  echo -e "${RED}*** ERROR: Cannot geo locate provided IP address ***${NOCOLOR}\n
  Info: A Bogon is an IP Address which falls into a set of addresses that have not been officially assigned.\
  This can also cover assigned private IP addresses. Know your RFC5735 RFC1918\n"
  exit 1

else
  echo -e "\n"
  echo -e "Target IP: \t$wanIP"
  echo -e "City: \t\t$(echo "$ipJson" | jq -r .city)"
  echo -e "Region: \t$(echo "$ipJson" | jq -r .region)"
  echo -e "Country Code: \t$(echo "$ipJson" | jq -r .country)"
  #echo -e "Country: \t$(echo "$ipJson" | jq -r .country_name)"
  echo -e "Zip Code: \t$(echo "$ipJson" | jq -r .postal)"
  echo -e "Time Zone: \t$(echo "$ipJson" | jq -r .timezone)"
  echo -e "Org: \t\t$(echo "$ipJson" | jq -r .org)"
  latitudeLongitude=$(echo -e "$(echo "$ipJson" | jq -r .loc)")
  echo -e "PTR: \t\t$(dig -x "$wanIP" +short)"
  echo -e "\n"

  ##  freegeoip.app Version
  #echo -e "\n"
  #echo -e "Target IP: \t$wanIP"
  #echo -e "Country Code: \t$(echo "$ipJson" | jq -r .country_code)"
  #echo -e "Country: \t$(echo "$ipJson" | jq -r .country_name)"
  #echo -e "Region: \t$(echo "$ipJson" | jq -r .region_name)"
  #echo -e "City: \t\t$(echo "$ipJson" | jq -r .city)"
  #echo -e "Zip Code: \t$(echo "$ipJson" | jq -r .zip_code)"
  #echo -e "Time Zone: \t$(echo "$ipJson" | jq -r .time_zone)"
  #latitude=$(echo -e "$(echo "$ipJson" | jq -r .latitude)")
  #longitude=$(echo -e "$(echo "$ipJson" | jq -r .longitude)")
  #echo -e "PTR: \t\t$(dig -x "$wanIP" +short)"
  #echo -e "\n"

fi


##Create a couple more variables:
googleMap="https://www.google.com/maps/search/?api=1&query=$latitudeLongitude&z=13"
#googleMap="https://www.google.com/maps/search/?api=1&query=$latitude,$longitude&z=13"
#googleMap="https://maps.google.com/?ie=UTF8&hq=&ll=$longitude,$latitude&z=13"
virusTotal="https://www.virustotal.com/gui/ip-address/$wanIP"
talosNetwork="https://talosintelligence.com/reputation_center/lookup?search=$wanIP"

##Display the interactive menu:
##https://askubuntu.com/questions/1705/how-can-i-create-a-select-menu-in-a-shell-script
PS3="Type Number to open Website: "
options=("$googleMap" "$virusTotal" "$talosNetwork" "Quit")
select opt in "${options[@]}"
do
  case $opt in
    "$googleMap")
      echo -e "${GREEN}Opening Google Maps${NOCOLOR}" && open "$googleMap"
      break
      ;;
    "$virusTotal")
      echo -e "${GREEN}Opening Virus Total${NOCOLOR}" && open "$virusTotal"
      break
      ;;
     "$talosNetwork")
      echo -e "${GREEN}Opening Talos Intelligence${NOCOLOR}" && open "$talosNetwork"
      break
      ;;
    "Quit")
      break
      ;;
    *) echo -e "${RED}$REPLY is not a valid option${NOCOLOR}";;
  esac
done


exit $?
