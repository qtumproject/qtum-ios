//
//  RestoreWalletOutputDelegate.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 10.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RestoreWalletOutputDelegate <NSObject>

-(BOOL)checkWordsString:(NSString *)string;
-(void)didRestorePressedWithWords:(NSString *)string;
-(void)didRestoreWallet;
-(void)restoreWalletCancelDidPressed;

@end
