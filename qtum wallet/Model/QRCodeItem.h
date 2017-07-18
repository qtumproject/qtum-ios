//
//  QRCodeItem.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, QRCodeItemType) {
    QRCodeItemTypeQtum,
    QRCodeItemTypeToken,
    QRCodeItemTypeInvalid
};

@interface QRCodeItem : NSObject

@property (nonatomic, readonly) NSString *qtumAddress;
@property (nonatomic, readonly) NSString *tokenAddress;
@property (nonatomic, readonly) NSString *amountString;
@property (nonatomic, readonly) NSString *label;
@property (nonatomic, readonly) NSString *message;
@property (nonatomic, readonly) QRCodeItemType type;

- (instancetype)initWithString:(NSString *)string;
- (instancetype)initWithQtumAddress:(NSString *)qtumAddress tokenAddress:(NSString *)tokenAddress amountString:(NSString *)amountString;

- (NSString *)stringByItem;

@end
