//
//  QRCodeManager.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 24.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRCodeManager : NSObject

+ (void)createQRCodeFromString:(NSString *)string forSize:(CGSize)size withСompletionBlock:(void(^)(CIImage *image, NSString *message))completionBlock;

@end
