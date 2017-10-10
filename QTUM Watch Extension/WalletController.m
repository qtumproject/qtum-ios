//
//  WalletController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 13.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "WalletController.h"
#import "WatchCoordinator.h"
#import "WatchWallet.h"
#import "BalanceCell.h"
#import "HistoryCell.h"
#import "NKWActivityIndicatorAnimation.h"

@interface WalletController() <BalanceCellDelegaete>

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *table;

@end

@implementation WalletController

- (void)awakeWithContext:(id)context {
    
    [super awakeWithContext:context];
    [self updateControls];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateControls) name:@"kWalletDidUpdate" object:nil];
}

-(void)updateControls {
    
    WatchWallet *wallet = [WatchCoordinator sharedInstance].wallet;
    
    NSMutableArray *mutArray = [NSMutableArray new];
    [mutArray addObject:@"BalanceCell"];
    for (NSInteger i = 0 ; i < wallet.history.count; i++) {
        [mutArray addObject:@"HistoryCell"];
    }
    [self.table setRowTypes:mutArray];
    
    BalanceCell *balance = [self.table rowControllerAtIndex:0];
    balance.delegate = self;
    [balance.address setTitle:wallet.address];
    [balance.availableBalance setText:[wallet.availableBalance stringValue]];
    [balance.notConfirmedBalance setText:[wallet.unconfirmedBalance stringValue]];
    
    for (NSInteger i = 0; i < wallet.history.count; i++) {
        WatchHistoryElement *element = [wallet.history objectAtIndex:i];
        
        HistoryCell *cell = [self.table rowControllerAtIndex:i + 1];
        [cell.address setText:element.address];
        [cell.amount setText:element.amount];
        [cell.date setText:element.date];
        [cell.leftBorder setBackgroundColor:element.send ? customRedColor() : customBlueColor()];
    }
}

- (void)willActivate {
    [self updateControls];
    [super willActivate];
}

#pragma mark - Actions

- (IBAction)refreshHistoryItem {
    
    WKInterfaceImage* image = [WKInterfaceImage new];
    
    NKWActivityIndicatorAnimation *animation = [[NKWActivityIndicatorAnimation alloc] initWithType:NKWActivityIndicatorAnimationTypeBallScale controller:self images:@[image]];
    
    [animation startAnimating];
}

#pragma mark - BalanceCellDelegaete

-(void)showQRCode {
    
    [self pushControllerWithName:@"QRCode" context:[WatchCoordinator sharedInstance].wallet];
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
