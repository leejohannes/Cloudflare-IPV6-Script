# Cloudflare-IPV6-Script
DDNS auto update to Cloudflare.</p>
Only using AWK,curl.</p>
simple not need python or jq.</p>

##JSON format is sensitive...
you may add `|tr -d '\n'`.</p>
or rewrite with jq...</p>
##How to use?
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
