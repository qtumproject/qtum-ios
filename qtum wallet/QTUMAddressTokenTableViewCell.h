//
//  QTUMAddressTokenTableViewCell.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 19.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QTUMAddressTokenTableViewCellDelegate <NSObject>

@required
- (void)actionPlus:(id)sender;
- (void)actionTokenAddressControl;

@end

@interface QTUMAddressTokenTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) id <QTUMAddressTokenTableViewCellDelegate> delegate;

@end
