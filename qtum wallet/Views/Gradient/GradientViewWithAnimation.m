//
//  GradientViewWithAnimation.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 04.01.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "GradientViewWithAnimation.h"
#import "DiagramView.h"

@implementation GradientViewWithAnimation

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    DiagramView* view = [[DiagramView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 250, self.frame.size.width, 250)];
    view.backgroundColor = [UIColor clearColor];
    view.isSmall = YES;
    [self addSubview:view];
    [self sendSubviewToBack:view];
    
    view = [[DiagramView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 220, self.frame.size.width, 250)];
    view.backgroundColor = [UIColor clearColor];
    [self addSubview:view];
    [self sendSubviewToBack:view];
}

-(void)startAnimating{
    for (DiagramView* view in self.subviews) {
        [view setNeedsDisplay];
    }
}

-(void)dealloc{
    DLog(@"Dealocated");
}

@end
