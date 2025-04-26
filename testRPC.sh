curl --request POST \
  --url https://rpc.quai.network/cyprus1/ \
  --header 'Content-Type: application/json' \
  --data '{
  "jsonrpc": "2.0",
  "method": "quai_getBalance",
  "params": [
    "0x1dbbB54b402E725aD96fEc342AF5150a1560D4c7",
    "latest"
  ],
  "id": 1
}'