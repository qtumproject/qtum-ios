//
//  SpinnerView.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 08.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpinnerView : UIView

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;

@end
