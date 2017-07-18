//
//  QRCodeItem.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QRCodeItem.h"

NSString *const QtumAddressKey = @"qtum";
NSString *const AmountKey = @"amount";
NSString *const LabelKey = @"label";
NSString *const MessageKey = @"message";
NSString *const TokenAddressKey = @"tokenAddress";

@interface QRCodeItem()

@property (nonatomic) NSString *qtumAddress;
@property (nonatomic) NSString *tokenAddress;
@property (nonatomic) NSString *amountString;
@property (nonatomic) NSString *label;
@property (nonatomic) NSString *message;

@end

@implementation QRCodeItem

- (instancetype)initWithString:(NSString *)string {
    self = [super init];
    if (self) {
        [self emptySetup];
        [self parseFullString:string];
    }
    return self;
}

- (instancetype)initWithQtumAddress:(NSString *)qtumAddress tokenAddress:(NSString *)tokenAddress amountString:(NSString *)amountString {
    self = [super init];
    if (self) {
        [self emptySetup];
        _qtumAddress = qtumAddress;
        _tokenAddress = tokenAddress;
        _amountString = amountString;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self emptySetup];
    }
    return self;
}

- (void)emptySetup {
    _label = NSLocalizedString(@"QTUM Mobile Wallet", nil);
    _message = NSLocalizedString(@"Payment Request", nil);
}

- (void)parseFullString:(NSString *)string {
    
    if (!string) {
        _type = QRCodeItemTypeInvalid;
        return;
    }
    
    NSArray *array = [string componentsSeparatedByString:@"?"];
    
    if (array.count != 2) {
        _type = QRCodeItemTypeInvalid;
        return;
    }
    
    if (![self parseFirstPart:[array firstObject]]) {
        _type = QRCodeItemTypeInvalid;
        return;
    }
    
    if (![self parseSecondPart:[array lastObject]]) {
        _type = QRCodeItemTypeInvalid;
        return;
    }
}

- (BOOL)parseFirstPart:(NSString *)string {
    
    NSArray *array = [string componentsSeparatedByString:@":"];
    
    if (array.count != 2) {
        return NO;
    }
    
    if ([[array firstObject] isEqualToString:QtumAddressKey]) {
        _qtumAddress = [array lastObject];
    } else {
        return NO;
    }
    
    return YES;
}

- (BOOL)parseSecondPart:(NSString *)string {
    
    NSArray *array = [string componentsSeparatedByString:@"&"];

    for (NSString *param in array) {
        
        NSArray *paramArray = [param componentsSeparatedByString:@"="];
        if (paramArray.count != 2) {
            return NO;
        }
        
        if ([[paramArray firstObject] isEqualToString:AmountKey]) {
            _amountString = [paramArray lastObject];
        }
        if ([[paramArray firstObject] isEqualToString:LabelKey]) {
            _label = [paramArray lastObject];
        }
        if ([[paramArray firstObject] isEqualToString:MessageKey]) {
            _message = [paramArray lastObject];
        }
        if ([[paramArray firstObject] isEqualToString:TokenAddressKey]) {
            _tokenAddress = [paramArray lastObject];
            _type = QRCodeItemTypeToken;
        }
    }
    
    return YES;
}

- (NSString *)stringByItem {
    
    NSMutableString *string = [NSMutableString new];
    
    if (self.qtumAddress) {
        [string appendString:[NSString stringWithFormat:@"%@:%@?", QtumAddressKey, self.qtumAddress]];
    } else {
        return nil;
    }
    
    if (self.amountString && self.amountString.length > 0) {
        [string appendString:[NSString stringWithFormat:@"%@=%@&", AmountKey, self.amountString]];
    }
    
    if (self.label) {
        [string appendString:[NSString stringWithFormat:@"%@=%@&", LabelKey, self.label]];
    }
    
    if (self.message) {
        [string appendString:[NSString stringWithFormat:@"%@=%@&", MessageKey, self.message]];
    }
    
    if (self.tokenAddress) {
        [string appendString:[NSString stringWithFormat:@"%@=%@&", TokenAddressKey, self.tokenAddress]];
    }
    
    [string replaceCharactersInRange:NSMakeRange(string.length - 1, 1) withString:@""];
    
    return string;
}

@end
