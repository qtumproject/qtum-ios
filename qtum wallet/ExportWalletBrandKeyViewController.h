//
//  ExportWalletBrandKeyViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 22.02.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExportWalletBrandKeyViewControllerDelegate <NSObject>

-(void)didExportWallet;

@end

@interface ExportWalletBrandKeyViewController : BaseViewController

@property (weak,nonatomic) id <ExportWalletBrandKeyViewControllerDelegate> delegate;

@end
