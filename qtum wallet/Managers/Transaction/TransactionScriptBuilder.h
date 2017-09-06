//
//  TransactionScriptBuilder.h
//  qtum wallet
//
//  Created by Никита Федоренко on 06.09.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransactionScriptBuilder : NSObject

-(BTCScript*)createContractScriptWithBiteCode:(NSData*) bitcode;
-(BTCScript*)sendContractScriptWithBiteCode:(NSData*) bitcode
                         andContractAddress:(NSData*) address;

@end
