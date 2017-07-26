//
//  UIViewController+Extension.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 26.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "UIViewController+Extension.h"
#import "NSUserDefaults+Settings.h"

@implementation UIViewController (Extension)

+ (UIViewController*) instantiateControllerInStoryboard:(UIStoryboard*) storyboard withIdentifire:(NSString*) identifire{
    
    return identifire ? [storyboard instantiateViewControllerWithIdentifier:identifire] : [storyboard instantiateInitialViewController];
}

+ (UIViewController*) controllerInStoryboard:(NSString*) storyboard withIdentifire:(NSString*) identifire {
    
    NSMutableString *mutString = [identifire mutableCopy];
    
    if ([identifire isEqualToString:@"NewPayment"] ||
        [identifire isEqualToString:@"WalletViewController"] ||
        [identifire isEqualToString:@"BalancePageViewController"] ||
        [identifire isEqualToString:@"TokenListViewController"] ||
        [identifire isEqualToString:@"ProfileViewController"] ||
        [identifire isEqualToString:@"ChoseTokenPaymentViewController"] ||
        [identifire isEqualToString:@"QRCodeViewController"] ||
        [identifire isEqualToString:@"LoginViewController"] ||
        [identifire isEqualToString:@"FirstAuthViewController"] ||
        [identifire isEqualToString:@"RepeateViewController"] ||
        [identifire isEqualToString:@"CreatePinViewController"] ||
        [identifire isEqualToString:@"WalletNameViewController"] ||
        [identifire isEqualToString:@"EnableFingerprintViewController"] || 
        [identifire isEqualToString:@"LanguageViewController"] ||
        [identifire isEqualToString:@"ExportBrainKeyViewController"] ||
        [identifire isEqualToString:@"HistoryItemViewController"] ||
        [identifire isEqualToString:@"RecieveViewController"] ||
        [identifire isEqualToString:@"ConfirmPinForExportViewController"] ||
        [identifire isEqualToString:@"RestoreWalletViewController"] ||
        [identifire isEqualToString:@"ExportWalletBrandKeyViewController"] ||
        [identifire isEqualToString:@"NewsViewController"] ||
        [identifire isEqualToString:@"TokenDetailsViewController"]) {
        
        if ([NSUserDefaults isDarkSchemeSetting]) {
            
            [mutString appendString:@"Dark"];
        } else {
            [mutString appendString:@"Light"];
        }
    }
    
    return [self instantiateControllerInStoryboard:[UIStoryboard storyboardWithName:storyboard bundle:nil] withIdentifire:mutString];
}

- (UIViewController*) controllerInStoryboard:(NSString*) storyboard{
    return [UIViewController instantiateControllerInStoryboard:[UIStoryboard storyboardWithName:storyboard bundle:nil]  withIdentifire:self.nameOfClass];
}

@end
