//
//  ChoseTokenPaymentViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 25.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChoseTokenPaymentViewControllerDelegate <NSObject>

@required
- (void)didSelectTokenIndexPath:(NSIndexPath *)indexPath withItem:(Token*) item;
- (void)didDeselectTokenIndexPath:(NSIndexPath *)indexPath withItem:(Token*) item;
- (void)resetToDefaults;

@end

@interface ChoseTokenPaymentViewController : UIViewController

@property (weak, nonatomic)NSArray <Token*>* tokens;
@property (weak, nonatomic)Token* activeToken;
@property (weak, nonatomic)id <ChoseTokenPaymentViewControllerDelegate> delegate;

@end
