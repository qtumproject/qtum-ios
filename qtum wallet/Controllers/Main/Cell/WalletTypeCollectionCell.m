//
//  WalletTypeCollectionCell.m
//  qtum wallet
//
//  Created by Никита Федоренко on 06.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "WalletTypeCollectionCell.h"
#import "GradientViewWithAnimation.h"

@interface WalletTypeCollectionCell ()

@property (weak, nonatomic) IBOutlet UIView *animationLayer;

@end

@implementation WalletTypeCollectionCell

-(void)prepareForReuse {
    
    //[self.animationLayer startAnimating];
}

#pragma mark - Public Methods

-(void)configWithObject:(id <Spendable>) object{
    self.adressLabel.text = ([object isKindOfClass:[Token class]]) ? NSLocalizedString(@"Contract Address", "") : NSLocalizedString(@"QTUM Address", "");
    self.adressValueLabel.text = object.mainAddress;
    self.valueLabel.text = [NSString stringWithFormat:@"%f",object.balance];
    self.typeWalletLabel.text = object.symbol;
    self.unconfirmedValue.text = [NSString stringWithFormat:@"%f",object.unconfirmedBalance];
}

- (IBAction)actionShowAddressInfo:(id)sender {
    [self.delegate showAddressInfo];
}

@end
