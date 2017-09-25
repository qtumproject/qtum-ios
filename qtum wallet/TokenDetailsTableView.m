//
//  TokenDetailsTableView.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 22.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TokenDetailsTableView.h"

@interface TokenDetailsTableView ()

@property (nonatomic) UIView *topView;

@end

@implementation TokenDetailsTableView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 0.0f)];
        _topView.backgroundColor = customBlueColor();
        
        [self addSubview:_topView];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.topView.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.contentOffset.y);
}

@end
