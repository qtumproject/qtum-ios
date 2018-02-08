//
//  HistoryOverviewTableCell.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 07.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *historyOverviewTableCellIdentifier = @"HistoryOverviewTableCellIdentifire";


@protocol HistoryOverviewTableCellDelegate <NSObject>

- (void)didPressedCopyWithValue:(NSString*) value;

@end

@interface HistoryOverviewTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueTextLabel;
@property (weak, nonatomic) id <HistoryOverviewTableCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *button;

-(void)sizeToFitLabels;

@end
