//
//  CustomPageControl.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 12.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "CustomPageControl.h"

@implementation CustomPageControl

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if(self) {
        _activeImage= [UIImage imageNamed:@"activePageControl"];
        _inactiveImage = [UIImage imageNamed:@"deactivePageControl"];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.pageIndicatorTintColor = [UIColor clearColor];
    self.currentPageIndicatorTintColor = [UIColor clearColor];
}

-(void) updateDots
{
    for (int i = 0; i < [self.subviews count]; i++) {
        UIImageView * dot = [self imageViewForSubview:  [self.subviews objectAtIndex: i]];
        if (i == self.currentPage) {
            dot.image = self.activeImage;
        } else {
            dot.image = self.inactiveImage;
        }
    }
}

- (UIImageView *) imageViewForSubview: (UIView *) view {
    UIImageView * dot = nil;
    if ([view isKindOfClass: [UIView class]])
    {
        for (UIView* subview in view.subviews)
        {
            if ([subview isKindOfClass:[UIImageView class]])
            {
                dot = (UIImageView *)subview;
                break;
            }
        }
        if (dot == nil)
        {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height)];
            dot.tintColor = self.tintColor;
            [view addSubview:dot];
        }
    }
    else
    {
        dot = (UIImageView *) view;
    }
    
    return dot;
}

-(void)setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    [self updateDots];
}

@end
