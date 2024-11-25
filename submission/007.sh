# Only one single output remains unspent from block 123,321. What address was it sent to?
BLOCK_HASH=$(bitcoin-cli getblockhash 123321)
TX_IDS=$(bitcoin-cli getblock "$BLOCK_HASH" | jq -r '.tx[]')

for TX_ID in $TX_IDS; do
    TX_DETAILS=$(bitcoin-cli getrawtransaction "$TX_ID" true)
    #echo "$TX_DETAILS"
    OUTPUTS=$(echo "$TX_DETAILS" | jq -r '.vout[] | @base64')
    for OUTPUT in $OUTPUTS; do
        OUTPUT=$(echo "$OUTPUT" | base64 --decode)
        OUT_N=$(echo "$OUTPUT" | jq -r '.n')
        UTXO=$(bitcoin-cli gettxout "$TX_ID" "$OUT_N")
        if [ "$UTXO" != "" ]; then
            #echo "UTXO: $UTXO"
            echo "$UTXO" | jq -r '.scriptPubKey.address'
            exit 0
        fi
    done
done
