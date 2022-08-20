# geoLocater
Simple script to find geo location of public IP address

To install, add script file to your path.
For example, create a bin directory to your homefolder and add that to your path.
e.g: follow this guide: https://apple.stackexchange.com/questions/99788/os-x-create-a-personal-bin-directory-bin-and-run-scripts-without-specifyin


# Running it:
Type geo in terminal, hit return.
If checkin a specific IP address, 
type: 
`geo 8.8.8.8`



Once it runs against given IP address, you can choose to open google map or virus total.


## Example
```
$ geo 8.8.8.8

Target IP:    8.8.8.8
City:         Mountain View
Region:       California
Country Code: US
Zip Code:     94043
Time Zone:    America/Los_Angeles
Org:          AS15169 Google LLC
PTR:          dns.google.


1) https://www.google.com/maps/search/?api=1&query=37.4056,-122.0775&z=13
2) https://www.virustotal.com/gui/ip-address/8.8.8.8
3) https://talosintelligence.com/reputation_center/lookup?search=8.8.8.8
4) Quit
```
