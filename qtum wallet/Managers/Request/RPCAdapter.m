//
//  RPCAdapter.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "RPCAdapter.h"

@implementation RPCAdapter

- (id)adaptiveDataForHistory:(id) data{
    return data;
}

- (id)adaptiveDataForOutputs:(id) data{
//    NSMutableArray* newDataArray = @[].mutableCopy;
//    if ([data isKindOfClass:[NSArray class]]) {
//        for (NSDictionary* dict in data) {
//            NSMutableDictionary* newDataObject = [NSMutableDictionary dictionaryWithDictionary:dict];
//            if (newDataObject[@"amount"] && ![newDataObject[@"amount"] isKindOfClass:[NSNull class]]) {
//                NSInteger amount = [newDataObject[@"amount"] integerValue];
//                // div to satoshi
//                //amount = 100000000;
//                [newDataObject setObject:@(amount) forKey:@"amount"];
//            }
//            if (!newDataObject[@"block_hash"]){
//                [newDataObject setObject:@"" forKey:@"block_hash"];
//            }
//            if (!newDataObject[@"block_height"]){
//                [newDataObject setObject:@"" forKey:@"block_height"];
//            }
//            if (!newDataObject[@"block_id"]){
//                [newDataObject setObject:@"" forKey:@"block_id"];
//            }
//            if (!newDataObject[@"pubkey_hash"]){
//                [newDataObject setObject:@"" forKey:@"pubkey_hash"];
//            }
//            if (!newDataObject[@"tx_hash"]){
//                [newDataObject setObject:dict[@"txid"] forKey:@"tx_hash"];
//            }
//            if (!newDataObject[@"tx_id"]){
//                [newDataObject setObject:@"" forKey:@"tx_id"];
//            }
//            if (!newDataObject[@"txout_id"]){
//                [newDataObject setObject:@"" forKey:@"txout_id"];
//            }
//            if (!newDataObject[@"txout_scriptPubKey"]){
//                [newDataObject setObject:dict[@"scriptPubKey"] forKey:@"txout_scriptPubKey"];
//            }
//            [newDataArray addObject:[newDataObject copy]];
//        }
//    }
//    
//    return newDataArray.count > 0 ? newDataArray : data;
    return data;
}

- (CGFloat)adaptiveDataForBalance:(CGFloat) balance{
    return balance;
}

- (id)adaptiveDataForContractBalances:(id) data{
    return data;
}

@end
