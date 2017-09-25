//
//  HistoryItemViewControllerLight.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 11.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "HistoryItemViewControllerLight.h"
#import "GradientView.h"

@interface HistoryItemViewControllerLight ()

@property (weak, nonatomic) IBOutlet GradientView *bottomGradient;
@property (weak, nonatomic) IBOutlet GradientView *topGradient;
@property (weak, nonatomic) IBOutlet UIImageView *confirmedImageView;
@property (weak, nonatomic) IBOutlet UILabel *confirmedLabel;

@end

@implementation HistoryItemViewControllerLight

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bottomGradient.colorType = White;
}

- (void)configWithItem {
    
    [super configWithItem];
    
    self.topGradient.colorType = self.item.send ? Pink : Green;
    self.confirmedLabel.text = self.item.confirmed ? NSLocalizedString(@"Confirmed", nil) : NSLocalizedString(@"Unconfirmed Yet...", nil);
    NSString *imageName = self.item.confirmed ? @"ic-confirmed" : @"ic-confirmation_loader";
    self.confirmedImageView.image = [UIImage imageNamed:imageName];
}

@end
