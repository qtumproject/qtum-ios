//
//  TemplateManager.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TemplateManager : NSObject

+ (instancetype)sharedInstance;
- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

- (NSArray<TemplateModel*>*)getAvailebaleTemplates;
- (TemplateModel*)createNewContractTemplateWithAbi:(NSString*)abi contractAddress:(NSString*) contractAddress andName:(NSString*) contractName;
- (TemplateModel*)createNewTokenTemplateWithAbi:(NSString*) abi contractAddress:(NSString*) contractAddress andName:(NSString*) contractName;
- (NSArray<NSDictionary*>*)backupDescription;


@end
