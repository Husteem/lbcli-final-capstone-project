# How many satoshis did this transaction pay for fee?: b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb
TXID="b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb"
TX_JSON=$(bitcoin-cli -signet getrawtransaction "$TXID" true)
OUT_SUM=$(echo "$TX_JSON" | jq '[.vout[].value] | add')

IN_SUM=0
count=$(echo "$TX_JSON" | jq '.vin | length')
for ((i=0; i<$count; i++)); do
    VIN_TXID=$(echo "$TX_JSON" | jq -r ".vin[$i].txid")
    VIN_VOUT=$(echo "$TX_JSON" | jq -r ".vin[$i].vout")
    VIN_VALUE=$(bitcoin-cli -signet getrawtransaction "$VIN_TXID" true | jq -r ".vout[$VIN_VOUT].value")
    IN_SUM=$(awk "BEGIN {printf \"%.8f\", $IN_SUM + $VIN_VALUE}")
done

FEE_BTC=$(awk "BEGIN {printf \"%.8f\", $IN_SUM - $OUT_SUM}")
echo "$FEE_BTC" | awk '{printf "%.0f\n", $1 * 100000000}'
