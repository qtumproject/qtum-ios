//
//  WalletViewControllerDark.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 05.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "WalletViewControllerDark.h"
#import "ViewWithAnimatedLine.h"

CGFloat const WalletHeaderHeightShowedDark = 50.0f;

@interface WalletViewControllerDark ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingForLineConstraint;
@property (weak, nonatomic) IBOutlet ViewWithAnimatedLine *headerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *viewForHeaderInSecondSection;

@end

@implementation WalletViewControllerDark

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.headerView setRightConstraint:self.trailingForLineConstraint];
    [self createBackroundForRefreshArea];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createBackroundForRefreshArea {
    
    CGRect frame = self.tableView.bounds;
    frame.origin.y = -frame.size.height;
    UIView *refreshBackgroundView = [[UIView alloc]initWithFrame:frame];
    refreshBackgroundView.backgroundColor = customBlueColor();
    [self.tableView insertSubview:refreshBackgroundView atIndex:0];
}

#pragma mark - TableSourceDelegate

- (void)needShowHeader{
    if (self.headerHeightConstraint.constant == WalletHeaderHeightShowedDark) {
        return;
    }
    
    self.headerHeightConstraint.constant = WalletHeaderHeightShowedDark;
    [self.headerView showAnimation];
}

- (void)needShowHeaderForSecondSeciton {
    self.viewForHeaderInSecondSection.hidden = NO;
}
- (void)needHideHeaderForSecondSeciton {
    self.viewForHeaderInSecondSection.hidden = YES;
}

- (void)needHideHeader{
    if (self.headerHeightConstraint.constant == 0.0f) {
        return;
    }
    
    self.headerHeightConstraint.constant = 0;
}

@end
