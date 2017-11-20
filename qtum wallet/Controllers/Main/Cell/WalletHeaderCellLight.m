//
//  WalletHeaderCellLight.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 05.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "WalletHeaderCellLight.h"
#import "DiagramView.h"
#import "GradientView.h"

CGFloat const WalletHeaderCellLightHeaderHeight = 64.0f;

@interface WalletHeaderCellLight()

@property (weak, nonatomic) IBOutlet DiagramView *diagramView;
@property (weak, nonatomic) IBOutlet DiagramView *smallDiagramView;
@property (weak, nonatomic) IBOutlet UILabel *notConfirmerCurrencyLabel;

@end

@implementation WalletHeaderCellLight

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.smallDiagramView.isSmall = YES;
    [self.diagramView drawRect:self.diagramView.frame];
    [self.smallDiagramView drawRect:self.diagramView.frame];
}

- (void)setCellType:(HeaderCellType)type{
    
    [super setCellType:type];
    
    switch (type) {
        case HeaderCellTypeAllVisible:
        case HeaderCellTypeWithoutPageControl:
            self.notConfirmerCurrencyLabel.hidden = NO;
            break;
        case HeaderCellTypeWithoutNotCorfirmedBalance:
        case HeaderCellTypeWithoutAll:
            self.notConfirmerCurrencyLabel.hidden = YES;
            break;
    }
}

- (void)cellYPositionChanged:(CGFloat)yPosition {
    
    for (UIView *view in [self.contentView.subviews firstObject].subviews) {
        if ([view isKindOfClass:[GradientView class]]) {
            CGFloat full = view.frame.size.height - WalletHeaderCellLightHeaderHeight;
            CGFloat notFull = yPosition + view.frame.size.height - WalletHeaderCellLightHeaderHeight;
            view.alpha = notFull / full;
        } else {
            CGFloat full = view.frame.origin.y - WalletHeaderCellLightHeaderHeight;
            CGFloat notFull = yPosition + view.frame.origin.y - WalletHeaderCellLightHeaderHeight;
            view.alpha = notFull / full;
        }
    }
}

- (CGFloat)percentForShowHideHeader:(CGFloat)yPosition {
    CGFloat full = self.frame.size.height - WalletHeaderCellLightHeaderHeight;
    CGFloat notFull = yPosition + self.frame.size.height - WalletHeaderCellLightHeaderHeight;
    return notFull / full;
}

- (BOOL)needShowHeader:(CGFloat)yPosition {
    
    return YES;
}

- (CGFloat)getHeaderHeight{
    return WalletHeaderCellLightHeaderHeight;
}

@end
