//
//  BTCAddress+Extension.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 16.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "BTCAddress+Extension.h"
#import <objc/runtime.h>

enum
{
    CustomBTCPublicKeyAddressVersion         = 58,
    CustomBTCPrivateKeyAddressVersion        = 128,
    CustomBTCScriptHashAddressVersion        = 50,
    CustomBTCPublicKeyAddressVersionTestnet  = 120,
    CustomBTCPrivateKeyAddressVersionTestnet = 239,
    CustomBTCScriptHashAddressVersionTestnet = 110,
};

@implementation BTCPublicKeyAddress (Extension)

+ (uint8_t) BTCVersionPrefix {
    return CustomBTCPublicKeyAddressVersion;
}

@end

@implementation BTCPrivateKeyAddress (Extension)

+ (uint8_t) BTCVersionPrefix {
    return CustomBTCPrivateKeyAddressVersion;
}

@end

@implementation BTCScriptHashAddress (Extension)

+ (uint8_t) BTCVersionPrefix {
    return CustomBTCScriptHashAddressVersion;
}

@end

@implementation BTCPublicKeyAddressTestnet (Extension)

+ (uint8_t) BTCVersionPrefix {
    return CustomBTCPublicKeyAddressVersionTestnet;
}

@end

@implementation BTCPrivateKeyAddressTestnet (Extension)

+ (uint8_t) BTCVersionPrefix {
    return CustomBTCPrivateKeyAddressVersionTestnet;
}

@end

@implementation BTCScriptHashAddressTestnet (Extension)

+ (uint8_t) BTCVersionPrefix {
    return CustomBTCScriptHashAddressVersionTestnet;
}

@end
