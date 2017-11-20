//
//  MainTokenTableViewCell.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 29.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimatedLabelTableViewCell.h"

@interface MainTokenTableViewCell : AnimatedLabelTableViewCell

- (UIView *)addViewOrReturnContainViewForUpdate:(UIView *) view withHeight:(CGFloat) height;

- (void)changeTopConstaintsByPosition:(CGFloat) position diff:(CGFloat) diff;

- (BOOL)needShowHeader:(CGFloat) yPosition diff:(CGFloat) diff;

+ (CGFloat)getHeaderHeight;

- (CGFloat)lastRect:(CGFloat) position;

@end
