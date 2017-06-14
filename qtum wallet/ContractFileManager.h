//
//  ContractFileManager.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 16.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TemplateModel.h"

@interface ContractFileManager : NSObject

-(NSDictionary*) getAbiWithTemplate:(NSString*) templateName;

-(NSString*) getEscapeAbiWithTemplate:(NSString*) templateName;

-(NSString*)getContractWithTemplate:(NSString*) templateName;

-(NSData*)getBitcodeWithTemplate:(NSString*) templateName;

-(NSDictionary*)getStandartAbi;

-(NSDate*)getDateOfCreationTemplate:(NSString*) templateName;

-(BOOL)writeNewAbi:(NSArray*) abi withPathName:(NSString*) newTeplateName;

+ (instancetype)sharedInstance;

- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));


@end
