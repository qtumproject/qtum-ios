//
//  TemplateManager.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Clearable.h"
#import "TemplateModel.h"

@interface TemplateManager : NSObject <Clearable>

- (NSArray<TemplateModel*>*)availebaleTemplates;
- (NSArray<TemplateModel*>*)availebaleTokenTemplates;
- (TemplateModel*)standartTokenTemplate;
- (TemplateModel*)createNewContractTemplateWithAbi:(NSString*)abi contractAddress:(NSString*) contractAddress andName:(NSString*) contractName;
- (TemplateModel*)createNewTokenTemplateWithAbi:(NSString*) abi contractAddress:(NSString*) contractAddress andName:(NSString*) contractName;
- (TemplateModel*)createNewTemplateWithAbi:(NSString*) abi
                                  bitecode:(NSString*) bitecode
                                    source:(NSString*) source
                                      type:(TemplateType) type
                                      uuid:(NSString*) uuid
                                   andName:(NSString*) templateName;
- (NSArray<NSDictionary*>*)decodeDataForBackup;
- (NSArray<TemplateModel*>*)encodeDataForBacup:(NSArray<NSDictionary*>*) backup;
- (NSArray<TemplateModel*>*)standartPackOfTemplates;
- (NSArray<TemplateModel*>*)standartPackOfTokenTemplates;

- (void)clear;
- (void)saveTemplate:(TemplateModel*) templateModel;

@end
