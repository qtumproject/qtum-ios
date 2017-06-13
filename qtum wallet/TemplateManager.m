//
//  TemplateManager.m
//  qtum wallet
//
//  Created by Никита Федоренко on 13.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "TemplateManager.h"
#import "FXKeychain.h"
#import "ContractFileManager.h"

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
    
    TemplateModel* standartToken = [[TemplateModel alloc] initWithTemplateName:@"Standart" andType:TokenType];
    TemplateModel* v1Token = [[TemplateModel alloc] initWithTemplateName:@"Version1" andType:TokenType];
    TemplateModel* v2Token = [[TemplateModel alloc] initWithTemplateName:@"Version2" andType:TokenType];
    TemplateModel* crowdsale = [[TemplateModel alloc] initWithTemplateName:@"Crowdsale" andType:CrowdsaleType];
    
    return @[standartToken,v1Token,v2Token,crowdsale];
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
        [backupItem setObject:@(i) forKey:kUiidKey];
        [backupItem setObject:template.templateName ? template.templateName : @"" forKey:kNameKey];
        [backupItem setObject:template.templateTypeStringForBackup forKey:kTypeKey];
        [backupItem setObject:template.creationDate forKey:kCreationDateKey];
        [backupItem setObject:[fileManager getContractFromBundleWithTemplate:template.templateName] forKey:kSourceKey];
        [backupItem setObject:[fileManager getAbiFromBundleWithTemplate:template.templateName] forKey:kAbiKey];
        [backupItem setObject:[fileManager getBitcodeFromBundleWithTemplate:template.templateName] forKey:kBitecode];
        [backupArray addObject:backupItem];
    }
    
    return backupArray.copy;
}

@end
