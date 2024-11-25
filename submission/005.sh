# Create a 1-of-4 P2SH multisig address from the public keys in the four inputs of this tx:
#   `37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517`
TXID=37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517
TX=$(bitcoin-cli getrawtransaction "$TXID" true)
PUBS=""
INDEX=0
for TX in $(echo "$TX" | jq -r '.vin' | jq -c '.[]') ; do
    pub=$(echo "$TX" | jq -r '.txinwitness[1]')
    #echo "$pub"
    if [ $INDEX -eq 0 ]; then
        PUBS="\"$pub\""
    else
        PUBS="$PUBS, \"$pub\""
    fi
    INDEX=$((INDEX + 1))
done
PUBS="[$PUBS]"
#echo "Public keys: $PUBS"

P2SH=$(bitcoin-cli createmultisig 1 "$PUBS" | jq -r '.address')
echo "$P2SH"
