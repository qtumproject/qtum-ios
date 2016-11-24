//
//  QRCodeManager.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 24.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "QRCodeManager.h"

@implementation QRCodeManager

+ (void)createQRCodeFromString:(NSString *)string forSize:(CGSize)size withСompletionBlock:(void(^)(CIImage *image, NSString *message))completionBlock;
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *stringData = [string dataUsingEncoding: NSUTF8StringEncoding];
        
        CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        [qrFilter setValue:stringData forKey:@"inputMessage"];
        [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
        
        CIImage *qrImage = qrFilter.outputImage;
        float scaleX = size.width / qrImage.extent.size.width;
        float scaleY = size.height / qrImage.extent.size.height;
        
        qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionBlock(qrImage, nil);
        });
    });
}

@end
