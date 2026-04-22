#!/bin/bash
echo "Generating 3 public keys for multisig..."
ADDR1=$(bitcoin-cli -signet -rpcwallet=Husteem getnewaddress "" "bech32")
ADDR2=$(bitcoin-cli -signet -rpcwallet=Husteem getnewaddress "" "bech32")
ADDR3=$(bitcoin-cli -signet -rpcwallet=Husteem getnewaddress "" "bech32")

PUB1=$(bitcoin-cli -signet -rpcwallet=Husteem getaddressinfo "$ADDR1" | jq -r '.pubkey')
PUB2=$(bitcoin-cli -signet -rpcwallet=Husteem getaddressinfo "$ADDR2" | jq -r '.pubkey')
PUB3=$(bitcoin-cli -signet -rpcwallet=Husteem getaddressinfo "$ADDR3" | jq -r '.pubkey')
KEYS="[\"$PUB1\", \"$PUB2\", \"$PUB3\"]"

echo "Creating 2-of-3 P2SH Multisig Address (Task 5)..."
MULTISIG_JSON=$(bitcoin-cli -signet -rpcwallet=Husteem createmultisig 2 "$KEYS" "legacy")
P2SH_ADDR=$(echo "$MULTISIG_JSON" | jq -r '.address')
REDEEM_SCRIPT=$(echo "$MULTISIG_JSON" | jq -r '.redeemScript')
echo "$P2SH_ADDR" > submission/multisig-address.txt
echo "$REDEEM_SCRIPT" > submission/multisig-redeem.txt
# Import it to wallet so it tracks balances
bitcoin-cli -signet -rpcwallet=Husteem importaddress "$P2SH_ADDR" "" false

echo "Creating 2-of-3 P2WSH Multisig Address (Task 7)..."
P2WSH_JSON=$(bitcoin-cli -signet -rpcwallet=Husteem createmultisig 2 "$KEYS" "bech32")
P2WSH_ADDR=$(echo "$P2WSH_JSON" | jq -r '.address')
WITNESS_SCRIPT=$(echo "$P2WSH_JSON" | jq -r '.redeemScript')
echo "$P2WSH_ADDR" > submission/p2wsh-address.txt
echo "$WITNESS_SCRIPT" > submission/p2wsh-witness-script.txt
bitcoin-cli -signet -rpcwallet=Husteem importaddress "$P2WSH_ADDR" "" false

echo "--------------------------------------------------------"
echo "✅ All required addresses have been generated!"
echo "1. Standard Address: $(cat submission/address.txt)"
echo "2. P2SH Multisig: $P2SH_ADDR"
echo "3. P2WSH Multisig: $P2WSH_ADDR"
echo "--------------------------------------------------------"
