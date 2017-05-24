//
//  GradientView.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 17.11.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ColorType){
    Blue,
    Pink,
    Green
};

@interface GradientView : UIView

@property (assign,nonatomic) ColorType colorType;

@end
