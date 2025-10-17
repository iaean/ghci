#!/bin/bash

# https://www.stepsecurity.io/blog/ctrl-tinycolor-and-40-npm-packages-compromised
# https://socket.dev/blog/ongoing-supply-chain-attack-targets-crowdstrike-npm-packages
# https://www.trendmicro.com/en_us/research/25/i/npm-supply-chain-attack.html

find . -type f -iname "trufflehog"
find . -type f -iname "trufflehog.exe"

SHA256="de0e25a3e6c1e1e5998b306b7141b3dc4c0088da9d7bb47c1c00c91e6e4f85d6
81d2a004a1bca6ef87a1caf7d0e0b355ad1764238e40ff6d1b1cb77ad4f595c3
83a650ce44b2a9854802a7fb4c202877815274c129af49e6c2d1d5d5d55c501e
4b2399646573bb737c4969563303d8ee2e9ddbd1b271f1ca9e35ea78062538db
dc67467a39b70d1cd4c1f7f7a459b35058163592f4a9e8fb4dffcbba98ef210c
46faab8ab153fae6e80e7cca38eab363075bb524edd79e42269217a083628f09
b74caeaa75e077c99f7d44f46daaf9796a3be43ecf24f2a1fd381844669da777"

for s in $SHA256
do
  find . -type f -name "*.js" -exec sha256sum {} \; | grep "${s}"
done
