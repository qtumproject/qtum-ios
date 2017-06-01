//
//  HistoryHeaderVIew.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.04.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";

@interface HistoryHeaderVIew : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIView *activityView;
@property (weak, nonatomic) IBOutlet UIView *shortInfoView;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

- (void)fadeInActivity;
- (void)fadeOutActivity;

@end
