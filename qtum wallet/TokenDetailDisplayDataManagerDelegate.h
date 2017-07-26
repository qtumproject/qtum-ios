//
//  TokenDetailDisplayDataManagerDelegate.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 24.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TokenDetailDisplayDataManagerDelegate <NSObject>

@optional
- (void)updateWithYOffset:(CGFloat) offset;
- (void)needShowHeader;
- (void)needHideHeader;
- (void)needShowHeaderForSecondSeciton;
- (void)needHideHeaderForSecondSeciton;
- (void)didPressedInfoActionWithToken:(Contract*)token;

@end
