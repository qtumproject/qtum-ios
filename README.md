##  About
Combining a modified Bitcoin Core infrastructure with an intercompatible version of the Ethereum Virtual Machine (EVM), Qtum merges the reliability of Bitcoin’s unfailing blockchain with the endless possibilities provided by smart contracts.
Designed with stability, modularity and interoperability in mind, Qtum is the foremost toolkit for building trusted decentralized applications, suited for real-world, business oriented use cases. Its hybrid nature, in combination with a first-of-its-kind PoS consensus protocol, allow Qtum applications to be compatible with major blockchain ecosystems, while providing native support for mobile devices and IoT appliances.

## Getting Started

1) Clone project<br/>
2) Install CocoaPods

To install CocoaPods on your computer.

```bash
$ gem install cocoapods
```
> ios version 8+.

Using Terminal open project folder and enter following command to load and connect required libraries

```bash
$ pod install
```

3) Install Carthage

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

Using Terminal open project folder and enter following command to load and connect required libraries

```bash
$ carthage update --platform iOS
```

## Change API URLs

Open file  ```${PROJECT_DIR}/config/Default/Info-default.plist```

├── ...
├── Config
│   ├── Default
│   │   ├── Info-default.plist

And change value for key ```Server_URL```
```
<key>Server_URL</key>
<string>https:/$()/testnet-walletapi.qtum.org</string>
```
To use the ```//``` character in the ```Server_URL```, use the $ () character for escaping.


## Change network parameters

#### Switch network testnet/mainnet

Open file  ```${PROJECT_DIR}/config/Default/Info-default.plist```

├── ...
├── Config
│   ├── Default
│   │   ├── Info-default.plist

And change value for key ```Is_Mainnet_setting```
```
<key>Is_Mainnet_setting</key>
<false/>
```

#### Change network parameters

In BTCAddress+Extension.m file set required enum value

```objective-c
enum
{
CustomBTCPublicKeyAddressVersion         = 58,
CustomBTCPrivateKeyAddressVersion        = 128,
CustomBTCScriptHashAddressVersion        = 50,
CustomBTCPublicKeyAddressVersionTestnet  = 120,
CustomBTCPrivateKeyAddressVersionTestnet = 239,
CustomBTCScriptHashAddressVersionTestnet = 110,
};
```

## Technologies

#### Third Party Libraries
- ``` 'AFNetworking'```  – HTTP Client
- ``` 'MTBBarcodeScanner'```  – QR-Code/Barcode scanner
- ``` 'SVProgressHUD'```  – Custom Loader
- ``` 'CoreBitcoin'```   Bitcoin toolkit for Objective-C

#### Core Bitcoin

CoreBitcoin implements Bitcoin protocol in Objective-C and provides many additional APIs to make great apps.
CoreBitcoin deliberately implements as much as possible directly in Objective-C with limited dependency on OpenSSL. This gives everyone an opportunity to learn Bitcoin on a clean codebase and enables all Mac and iOS developers to extend and improve Bitcoin protocol.

Link: https://github.com/oleganza/CoreBitcoin
