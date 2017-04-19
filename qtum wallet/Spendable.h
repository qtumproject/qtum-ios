//
//  Spendable.h
//  qtum wallet
//
//  Created by Никита Федоренко on 19.04.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Managerable.h"
#import "HistoryElementProtocol.h"

@protocol Managerable;

@protocol Spendable <NSObject>

@property (copy, nonatomic) NSString* name;
@property (copy, nonatomic) NSString* balance;
@property (strong, nonatomic)NSArray <HistoryElementProtocol>*historyArray;
@property (copy, nonatomic)NSString* activeAddress;
@property (copy, nonatomic)NSString* symbol;
@property (weak, nonatomic)id <Managerable> manager;

-(void)updateBalance;
-(void)updateHistory;

@end
