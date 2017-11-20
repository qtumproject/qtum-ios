//
//  SendInfoItem.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SendInfoItemType) {
    SendInfoItemTypeQtum,
    SendInfoItemTypeToken,
    SendInfoItemTypeInvalid
};

@interface SendInfoItem : NSObject

@property (nonatomic, readonly) NSString *qtumAddress;
@property (nonatomic, readonly) BTCKey *qtumAddressKey;
@property (nonatomic, readonly) NSString *tokenAddress;
@property (nonatomic, readonly) NSString *amountString;
@property (nonatomic, readonly) NSString *label;
@property (nonatomic, readonly) NSString *message;
@property (nonatomic, readonly) NSString *fromQtumAddress;
@property (nonatomic, readonly) BTCKey *fromQtumAddressKey;
@property (nonatomic, readonly) SendInfoItemType type;

- (instancetype)initWithString:(NSString *)string;
- (instancetype)initWithQtumAddress:(NSString *)qtumAddress
                       tokenAddress:(NSString *)tokenAddress
                       amountString:(NSString *)amountString;

- (instancetype)initWithQtumAddress:(NSString *)qtumAddress
                       tokenAddress:(NSString *)tokenAddress
                       amountString:(NSString *)amountString
                    fromQtumAddress:(NSString *)fromAddress;

- (instancetype)initWithQtumAddressKey:(BTCKey *)qtumAddressKey
                          tokenAddress:(NSString *)tokenAddress
                          amountString:(NSString *)amountString
                    fromQtumAddressKey:(BTCKey *)fromAddressKey;

- (NSString *)stringByItem;

@end
