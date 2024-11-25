  # Using descriptors, compute the taproot address at index 100 derived from this extended public key:
#   `xpub6Cx5tvq6nACSLJdra1A6WjqTo1SgeUZRFqsX5ysEtVBMwhCCRa4kfgFqaT2o1kwL3esB1PsYr3CUdfRZYfLHJunNWUABKftK2NjHUtzDms2`
XPUB="xpub6Cx5tvq6nACSLJdra1A6WjqTo1SgeUZRFqsX5ysEtVBMwhCCRa4kfgFqaT2o1kwL3esB1PsYr3CUdfRZYfLHJunNWUABKftK2NjHUtzDms2"
INDEX="100"
DESCRIPTOR="tr($XPUB/$INDEX)"
CHECKSUM_DESCRIPTOR=$(bitcoin-cli getdescriptorinfo "$DESCRIPTOR" | jq -r '.descriptor')
#echo "$CHECKSUM_DESCRIPTOR"
ADDRESS=$(bitcoin-cli deriveaddresses "$CHECKSUM_DESCRIPTOR" | jq -r '.[0]')
#echo "Taproot Address at index $INDEX: $ADDRESS"
echo "$ADDRESS"
