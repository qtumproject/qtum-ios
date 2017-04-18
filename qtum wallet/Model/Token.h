//
//  TokenModel.h
//  qtum wallet
//
//  Created by Никита Федоренко on 17.04.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Token;

@protocol TokenDelegate <NSObject>

@required
- (void)tokenDidChange:(Token *)token;

@end

@interface Token : NSObject

@property (copy, nonatomic)NSString* contractAddress;
@property (strong, nonatomic)NSArray* adresses;
@property (strong, nonatomic)NSString* symbol;
@property (strong, nonatomic)NSString* decimals;
@property (strong, nonatomic)NSString* name;
@property (strong, nonatomic)NSString* totalSupply;
@property (nonatomic, weak) id<TokenDelegate> delegate;

-(void)setupWithHashTransaction:(NSString*) hash andAddresses:(NSArray*) addresses;

@end
