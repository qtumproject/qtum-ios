//
//  WalletController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 13.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "WalletController.h"
#import "SessionManager.h"
#import "WatchWallet.h"
#import "BalanceCell.h"
#import "HistoryCell.h"

@interface WalletController() <BalanceCellDelegaete>

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *table;
@property (nonatomic) WatchWallet *wallet;

@end

@implementation WalletController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    self.wallet = (WatchWallet *)context;
    
    NSMutableArray *mutArray = [NSMutableArray new];
    [mutArray addObject:@"BalanceCell"];
    for (NSInteger i = 0 ; i < self.wallet.history.count; i++) {
        [mutArray addObject:@"HistoryCell"];
    }
    [self.table setRowTypes:mutArray];
    
    BalanceCell *balance = [self.table rowControllerAtIndex:0];
    balance.delegate = self;
    [balance.address setTitle:self.wallet.address];
    [balance.availableBalance setText:[self.wallet.availableBalance stringValue]];
    [balance.notConfirmedBalance setText:[self.wallet.unconfirmedBalance stringValue]];
    
    for (NSInteger i = 0; i < self.wallet.history.count; i++) {
        WatchHistoryElement *element = [self.wallet.history objectAtIndex:i];
        
        HistoryCell *cell = [self.table rowControllerAtIndex:i + 1];
        [cell.address setText:element.address];
        [cell.amount setText:element.amount];
        [cell.date setText:element.date];
        [cell.leftBorder setBackgroundColor:element.send ? customRedColor() : customBlueColor()];
    }
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

#pragma mark - BalanceCellDelegaete

-(void)showQRCode {
    [self presentControllerWithName:@"QRCode" context:self.wallet];
}

#pragma mark - Colors

UIColor *customBlueColor()
{
    return [UIColor colorWithRed:46/255.0f green:154/255.0f blue:208/255.0f alpha:1.0f];
}

UIColor *customRedColor()
{
    return [UIColor colorWithRed:231/255.0f green:86/255.0f blue:71/255.0f alpha:1.0f];
}

UIColor *customBlackColor()
{
    return [UIColor colorWithRed:35/255.0f green:35/255.0f blue:40/255.0f alpha:1.0f];
}

@end
