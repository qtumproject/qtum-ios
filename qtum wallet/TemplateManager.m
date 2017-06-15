//
//  TemplateManager.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "TemplateManager.h"
#import "FXKeychain.h"
#import "ContractFileManager.h"
#import "NSString+Extension.h"

@interface TemplateManager ()

@property (strong, atomic) NSMutableArray <TemplateModel*>* templates;

@end

static NSString* kAvailableTemplates = @"kAvailableTemplates";
static NSString* kNameKey = @"name";
static NSString* kUiidKey = @"uiid";
static NSString* kCreationDateKey = @"creationDate";
static NSString* kTypeKey = @"type";
static NSString* kSourceKey = @"source";
static NSString* kAbiKey = @"abi";
static NSString* kBitecode = @"bitecode";

@implementation TemplateManager

+ (instancetype)sharedInstance {
    
    static TemplateManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] initUniqueInstance];
    });
    return instance;
}

- (instancetype)initUniqueInstance {
    
    self = [super init];
    
    if (self != nil) {
        
        [self load];
    }
    return self;
}

- (void)load {
    
    NSMutableArray *savedTemplates = [[[FXKeychain defaultKeychain] objectForKey:kAvailableTemplates] mutableCopy];
    
    if (!savedTemplates.count) {
        self.templates = [[self getStandartPackOfTemplates] mutableCopy];
        [self save];
    } else {
        self.templates = savedTemplates;
    }
}

- (BOOL)save {
    
    BOOL templatesSaved = [[FXKeychain defaultKeychain] setObject:self.templates forKey:kAvailableTemplates];
    return templatesSaved;
}

-(NSArray<TemplateModel*>*)getStandartPackOfTemplates {
    
    TemplateModel* standartToken = [[TemplateModel alloc] initWithTemplateName:@"Standart" andType:TokenType withUiid:1];
    TemplateModel* v1Token = [[TemplateModel alloc] initWithTemplateName:@"Version1" andType:TokenType withUiid:2];
    TemplateModel* v2Token = [[TemplateModel alloc] initWithTemplateName:@"Version2" andType:TokenType withUiid:3];
    TemplateModel* crowdsale = [[TemplateModel alloc] initWithTemplateName:@"Crowdsale" andType:CrowdsaleType withUiid:4];
    
    return @[standartToken,v1Token,v2Token,crowdsale];
}

- (TemplateModel*)createNewContractTemplateWithAbi:(NSString*) abi contractAddress:(NSString*) contractAddress andName:(NSString*) contractName {
    
    NSError *err = nil;
    NSArray *jsonAbi = [NSJSONSerialization JSONObjectWithData:[abi dataUsingEncoding:NSUTF8StringEncoding]
                                                       options:NSJSONReadingMutableContainers
                                                         error:&err];
    // access the dictionaries
    if (jsonAbi && [[ContractFileManager sharedInstance] writeNewAbi:jsonAbi withPathName:contractAddress]) {
        TemplateModel* customToken = [[TemplateModel alloc] initWithTemplateName:contractAddress andType:UndefinedContractType withUiid:self.templates.count + 1];
        return customToken;
    }
    return nil;
}

- (TemplateModel*)createNewTokenTemplateWithAbi:(NSString*) abi contractAddress:(NSString*) contractAddress andName:(NSString*) contractName {
    
    NSError *err = nil;
    NSArray *jsonAbi = [NSJSONSerialization JSONObjectWithData:[abi dataUsingEncoding:NSUTF8StringEncoding]
                                                       options:NSJSONReadingMutableContainers
                                                         error:&err];
    
    if (jsonAbi && [[ContractFileManager sharedInstance] writeNewAbi:jsonAbi withPathName:contractAddress]) {
        TemplateModel* customToken = [[TemplateModel alloc] initWithTemplateName:contractAddress andType:TokenType withUiid:self.templates.count + 1];
        return customToken;
    }
    return nil;
}

-(NSArray<TemplateModel*>*)getAvailebaleTemplates {
    
    return self.templates.copy;
}

-(NSArray<NSDictionary*>*)backupDescription {
    
    NSMutableArray* backupArray = @[].mutableCopy;
    
    for (int i = 0; i < self.templates.count; i++) {
        NSMutableDictionary* backupItem = @{}.mutableCopy;
        TemplateModel* template = self.templates[i];
        ContractFileManager* fileManager = [ContractFileManager sharedInstance];
        [backupItem setObject:@(template.uiid) forKey:kUiidKey];
        [backupItem setObject:template.templateName ? template.templateName : @"" forKey:kNameKey];
        [backupItem setObject:template.templateTypeStringForBackup forKey:kTypeKey];
        [backupItem setObject:template.creationFormattedDateString forKey:kCreationDateKey];
        [backupItem setObject:[fileManager getContractWithTemplate:template.templateName] forKey:kSourceKey];
        [backupItem setObject:[fileManager getEscapeAbiWithTemplate:template.templateName] forKey:kAbiKey];
        [backupItem setObject:[NSString hexadecimalString:[fileManager getBitcodeWithTemplate:template.templateName]] forKey:kBitecode];
        [backupArray addObject:backupItem];
    }
    
    return backupArray.copy;
}


@end
