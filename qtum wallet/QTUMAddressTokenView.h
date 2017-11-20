//
//  QTUMAddressTokenView.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 29.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QTUMAddressTokenViewDelegate <NSObject>

@required
- (void)actionPlus:(id)sender;
- (void)actionTokenAddressControl;

@end

@interface QTUMAddressTokenView : UIView

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) id <QTUMAddressTokenViewDelegate> delegate;

@end
