#!/bin/bash

if [ -z $AD_LINE_TOKEN ];then
    echo AD_LINE_TOKEN is not set
    exit 1
fi

line_token=$AD_LINE_TOKEN


# line_notify message
line_notify(){
    res=`curl -s https://notify-api.line.me/api/notify \
        -X POST \
        -H "authorization: Bearer $line_token" \
        --data-urlencode message="$1 is down"`
    unset res
}

# test_url url name
test_url(){
    res=`curl $1 -o /dev/null -w '%{http_code}\n' -s`
    if [ $res == '200' ];then
        echo OK: $2
    else
        echo ERROR: $2
        line_notify "$2"
    fi
    unset res
}


while read row;do
    name=`echo $row | cut -d , -f 1`
    url=`echo $row | cut -d , -f 2`
    test_url "$url" "$name"
done < config.csv