# Cloudflare-IPV6-Script
DDNS auto update to Cloudflare.
Only using AWK,curl.
simple not need python or jq.
##JSON format is sensitive...
you may add `|tr -d '\n'`.
or rewrite with jq...
##How to use?
download and upload to you root home.
set your `API Token` with `Edit zone DNS`.
only supoort this.
```
bash ./ddns_v6.sh
```
depends on your shell.
