//
//  WalletTypeCellWithCollection.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.04.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "WalletHeaderCell.h"

CGFloat const HeaderHeight = 50.0f;

@interface WalletHeaderCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *availableTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *availableTextTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *uncorfirmedTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *uncorfirmedTextTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *availableCenterConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *availableTextCenterConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unconfirmedCenterConsctraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unconfirmedTextCenterConstraint;

@property (nonatomic) HeaderCellType type;

@end

@implementation WalletHeaderCell

- (IBAction)showAddress:(id)sender {
    [self.delegate showAddressInfoWithSpendable:self.spendable];
}

- (void)setData:(Wallet *)wallet{
    self.adressLabel.text = ([wallet isKindOfClass:[Contract class]]) ? NSLocalizedString(@"Contract Address", "") : NSLocalizedString(@"QTUM Address", "");
    self.adressValueLabel.text = wallet.mainAddress;
    self.valueLabel.text = [NSString stringWithFormat:@"%f",wallet.balance];
    self.typeWalletLabel.text = wallet.symbol;
    self.unconfirmedValue.text = [NSString stringWithFormat:@"%f",wallet.unconfirmedBalance];
    self.spendable = wallet;
}

- (void)setCellType:(HeaderCellType)type{
    self.type = type;
    switch (self.type) {
        case HeaderCellTypeAllVisible:
            self.pageControl.hidden = NO;
            self.unconfirmedValue.hidden = NO;
            self.notConfirmedTitleLabel.hidden = NO;
            break;
        case HeaderCellTypeWithoutPageControl:
            self.pageControl.hidden = YES;
            self.unconfirmedValue.hidden = NO;
            self.notConfirmedTitleLabel.hidden = NO;
            break;
        case HeaderCellTypeWithoutNotCorfirmedBalance:
            self.pageControl.hidden = NO;
            self.unconfirmedValue.hidden = YES;
            self.notConfirmedTitleLabel.hidden = YES;
            break;
        case HeaderCellTypeWithoutAll:
            self.pageControl.hidden = YES;
            self.unconfirmedValue.hidden = YES;
            self.notConfirmedTitleLabel.hidden = YES;
            break;
    }
}

#pragma mark - Animation

- (void)cellYPositionChanged:(CGFloat)yPosition scrolledDelta:(CGFloat)scrolledDelta{
    CGFloat maxYPosition = self.separatorView.frame.origin.y - HeaderHeight;
    
    // formats
    // minTop, maxTop, minFont, maxFont
    // top, center
    NSArray *value1;
    NSArray *value2;
    if (self.type == HeaderCellTypeAllVisible || self.type == HeaderCellTypeWithoutPageControl) {
        value1 = @[@(20), @(maxYPosition + 8.0f), @(14), @(28), @(1.0f), @(1.0f)];
        value2 = @[@(56), @(maxYPosition + 10), @(11), @(12), @(1.0f), @(1.0f)];
    }else{
        value1 = @[@(20), @(maxYPosition + 15.0f), @(14), @(28), @(1.0f), @(1.0f)];
        value2 = @[@(56), @(maxYPosition + 17.0f), @(11), @(12), @(1.0f), @(1.0f)];
    }
    NSArray *constraints1 = @[self.availableTopConstraint, self.availableCenterConstraint];
    NSArray *constraints2 = @[self.availableTextTopConstraint, self.availableTextCenterConstraint];
    NSArray *value3 = @[@(86), @(maxYPosition + 25.0f), @(14), @(16), @(1.0f), @(0.6f)];
    NSArray *constraints3 = @[self.uncorfirmedTopConstraint, self.unconfirmedCenterConsctraint];
    NSArray *value4 = @[@(107), @(maxYPosition + 28.0f), @(11), @(12), @(1.0f), @(0.6f)];
    NSArray *constraints4 = @[self.uncorfirmedTextTopConstraint, self.unconfirmedTextCenterConstraint];
    
    
    CGFloat percentOfPosition = yPosition / - maxYPosition;
    [self changePositionForLabel:self.valueLabel andPercent:percentOfPosition values:value1 constraints:constraints1 isLeft:NO];
    [self changePositionForLabel:self.availableTitleLabel andPercent:percentOfPosition values:value2 constraints:constraints2 isLeft:YES];
    [self changePositionForLabel:self.unconfirmedValue andPercent:percentOfPosition values:value3 constraints:constraints3 isLeft:NO];
    [self changePositionForLabel:self.notConfirmedTitleLabel andPercent:percentOfPosition values:value4 constraints:constraints4 isLeft:YES];

    [self changeAlphaByPercent:percentOfPosition];
}

- (void)changeAlphaByPercent:(CGFloat)percent{
    CGFloat minAlphaForPage = 0.0f;
    CGFloat maxAlphaForPage = 1.0f;
    
    self.pageControl.alpha = maxAlphaForPage - (maxAlphaForPage - minAlphaForPage) * percent;
}

- (BOOL)needShowHeader:(CGFloat)yPosition{
    CGFloat maxYPosition = self.separatorView.frame.origin.y - HeaderHeight;
    CGFloat percentOfPosition = yPosition / - maxYPosition;
    
    return percentOfPosition >= 1;
}

+ (CGFloat)getHeaderHeight{
    return HeaderHeight;
}

@end
