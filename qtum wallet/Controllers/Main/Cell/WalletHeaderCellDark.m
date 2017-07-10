//
//  WalletHeaderCellDark.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 05.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "WalletHeaderCellDark.h"

CGFloat const WalletHeaderCellDarkHeaderHeight = 50.0f;

@interface WalletHeaderCellDark()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *availableTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *availableTextTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *uncorfirmedTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *uncorfirmedTextTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *availableCenterConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *availableTextCenterConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unconfirmedCenterConsctraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unconfirmedTextCenterConstraint;

@end

@implementation WalletHeaderCellDark

#pragma mark - Animation

- (void)cellYPositionChanged:(CGFloat)yPosition{
    CGFloat maxYPosition = self.separatorView.frame.origin.y - WalletHeaderCellDarkHeaderHeight;
    
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
    CGFloat maxYPosition = self.separatorView.frame.origin.y - WalletHeaderCellDarkHeaderHeight;
    CGFloat percentOfPosition = yPosition / - maxYPosition;
    
    return percentOfPosition >= 1;
}

- (CGFloat)getHeaderHeight{
    return WalletHeaderCellDarkHeaderHeight;
}

@end
