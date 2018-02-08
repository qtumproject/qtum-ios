//
//  ValueRepresentationEntity.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 08.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "ValueRepresentationEntity.h"

@interface ValueRepresentationEntity ()

@property (strong, nonatomic) NSString* hex;
@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSString* address;
@property (strong, nonatomic) NSString* number;


@end

@implementation ValueRepresentationEntity

- (instancetype)initWithHexString:(NSString*) hex {
    
    self =  [super init];
    if (self) {
        [self setupWithHex: hex];
    }
    
    return self;
}

- (void)setupWithHex:(NSString*) hex {
    
    _hex = hex;
    NSData* dataFromHex = [NSString dataFromHexString:hex];
    NSString *text = [[NSString alloc] initWithData:dataFromHex encoding:NSASCIIStringEncoding];
    _text = text;
    
    NSUInteger decodedNumber;
    [dataFromHex getBytes:&decodedNumber length:sizeof(decodedNumber)];
    
    _number = [NSString stringWithFormat:@"%lu", (unsigned long)decodedNumber];
    NSString* address;
    NSInteger length = 20;
    
    if (hex.length > length) {
        address = [hex substringFromIndex:length];
    } else {
        address = hex;
    }
    
    _address = [NSString stringWithFormat:@"0x%@",address];
    
}

- (NSString*)valueDependsOnType {
    
    switch (self.type) {
        case HexType:
            return self.hex;
            break;
        case NumberType:
            return self.number;
            break;
        case TextType:
            return self.text;
            break;
        case AddressType:
            return self.address;
            break;
            
        default:
            break;
    }
}

- (NSString*)nameDependsOnType {
    
    switch (self.type) {
        case HexType:
            return @"Hex";
            break;
        case NumberType:
            return @"Number";
            break;
        case TextType:
            return @"Text";
            break;
        case AddressType:
            return @"Address";
            break;
            
        default:
            break;
    }
}

@end
