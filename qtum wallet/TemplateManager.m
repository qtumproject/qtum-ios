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
static NSString* kuuidKey = @"uuid";
static NSString* kCreationDateKey = @"date_create";
static NSString* kTypeKey = @"type";
static NSString* kSourceKey = @"source";
static NSString* kAbiKey = @"abi";
static NSString* kBitecode = @"bytecode";
static int templatePathStringLengh = 10;
static NSString* standartTokenPath = @"StandardPath";
static NSString* erc20TokenUuid = @"erc20-token-identifire";
static NSString* humanTokenUuid = @"human-standard-token-identifire";
static NSString* crowdsaleUuid = @"crowdsale-identifire";

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
    NSArray *standartTemplates = [self standartPackOfTemplates];

    if (!savedTemplates.count) {
        
        self.templates = [standartTemplates mutableCopy];
    } else {
        
        NSArray* uniqueTemplates = [[NSSet setWithArray:[savedTemplates arrayByAddingObjectsFromArray:standartTemplates]] allObjects];
        self.templates = [uniqueTemplates mutableCopy];
    }
    
    [self save];
}

- (BOOL)save {
    
    BOOL templatesSaved = [[FXKeychain defaultKeychain] setObject:self.templates forKey:kAvailableTemplates];
    return templatesSaved;
}

-(TemplateModel*)standartTokenTemplate {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"templateName == %@ && path == %@",@"ERC20 Standard Token",@"ERC20TokenStandard"];
    NSArray* tepmlates = [self.templates filteredArrayUsingPredicate:predicate];
    return tepmlates.firstObject;
}

-(NSArray<TemplateModel*>*)standartPackOfTemplates {
    
    TemplateModel* erc20 = [[TemplateModel alloc] initWithTemplateName:@"ERC20 Standard Token" andType:TokenType withuuid:erc20TokenUuid path:@"ERC20TokenStandard" isFull:YES];
    TemplateModel* human = [[TemplateModel alloc] initWithTemplateName:@"Human Standard Token" andType:TokenType withuuid:humanTokenUuid path:@"HumanStandardToken" isFull:YES];
    
    TemplateModel* crowdsale = [[TemplateModel alloc] initWithTemplateName:@"Crowdsale" andType:CrowdsaleType withuuid:crowdsaleUuid path:@"Crowdsale" isFull:YES];
    
    return @[erc20,human,crowdsale];
}

-(NSArray<TemplateModel*>*)standartPackOfTokenTemplates {
    
    NSArray *standartTemplates = [self standartPackOfTemplates];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %i",TokenType];
    return [standartTemplates filteredArrayUsingPredicate:predicate];
}

- (TemplateModel*)createNewContractTemplateWithAbi:(NSString*) abi contractAddress:(NSString*) contractAddress andName:(NSString*) contractName {
    
    NSError *err = nil;
    NSArray *jsonAbi = [NSJSONSerialization JSONObjectWithData:[abi dataUsingEncoding:NSUTF8StringEncoding]
                                                       options:NSJSONReadingMutableContainers
                                                         error:&err];
    NSString* filePath = [NSString randomStringWithLength:templatePathStringLengh];
    if (jsonAbi && [[ContractFileManager sharedInstance] writeNewAbi:jsonAbi withPathName:filePath]) {
        TemplateModel* customToken = [[TemplateModel alloc] initWithTemplateName:contractAddress andType:UndefinedContractType withuuid:[NSUUID UUID].UUIDString  path:filePath isFull:NO];
        [self.templates addObject:customToken];
        [self save];
        return customToken;
    }
    return nil;
}

- (TemplateModel*)createNewTokenTemplateWithAbi:(NSString*) abi contractAddress:(NSString*) contractAddress andName:(NSString*) contractName {
    
    NSError *err = nil;
    NSArray *jsonAbi = [NSJSONSerialization JSONObjectWithData:[abi dataUsingEncoding:NSUTF8StringEncoding]
                                                       options:NSJSONReadingMutableContainers
                                                         error:&err];
    
    NSString* filePath = [NSString randomStringWithLength:templatePathStringLengh];
    if (jsonAbi && [[ContractFileManager sharedInstance] writeNewAbi:jsonAbi withPathName:filePath]) {
        TemplateModel* customToken = [[TemplateModel alloc] initWithTemplateName:contractAddress andType:TokenType withuuid:[NSUUID UUID].UUIDString path:filePath isFull:NO];
        [self.templates addObject:customToken];
        [self save];
        return customToken;
    }
    return nil;
}

- (TemplateModel*)createNewTokenTemplateWithAbi:(NSString*) abi
                                       bitecode:(NSString*) bitecode
                                         source:(NSString*) source
                                contractAddress:(NSString*) contractAddress
                                        andName:(NSString*) contractName {
    
    NSError *err = nil;
    NSArray *jsonAbi = [NSJSONSerialization JSONObjectWithData:[abi dataUsingEncoding:NSUTF8StringEncoding]
                                                       options:NSJSONReadingMutableContainers
                                                         error:&err];
    
    NSString* filePath = [NSString randomStringWithLength:templatePathStringLengh];
    if (jsonAbi &&
        [[ContractFileManager sharedInstance] writeNewAbi:jsonAbi withPathName:filePath] &&
        [[ContractFileManager sharedInstance] writeNewBitecode:bitecode withPathName:filePath] &&
        [[ContractFileManager sharedInstance] writeNewSource:source withPathName:filePath]) {
        
        TemplateModel* customToken = [[TemplateModel alloc] initWithTemplateName:contractAddress andType:TokenType withuuid:[NSUUID UUID].UUIDString path:filePath isFull:YES];
        [self.templates addObject:customToken];
        [self save];
        return customToken;
    }
    
    return nil;
}

