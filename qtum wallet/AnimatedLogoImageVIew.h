//
//  AnimatedLogoImageVIew.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 16.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimatedLogoImageVIew : UIImageView

@property (nonatomic) UIImageView *secondImageView;
@property (nonatomic) NSLayoutConstraint *topConstraintForSecondImageView;
@property (nonatomic) BOOL isAnimating;
@property (nonatomic) BOOL needRepeate;
@property (nonatomic) CGFloat animationTime;


@end
