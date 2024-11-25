# Which tx in block 257,343 spends the coinbase output of block 256,128?
COINBASE_BLOCK_HASH=$(bitcoin-cli getblockhash 256128)
SPENDING_BLOCK_HASH=$(bitcoin-cli getblockhash 257343)

COINBASE_TXID=$(bitcoin-cli getblock "$COINBASE_BLOCK_HASH" | jq -r '.tx[0]')
COINBASE_TX=$(bitcoin-cli getrawtransaction "$COINBASE_TXID" true)
COINBASE_OUT_N=$(echo "$COINBASE_TX" | jq -r '.vout[0].n')
SPENDING_TXS=$(bitcoin-cli getblock "$SPENDING_BLOCK_HASH" | jq -r '.tx[]')

for TXID in $SPENDING_TXS; do
    SPENDING_TX=$(bitcoin-cli getrawtransaction "$TXID" true)
    VIN_LENGTH=$(echo "$SPENDING_TX" | jq -r '.vin | length')
    for vin in $(echo "$SPENDING_TX" | jq -r '.vin[] | @base64'); do
        vin_decoded=$(echo "$vin" | base64 --decode)
        COINBASE=$(echo "$vin_decoded" | jq -r '.coinbase')
        if [ "$COINBASE" != "" ]; then
            if [ "$VIN_LENGTH" -eq 1 ]; then
                #echo "Coinbase transaction"
                continue
            fi
        fi
        SPENDING_TX_IN_ID=$(echo "$vin_decoded" | jq -r '.txid')
        SPENDING_TX_IN_N=$(echo "$vin_decoded" | jq -r '.vout')
        if [ "$SPENDING_TX_IN_ID" = "$COINBASE_TXID" ] && [ "$SPENDING_TX_IN_N" = "$COINBASE_OUT_N" ]; then
            echo "$TXID"
            exit 0
        fi
    done
done
