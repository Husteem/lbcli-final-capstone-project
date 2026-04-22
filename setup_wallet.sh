#!/bin/bash
echo "Creating wallet 'Husteem'..."
bitcoin-cli -signet createwallet "Husteem"
echo "Husteem" > submission/wallet.txt

echo "Extracting receiving descriptor..."
DESC=$(bitcoin-cli -signet -rpcwallet=Husteem listdescriptors true | jq -r '.descriptors[] | select(.desc | startswith("wpkh")) | select(.internal == false) | .desc')
echo "$DESC" > submission/descriptor.txt

echo "Generating native SegWit address..."
ADDRESS=$(bitcoin-cli -signet -rpcwallet=Husteem getnewaddress "" "bech32")
echo "$ADDRESS" > submission/address.txt

echo "--------------------------------------------------------"
echo "✅ Wallet, Descriptor, and Address successfully generated!"
echo "Your funding address is: $ADDRESS"
echo "--------------------------------------------------------"
