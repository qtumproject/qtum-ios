//
//  LoadingFooterCell.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "LoadingFooterCell.h"
#import "SpinnerView.h"

@interface LoadingFooterCell ()

@property (weak, nonatomic) IBOutlet SpinnerView *loaderView;

@end

@implementation LoadingFooterCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)prepareForReuse {
    [super prepareForReuse];
}

- (void)startAnimation {
    
    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.loaderView startAnimating];
    });
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
