//
//  QRCodeOutput.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 28.11.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Presentable.h"

@class SendInfoItem;

@protocol QRCodeOutputDelegate <Presentable>

- (void)didQRCodeScannedWithSendInfoItem:(SendInfoItem *) item;
- (void)didBackPressed;

@end

@protocol QRCodeOutput <Presentable>

@property (nonatomic, weak) id <QRCodeOutputDelegate> delegate;

@end
