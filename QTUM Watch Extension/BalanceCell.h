//
//  BalanceCell.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 13.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>

@interface BalanceCell : NSObject

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *availableBalance;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *notConfirmedBalance;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *address;

@end
