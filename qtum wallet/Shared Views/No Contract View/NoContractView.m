//
//  NoContractView.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 26.12.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NoContractView.h"

@interface NoContractView ()

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation NoContractView

-(void)awakeFromNib {
    [super awakeFromNib];
    [self configLocalization];
}

#pragma mark - Localization

-(void)configLocalization {
    
    self.label.text = NSLocalizedString(@"Contract was deleted by its author and is no longer available. You can Unsubscribe to remove it from your wallet.", @"No Contract Text");
    [self.button setTitle:NSLocalizedString(@"UNSUBSCRIBE", @"UNSUBSCRIBE Button") forState:UIControlStateNormal];
}

#pragma mark - Actions

- (IBAction)actionUnsubscribe:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didUnsubscribeToken)]) {
        [self.delegate didUnsubscribeToken];
    }
}


@end
