# Cloudflare-IPV6-Script
DDNS auto update to Cloudflare.</p>
Only using **`awk`**,**`curl`**.</p>
simple not need python or jq.</p>

## JSON format is sensitive...
you may add `|tr -d '\n'`.</p>
or rewrite with jq...</p>
## How to use?
download and upload to you root home.</p>
```
curl https://raw.githubusercontent.com/leejohannes/Cloudflare-IPV6-Script/refs/heads/main/ddns_v6.sh -o ddns_v6.sh
```
set your `API Token` with `Edit zone DNS`.</p>
only supoort this.</p>
```
bash ./ddns_v6.sh
```
depends on your shell.</p>
## Force Update to Cloudflare
```
bash ./ddns_v6.sh -f
```
## How it run?
check IPVP by ip addr, since ipv6 can give to each device</p>
compare with `log`，same won't trigger synchronizing Data</p>
if not same or dont have will start synchronizing:
1. check ZONE ID
2. check DNS recorders
3. update DNS recorder



