#!/bin/bash

CURRENT_IP=$(ip addr | grep inet6 \
    | grep global | grep -v 'fd' \
    | grep -v 'fc'|awk '{print $2}' \
    | awk -F '/' '{print $1}'|awk 'NR==1{print; exit}'
    )

#API设置
API="Your API TOKEN"
SUBDOMAIN="Your Sub Domain"
TYPE="AAAA"

CLOUDFLARE_DNS(){
    #获取指定域名的zone id
    local ZONE_API_URL="https://api.cloudflare.com/client/v4/zones"
    local ZONE_RESPONSE=$(curl -s -X GET "$ZONE_API_URL" \
        -H "Authorization: Bearer $API" \
        -H "Content-Type:application/json")
    local ZONE_ID=$(echo "$ZONE_RESPONSE"| awk -F'"id":' '{print $2}'| awk -F'"' '{print $2}')
    echo Zone ID : $ZONE_ID
    DOMAIN_NAME=$(echo "$ZONE_RESPONSE" | awk -F'"name":' '{print $2}' | awk -F'"' '{print $2}')
    echo Domain : $DOMAIN_NAME
    RECORD_NAME="$SUBDOMAIN"".""$DOMAIN_NAME"
    echo Recode Name : $RECORD_NAME

    #获取指定域名的DNS记录
    local RECORD_API_URL="https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records"
    local RECORD_RESPONSE=$(curl -s -X GET "$RECORD_API_URL" \
            -H "Authorization: Bearer $API" \
            -H "Content-Type: application/json")
    local a="awk -F'\"name\":\"$RECORD_NAME\"' '{print \$2}' | awk -F'\"type\":\"$TYPE\"' '{print \$2}' | awk -F'\"content\":\"' '{print \$2}' | awk -F'\"' '{print \$1}'"
    local CONTENT=$(echo "$RECORD_RESPONSE" | eval "$a")
    echo DNS Record : $CONTENT
    #a="awk -F'\"name\":\"$RECORD_NAME\"' '{print \$0}' | awk -F'\"id\":\"' '{print \$2}' | awk -F'\"' '{print \$1}'F"
    local a="awk -F'\",\"name\":\"$RECORD_NAME\"' '{print \$1}'"
    local RECORD_ID=$(echo "$RECORD_RESPONSE" | eval "$a")
    local RECORD_ID=${RECORD_ID:0-32}
    echo Record ID : $RECORD_ID

    #更新指定域名的DNS记录
    local UPDATE_API_URL="https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID"
    echo -e "\e[1;91m=========================\e[0m"
    local UPDATE_RESPONSE=$(curl -X PUT $UPDATE_API_URL \
        -H "Authorization: Bearer $API" \
        -H "Content-Type: application/json" \
        --data "{
            \"type\": \"$TYPE\",
            \"name\": \"$RECORD_NAME\",
            \"content\": \"$CURRENT_IP\"
        }")
    echo -e "\e[1;91m=========================\e[0m"
    local a=$(echo $UPDATE_RESPONSE | awk -F '"success":' '{print($2)}'|awk -F',' '{print $1}')
    echo "success":$a
    if [ "$a" == "true" ];then
        echo $CURRENT_IP > ddns_v6.log
        echo 1 >> ddns_v6.log
    fi
}

#获取现在的IPV6
echo $CURRENT_IP -- ipv6 now
#获取以前存储的IPV6
SAVED_IP=$(awk 'NR==1{print; exit}' ddns_v6.log)
echo $SAVED_IP -- ipv6 before
#判断是否相同
if [ "$SAVED_IP" == "$CURRENT_IP" ];then
    echo same
    #读取第二行查看是否同步了
    SYN_STATUS=$(sed -n '2p' ddns_v6.log)
    if [ "$SYN_STATUS" == "1" ]; then
        echo -e "SYNED \nNo need update\nAdd \e[91m-f\e[0m to force update"
    else
        echo not SYNED
        CLOUDFLARE_DNS
    fi
else
    echo not same
    CLOUDFLARE_DNS
fi
if [ "$1" == "-f" ];then
    CLOUDFLARE_DNS
fi
