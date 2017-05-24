//
//  TokenModel.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.04.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HistoryElementProtocol.h"
#import "Managerable.h"
@class Token;

@protocol TokenDelegate <NSObject>

@required
- (void)tokenDidChange:(Token *)token;

@end

@interface Token : NSObject <Spendable>

@property (copy, nonatomic) NSString* name;
@property (assign, nonatomic) CGFloat balance;
@property (assign, nonatomic) CGFloat unconfirmedBalance;
@property (strong, nonatomic)NSArray <HistoryElementProtocol>*historyArray;
@property (copy, nonatomic)NSString* mainAddress;
@property (copy, nonatomic)NSString* symbol;
@property (weak, nonatomic)id <Managerable> manager;
@property (strong, nonatomic) HistoryDataStorage* historyStorage;


@property (copy, nonatomic)NSString* contractAddress;
@property (strong, nonatomic)NSArray* adresses;
@property (strong, nonatomic)NSString* decimals;
@property (strong, nonatomic)NSString* totalSupply;
@property (strong, nonatomic)NSString* templateName;
@property (nonatomic, weak) id<TokenDelegate> delegate;

-(void)setupWithHashTransaction:(NSString*) hash andAddresses:(NSArray*) addresses andTokenTemplate:(NSString*) templateName;

@end
