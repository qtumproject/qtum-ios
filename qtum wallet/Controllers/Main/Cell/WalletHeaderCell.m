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

@end

@implementation WalletHeaderCell

- (IBAction)showAddress:(id)sender {
    [self.delegate showAddressInfoWithSpendable:self.spendable];
}

- (void)setData:(Wallet *)wallet{
    self.adressLabel.text = ([wallet isKindOfClass:[Token class]]) ? NSLocalizedString(@"Contract Address", "") : NSLocalizedString(@"QTUM Address", "");
    self.adressValueLabel.text = wallet.mainAddress;
    self.valueLabel.text = [NSString stringWithFormat:@"%f",wallet.balance];
    self.typeWalletLabel.text = wallet.symbol;
    self.unconfirmedValue.text = [NSString stringWithFormat:@"%f",wallet.unconfirmedBalance];
    self.spendable = wallet;
}

- (void)setCellType:(HeaderCellType)type{
    switch (type) {
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
    NSArray *value1 = @[@(20), @(maxYPosition + 8.0f), @(14), @(28)];
    NSArray *constraints1 = @[self.availableTopConstraint, self.availableCenterConstraint];
    NSArray *value2 = @[@(56), @(maxYPosition + 10), @(11), @(12)];
    NSArray *constraints2 = @[self.availableTextTopConstraint, self.availableTextCenterConstraint];
    NSArray *value3 = @[@(86), @(maxYPosition + 25.0f), @(14), @(16)];
    NSArray *constraints3 = @[self.uncorfirmedTopConstraint, self.unconfirmedCenterConsctraint];
    NSArray *value4 = @[@(107), @(maxYPosition + 28.0f), @(11), @(12)];
    NSArray *constraints4 = @[self.uncorfirmedTextTopConstraint, self.unconfirmedTextCenterConstraint];
    
    
    CGFloat percentOfPosition = yPosition / - maxYPosition;
    [self changePositionForLabel:self.valueLabel andPercent:percentOfPosition values:value1 constraints:constraints1 isLeft:NO];
    [self changePositionForLabel:self.availableTitleLabel andPercent:percentOfPosition values:value2 constraints:constraints2 isLeft:YES];
    [self changePositionForLabel:self.unconfirmedValue andPercent:percentOfPosition values:value3 constraints:constraints3 isLeft:NO];
    [self changePositionForLabel:self.notConfirmedTitleLabel andPercent:percentOfPosition values:value4 constraints:constraints4 isLeft:YES];

    [self changeAlphaByPercent:percentOfPosition];
}

- (void)changePositionForLabel:(UILabel *)label andPercent:(CGFloat)percent values:(NSArray *)values constraints:(NSArray*)constraints isLeft:(BOOL)isLeft{
    
    CGFloat minTop = [values[0] floatValue];
    CGFloat maxTop = [values[1] floatValue];
    CGFloat minFont = [values[2] floatValue];
    CGFloat maxFont = [values[3] floatValue];
    
    NSLayoutConstraint *topContsraint = constraints[0];
    NSLayoutConstraint *centerContsraint = constraints[1];
    
    CGFloat newFont = maxFont - (maxFont - minFont) * percent;
    if (newFont < minFont) newFont = minFont;
    if (newFont > maxFont) newFont = maxFont;
    label.font = [label.font fontWithSize:newFont];
    
    CGFloat newTop = percent * (maxTop - minTop) + minTop;
    if (newTop < minTop) newTop = minTop;
    if (newTop > maxTop) newTop = maxTop;
    topContsraint.constant = newTop;
    
    CGFloat offset = 15.0f;
    CGFloat minCenter = 0.0f;
    CGFloat maxCenter = (self.contentView.frame.size.width - label.frame.size.width) / 2.0f - offset;
    CGFloat newCenter = minCenter + (maxCenter - minCenter) * percent * 3;
    if (newCenter < minCenter) newCenter = minCenter;
    if (newCenter > maxCenter) newCenter = maxCenter;
    centerContsraint.constant = newCenter * (isLeft ? -1 : 1);
}

- (void)changeAlphaByPercent:(CGFloat)percent{
    CGFloat minAlphaForLabel = 0.6f;
    CGFloat maxAlphaForLabel = 1.0f;
    CGFloat minAlphaForPage = 0.0f;
    CGFloat maxAlphaForPage = 1.0f;
    
    self.notConfirmedTitleLabel.alpha = self.unconfirmedValue.alpha = maxAlphaForLabel - (maxAlphaForLabel - minAlphaForLabel) * percent;
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
