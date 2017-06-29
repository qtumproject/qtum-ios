//
//  EnableFingerprintViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 27.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnableFingerprintViewController : UIViewController

@property (weak,nonatomic) id <AuthCoordinatorDelegate> delegate;

@end
