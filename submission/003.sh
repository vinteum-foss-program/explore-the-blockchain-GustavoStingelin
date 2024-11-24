# How many new outputs were created by block 123,456?
BLOCK_NUMBER=123456
BLOCK_HASH=$(bitcoin-cli getblockhash "$BLOCK_NUMBER")
TOTAL_OUTPUTS=$(bitcoin-cli getblock "$BLOCK_HASH" | jq -r '.tx[]' | \
    xargs -I {} bitcoin-cli getrawtransaction {} true | \
    jq '[.vout | length] | add' | \
    jq -s 'add')
echo "$TOTAL_OUTPUTS"