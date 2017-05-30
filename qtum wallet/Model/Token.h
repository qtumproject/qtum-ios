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
#import "TemplateModel.h"

@class Token;

@protocol TokenDelegate <NSObject>

@required
- (void)tokenDidChange:(Token *)token;

@end

@interface Token : NSObject <Spendable>

@property (copy, nonatomic) NSString* name;
@property (copy, nonatomic) NSString* localName;
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
@property (strong, nonatomic) TemplateModel* templateModel;
@property (strong, nonatomic) NSDate* creationDate;
@property (copy, nonatomic, readonly) NSString* creationDateString;

@property (nonatomic, weak) id<TokenDelegate> delegate;

-(void)setupWithHashTransaction:(NSString*) hash andAddresses:(NSArray*) addresses andTokenTemplate:(TemplateModel*) templateModel;
-(void)setupWithContractAddresse:(NSString*) contractAddresse;

@end
