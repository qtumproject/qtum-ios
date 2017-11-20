//
//  DiagramView.h
//  DiagramAnimation
//
//  Created by Vladimir Lebedevich on 29.12.16.
//  Copyright © 2016 com.example. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WaweType) {
    SmallWawe,
    BigWawe
};

@interface DiagramView : UIView

@property (assign,nonatomic) BOOL isSmall;

@end
