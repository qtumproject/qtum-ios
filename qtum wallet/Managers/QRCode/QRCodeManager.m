//
//  QRCodeManager.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 24.11.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "QRCodeManager.h"

@implementation QRCodeManager

+ (void)createQRCodeFromString:(NSString *)string forSize:(CGSize)size withCompletionBlock:(void(^)(UIImage *image))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *stringData = [string dataUsingEncoding: NSUTF8StringEncoding];
        
        CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        [qrFilter setValue:stringData forKey:@"inputMessage"];
        [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
        
        CIColor *iBackgroundColor = [CIColor colorWithCGColor:[getQRCodeBackroundColor() CGColor]];
        CIColor *iForegroundColor = [CIColor colorWithCGColor:[getQRCodeMainColor() CGColor]];

        CIImage *qrImage = qrFilter.outputImage;
        CIFilter *filterColor = [CIFilter filterWithName:@"CIFalseColor" keysAndValues:@"inputImage", qrImage, @"inputColor0", iForegroundColor, @"inputColor1", iBackgroundColor, nil];
        
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

+ (void)createQRCodeFromPublicAddress:(NSString *)publicAddressString tokenAddress:(NSString *)tokenAddress andAmount:(NSString *)amountString forSize:(CGSize)size withCompletionBlock:(void (^)(UIImage *image))completionBlock {
    
    SendInfoItem *item = [[SendInfoItem alloc] initWithQtumAddress:publicAddressString tokenAddress:tokenAddress amountString:amountString];
    
    NSString *string = [item stringByItem];
    if (!string) {
        completionBlock(nil);
        return;
    }
    
    [self createQRCodeFromString:string forSize:size withCompletionBlock:^(UIImage *image) {
        completionBlock(image);
    }];
}

+ (void)createQRCodeFromContractsTokensArray:(NSArray *)array forSize:(CGSize)size withCompletionBlock:(void (^)(UIImage *))completionBlock {
    
    NSDictionary *dictionary = @{EXPORT_CONTRACTS_TOKENS_KEY : array};
    
    NSString *string = [self createStringFromDictionary:dictionary];
    
    [self createQRCodeFromString:string forSize:size withCompletionBlock:^(UIImage *image) {
        completionBlock(image);
    }];
}

+ (SendInfoItem *)getNewPaymentDictionaryFromString:(NSString *)string {
    
    SendInfoItem *item = [[SendInfoItem alloc] initWithString:string];
    return item;
}

#pragma mark - private methods

+ (NSString *)createStringFromDictionary:(NSDictionary *)dictionary{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:0
                                                         error:nil];
    NSString *string = [[NSString alloc] initWithData:jsonData
                                             encoding:NSUTF8StringEncoding];
    
    return string;
}

@end
