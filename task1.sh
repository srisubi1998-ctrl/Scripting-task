#!/bin/bash
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" https://guvi.in)
echo "HTTP Status code: $HTTP_CODE"
if [ $HTTP_CODE -eq 200 ] || [ $HTTP_CODE -eq 301 ]; then
echo "Success! Website is UP!"
else
echo "Failure! Website is DOWN!"
fi

