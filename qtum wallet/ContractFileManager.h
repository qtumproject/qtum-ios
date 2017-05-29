//
//  ContractFileManager.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 16.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContractFileManager : NSObject

+(NSDictionary*)getAbiFromBundleWithTemplate:(NSString*) templateName;

+(NSString*)getContractFromBundleWithTemplate:(NSString*) templateName;

+(NSData*)getBitcodeFromBundleWithTemplate:(NSString*) templateName;

+(NSArray<NSString*>*)getAvailebaleTemplates;

+(NSDictionary*)getAbiFromBundle;


@end
