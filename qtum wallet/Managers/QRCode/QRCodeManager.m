//
//  QRCodeManager.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 24.11.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "QRCodeManager.h"

@implementation QRCodeManager

+ (void)createQRCodeFromString:(NSString *)string forSize:(CGSize)size withCompletionBlock:(void(^)(UIImage *image))completionBlock;
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *stringData = [string dataUsingEncoding: NSUTF8StringEncoding];
        
        CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        [qrFilter setValue:stringData forKey:@"inputMessage"];
        [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
        
        CIColor *iBackgroundColor =[CIColor colorWithCGColor:[customBlackColor() CGColor]];
        CIColor *iForegroundColor =[CIColor colorWithCGColor:[customBlueColor() CGColor]];

        CIImage *qrImage = qrFilter.outputImage;
        CIFilter *filterColor = [CIFilter filterWithName:@"CIFalseColor" keysAndValues:@"inputImage", qrImage, @"inputColor0", iForegroundColor, @"inputColor1", iBackgroundColor, nil];
        //[filterColor setDefaults];
        
        qrImage = [filterColor valueForKey:@"outputImage"];
        float scaleX = size.width / qrImage.extent.size.width;
        float scaleY = size.height / qrImage.extent.size.height;
        
        qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
        
        CIContext *context = [CIContext contextWithOptions:nil];
        UIImage *image = [UIImage imageWithCGImage:[context createCGImage:qrImage fromRect:qrImage.extent]];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionBlock(image);
        });
    });
}

+ (void)createQRCodeFromPublicAddress:(NSString *)publicAddressString isToken:(BOOL) isToken andAmount:(NSString *)amountString forSize:(CGSize)size withCompletionBlock:(void (^)(UIImage *image))completionBlock
{
    NSDictionary *dictionary = @{PUBLIC_ADDRESS_STRING_KEY : publicAddressString,
                                 AMOUNT_STRING_KEY : amountString,
                                 kIsToken : @(isToken)};
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:0
                                                         error:nil];
    NSString *string = [[NSString alloc] initWithData:jsonData
                                             encoding:NSUTF8StringEncoding];
    
    [self createQRCodeFromString:string forSize:size withCompletionBlock:^(UIImage *image) {
        completionBlock(image);
    }];
}

+ (NSDictionary *)getNewPaymentDictionaryFromString:(NSString *)string
{
    if (!string) return nil;
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if (dictionary) {
        return dictionary;
    }else{
        NSDictionary *dictionary = @{PUBLIC_ADDRESS_STRING_KEY : string,
                                     AMOUNT_STRING_KEY : @"",
                                     PRIVATE_ADDRESS_STRING_KEY : @""};
        return dictionary;
    }
}

@end