-(TemplateModel*)templateWithUUIDFromTemplateDict:(NSDictionary*) templateDict {
    
    NSArray<TemplateModel*>* standartTemplates = [self standartPackOfTemplates];
    NSString* templateUUID = templateDict[kuuidKey];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid == %@",templateDict[kuuidKey]];
    NSArray* tepmlatesWithUUID = [standartTemplates filteredArrayUsingPredicate:predicate];
    TemplateModel* template = tepmlatesWithUUID.count > 0 ? tepmlatesWithUUID.firstObject : nil;
    
    if (template) {
        
        return template;
    } else if (templateUUID){
        
        template = [self createNewTemplateWithAbi:templateDict[kAbiKey]
                                         bitecode:templateDict[kBitecode]
                                           source:templateDict[kSourceKey]
                                             type:[TemplateModel templateTypeFromForBackupString:templateDict[kTypeKey]]
                                             uuid:templateDict[kuuidKey]
                                          andName:templateDict[kNameKey]];
        return template;
    }
    
    return nil;
}

- (TemplateModel*)createNewTemplateWithAbi:(NSString*) abi
                                   bitecode:(NSString*) bitecode
                                     source:(NSString*) source
                                       type:(TemplateType) type
                                       uuid:(NSString*) uuid
                                    andName:(NSString*) templateName {
    NSArray *jsonAbi;
    NSError *err;
    BOOL proccesWithoutErrors = uuid ? YES : NO;
    BOOL abiSuccess = YES;
    NSString* filePath = [NSString randomStringWithLength:templatePathStringLengh];

    if (abi.length > 0) {
        err = nil;
        jsonAbi = [NSJSONSerialization JSONObjectWithData:[abi dataUsingEncoding:NSUTF8StringEncoding]
                                                  options:NSJSONReadingMutableContainers
                                                    error:&err];
        proccesWithoutErrors = proccesWithoutErrors & [[ContractFileManager sharedInstance] writeNewAbi:jsonAbi withPathName:filePath];
        abiSuccess = proccesWithoutErrors;
    }
    
    if (bitecode.length > 0) {
        proccesWithoutErrors = proccesWithoutErrors & [[ContractFileManager sharedInstance] writeNewBitecode:bitecode withPathName:filePath];
    } else {
        proccesWithoutErrors = NO;
    }

    if (source.length > 0) {
        proccesWithoutErrors = proccesWithoutErrors & [[ContractFileManager sharedInstance] writeNewSource:source withPathName:filePath];
    }  else {
        proccesWithoutErrors = NO;
    }
    
    if (proccesWithoutErrors) {
        
        TemplateModel* customToken = [[TemplateModel alloc] initWithTemplateName:templateName andType:type withuuid:uuid  path:filePath isFull:YES];
        [self.templates addObject:customToken];
        [self save];
        return customToken;
    } else if(abiSuccess){
        
        TemplateModel* customToken = [[TemplateModel alloc] initWithTemplateName:templateName andType:type withuuid:uuid  path:filePath isFull:NO];
        [self.templates addObject:customToken];
        [self save];
        return customToken;
    }
    
    return nil;
}

-(NSArray<TemplateModel*>*)availebaleTemplates {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFullTemplate == YES"];
    return [self.templates filteredArrayUsingPredicate:predicate];
}

- (NSArray<TemplateModel*>*)availebaleTokenTemplates {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %i",TokenType];
    NSArray *available = [self availebaleTemplates];
    return [available filteredArrayUsingPredicate:predicate];
}

-(NSArray<NSDictionary*>*)decodeDataForBackup {
    
    NSMutableArray* backupArray = @[].mutableCopy;
    
    for (int i = 0; i < self.templates.count; i++) {
        
        NSMutableDictionary* backupItem = @{}.mutableCopy;
        TemplateModel* template = self.templates[i];
        ContractFileManager* fileManager = [ContractFileManager sharedInstance];
        backupItem[kuuidKey] = template.uuid;
        backupItem[kNameKey] = template.templateName ?: @"";
        backupItem[kTypeKey] = template.templateTypeStringForBackup;
        backupItem[kCreationDateKey] = template.creationFormattedDateString;
        backupItem[kAbiKey] = [fileManager escapeAbiWithTemplate:template.path];
        //need to check is full template, coz it may have no source and bytecode
        backupItem[kSourceKey] = template.isFullTemplate ? [fileManager contractWithTemplate:template.path] : @"";
        backupItem[kBitecode] = template.isFullTemplate ? [NSString hexadecimalString:[fileManager bitcodeWithTemplate:template.path]] : @"";
        [backupArray addObject:backupItem];
    }
    
    return backupArray.copy;
}

-(NSArray<TemplateModel*>*)encodeDataForBacup:(NSArray<NSDictionary*>*) backup {
    
    NSMutableArray* newTemplates = @[].mutableCopy;
    for (NSDictionary* templateDict in backup) {
        
        TemplateModel* template = [self templateWithUUIDFromTemplateDict:templateDict];
        if (template) {
            [newTemplates addObject:template];
        }
    }
    
    return [newTemplates copy];
}

-(void)clear {
    
    self.templates = [[self standartPackOfTemplates] mutableCopy];
    [self save];
}

@end
