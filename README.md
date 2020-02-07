# Single Collateral Dai Deploy Script

[abi-to-dhall](https://github.com/icetan/abi-to-dhall)

## Run on Testchain

Setup environment variables:

```sh
export ETH_RPC_URL
export ETH_FROM
export ETH_PASSWORD
export ETH_KEYSTORE
export ETH_GAS
```

```sh
nix run -f https://github.com/makerdao/sai-atd/tarball/master -c sai-deploy testchain
```

Or

```sh
git clone git@github.com:makerdao/sai-atd
nix run -f sai-atd -c sai-deploy testchain
```

## Develop

```sh
nix-shell
nix-build
ln -s result/abi-to-dhall/atd .
atd-deploy testchain
```
