//
//  QRCodeManager.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 24.11.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRCodeManager : NSObject

+ (void)createQRCodeFromString:(NSString *)string forSize:(CGSize)size withCompletionBlock:(void(^)(UIImage *image))completionBlock;
+ (void)createQRCodeFromPublicAddress:(NSString *)publicAddressString tokenAddress:(NSString *)tokenAddress andAmount:(NSString *)amountString forSize:(CGSize)size withCompletionBlock:(void (^)(UIImage *image))completionBlock;
+ (void)createQRCodeFromContractsTokensArray:(NSArray *)array forSize:(CGSize)size withCompletionBlock:(void (^)(UIImage *image))completionBlock;

+ (SendInfoItem *)getNewPaymentDictionaryFromString:(NSString *)string;

@end
