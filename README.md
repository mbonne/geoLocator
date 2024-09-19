# geoLocator aka geo

## Install

Simple script to find geo location of public IP address using dig, jq, openDNS resolver, and `https://ipinfo.io`

To install, add script file to your path.

make the directory:
`mkdir -p $HOME/bin`

Then add the following line to ~/.profile, ~/.bashrc, or ~/.zshrc

`export PATH=$HOME/bin:$PATH`

Symlink the script to custom bin folder:
`ln -s /Path/to/Github\ Folders/geoLocator/geo $HOME/bin/geo`

Then reload shell. Quit and reload terminal or:
`source $HOME/.profile`

### Dependancy

Script uses jq to assist with formatting the curl request to ipinfo.io
on macOS you can install with:

`brew install jq`

or preferred method of installing 3rd party apps.

## Usage

Type geo in terminal, hit return.
If checkin a specific IP address,
type:

`geo 8.8.8.8`

Once it runs against given IP address, you can type number from the menu to open one of the url in default webbrowser on your system.

## Example

```shell
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
