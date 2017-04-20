//
//  WalletTypeCollectionCell.m
//  qtum wallet
//
//  Created by Никита Федоренко on 06.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "WalletTypeCollectionCell.h"
#import "WalletModel.h"
#import "GradientViewWithAnimation.h"

@interface WalletTypeCollectionCell ()

@property (weak, nonatomic) IBOutlet GradientViewWithAnimation *animationLayer;

@end

@implementation WalletTypeCollectionCell

-(void)prepareForReuse {
//    self.adressValueLabel.text = @"0";
//    self.valueLabel.text = @"";
    [self.animationLayer startAnimating];
}

#pragma mark - Public Methods

-(void)configWithObject:(id <Spendable>) object{
    self.adressLabel.text = ([object isKindOfClass:[Token class]]) ? @"Contract Address" : @"QTUM Address";
    self.adressValueLabel.text = object.mainAddress;
    self.valueLabel.text = [NSString stringWithFormat:@"%f",object.balance];
    self.typeWalletLabel.text = object.symbol;
}

- (IBAction)actionShowAddressInfo:(id)sender {
    [self.delegate showAddressInfo];
}

@end
