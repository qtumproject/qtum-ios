//
//  EnableFingerprintViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 27.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnableFingerprintOutput.h"
#import "EnableFingerprintOutputDelegate.h"

@interface EnableFingerprintViewController : UIViewController <EnableFingerprintOutput>

@property (weak,nonatomic) id <EnableFingerprintOutputDelegate> delegate;

@end
