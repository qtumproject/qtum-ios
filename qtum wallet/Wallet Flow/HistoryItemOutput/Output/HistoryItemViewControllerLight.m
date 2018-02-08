//
//  HistoryItemViewControllerLight.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 11.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "HistoryItemViewControllerLight.h"
#import "GradientView.h"
#import "HistoryOverviewTableCell.h"
#import "HistoryEventLogAddressCell.h"
#import "HistoryEventLogsConvertableDataCell.h"
#import "ChooseConverterView.h"

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

- (void)configCellRegistration {
    
    [self.owerviewTableView registerNib:[UINib nibWithNibName:@"HistoryOverviewTableCellLight" bundle:nil] forCellReuseIdentifier:historyOverviewTableCellIdentifier];
    [self.eventLogTableView registerNib:[UINib nibWithNibName:@"HistoryEventLogAddressCellLight" bundle:nil] forCellReuseIdentifier:historyEventLogAddressCellIdentifier];
    [self.eventLogTableView registerNib:[UINib nibWithNibName:@"HistoryEventLogsConvertableDataCellLight" bundle:nil] forCellReuseIdentifier:historyEventLogsConvertableDataCellIdentifier];
}

- (void)configWithItem {

	[super configWithItem];

	self.topGradient.colorType = self.item.send ? Pink : Green;
	self.confirmedLabel.text = self.item.confirmed ? NSLocalizedString(@"Confirmed", nil) : NSLocalizedString(@"Unconfirmed Yet...", nil);
	NSString *imageName = self.item.confirmed ? @"ic-confirmed" : @"ic-confirmation_loader";
	self.confirmedImageView.image = [UIImage imageNamed:imageName];
}

-(ChooseConverterView*)dropListView {
    
    ChooseConverterView* view = [[[NSBundle mainBundle] loadNibNamed:@"ChooseConverterViewLight" owner:self options:nil] objectAtIndex:0];
    return view;
}

@end
