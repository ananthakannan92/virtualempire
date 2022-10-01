Shared Libraries
================

## virtualempireconsensus

The purpose of this library is to make the verification functionality that is critical to Virtualempire's consensus available to other applications, e.g. to language bindings.

### API

The interface is defined in the C header `virtualempireconsensus.h` located in  `src/script/virtualempireconsensus.h`.

#### Version

`virtualempireconsensus_version` returns an `unsigned int` with the API version *(currently at an experimental `0`)*.

#### Script Validation

`virtualempireconsensus_verify_script` returns an `int` with the status of the verification. It will be `1` if the input script correctly spends the previous output `scriptPubKey`.

##### Parameters
- `const unsigned char *scriptPubKey` - The previous output script that encumbers spending.
- `unsigned int scriptPubKeyLen` - The number of bytes for the `scriptPubKey`.
- `const unsigned char *txTo` - The transaction with the input that is spending the previous output.
- `unsigned int txToLen` - The number of bytes for the `txTo`.
- `unsigned int nIn` - The index of the input in `txTo` that spends the `scriptPubKey`.
- `unsigned int flags` - The script validation flags *(see below)*.
- `virtualempireconsensus_error* err` - Will have the error/success code for the operation *(see below)*.

##### Script Flags
- `virtualempireconsensus_SCRIPT_FLAGS_VERIFY_NONE`
- `virtualempireconsensus_SCRIPT_FLAGS_VERIFY_P2SH` - Evaluate P2SH ([BIP16](https://github.com/bitcoin/bips/blob/master/bip-0016.mediawiki)) subscripts
- `virtualempireconsensus_SCRIPT_FLAGS_VERIFY_DERSIG` - Enforce strict DER ([BIP66](https://github.com/bitcoin/bips/blob/master/bip-0066.mediawiki)) compliance
- `virtualempireconsensus_SCRIPT_FLAGS_VERIFY_NULLDUMMY` - Enforce NULLDUMMY ([BIP147](https://github.com/bitcoin/bips/blob/master/bip-0147.mediawiki))
- `virtualempireconsensus_SCRIPT_FLAGS_VERIFY_CHECKLOCKTIMEVERIFY` - Enable CHECKLOCKTIMEVERIFY ([BIP65](https://github.com/bitcoin/bips/blob/master/bip-0065.mediawiki))
- `virtualempireconsensus_SCRIPT_FLAGS_VERIFY_CHECKSEQUENCEVERIFY` - Enable CHECKSEQUENCEVERIFY ([BIP112](https://github.com/bitcoin/bips/blob/master/bip-0112.mediawiki))
- `virtualempireconsensus_SCRIPT_FLAGS_VERIFY_WITNESS` - Enable WITNESS ([BIP141](https://github.com/bitcoin/bips/blob/master/bip-0141.mediawiki))

##### Errors
- `virtualempireconsensus_ERR_OK` - No errors with input parameters *(see the return value of `virtualempireconsensus_verify_script` for the verification status)*
- `virtualempireconsensus_ERR_TX_INDEX` - An invalid index for `txTo`
- `virtualempireconsensus_ERR_TX_SIZE_MISMATCH` - `txToLen` did not match with the size of `txTo`
- `virtualempireconsensus_ERR_DESERIALIZE` - An error deserializing `txTo`
- `virtualempireconsensus_ERR_AMOUNT_REQUIRED` - Input amount is required if WITNESS is used

### Example Implementations
- [NHive](https://github.com/NicolasDorier/NHive/blob/master/NHive/Script.cs#L814) (.NET Bindings)
- [node-libvirtualempireconsensus](https://github.com/bitpay/node-libvirtualempireconsensus) (Node.js Bindings)
- [java-libvirtualempireconsensus](https://github.com/dexX7/java-libvirtualempireconsensus) (Java Bindings)
- [bitcoinconsensus-php](https://github.com/Bit-Wasp/bitcoinconsensus-php) (PHP Bindings)
