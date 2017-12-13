//
//  TokenDetailsViewControllerDark.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 24.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TokenDetailsViewControllerDark.h"

@interface TokenDetailsViewControllerDark ()

@property (weak, nonatomic) IBOutlet UILabel *activityTextLabel;

@end

@implementation TokenDetailsViewControllerDark

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityTextLabel.text = NSLocalizedString(@"Activity", @"");
}

@end
