//
//  ContractFileManager.h
//  qtum wallet
//
//  Created by Никита Федоренко on 16.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContractFileManager : NSObject

+(NSDictionary*)getAbiFromBundle;
+(NSString*)getContractFromBundle;
+(NSData*)getBitcodeFromBundle;

@end
