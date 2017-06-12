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
- (void)didSelectTokenIndexPath:(NSIndexPath *)indexPath withItem:(Contract*) item;
- (void)didDeselectTokenIndexPath:(NSIndexPath *)indexPath withItem:(Contract*) item;
- (void)resetToDefaults;

@end

@interface ChoseTokenPaymentViewController : BaseViewController

@property (strong, nonatomic) NSArray <Contract*>* tokens;
@property (weak, nonatomic)Contract* activeToken;
@property (weak, nonatomic)id <ChoseTokenPaymentViewControllerDelegate> delegate;

@end
