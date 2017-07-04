//
//  EnableFingerprintViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 27.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EnableFingerprintViewControllerDelegate <NSObject>

-(void)didEnableFingerprint:(BOOL) enabled;
-(void)didCancelEnableFingerprint;

@end

@interface EnableFingerprintViewController : UIViewController

@property (weak,nonatomic) id <EnableFingerprintViewControllerDelegate> delegate;

@end
