//
//  QTUMAddressTokenView.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 29.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QTUMAddressTokenViewDelegate <NSObject>

@required
- (void)actionPlus:(id)sender;

@end

@interface QTUMAddressTokenView : UIView

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) id <QTUMAddressTokenViewDelegate> delegate;

@end
