//
//  TemplateModel.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TemplateModel.h"
#import "ContractFileManager.h"
#import "NSDate+Extension.h"

@implementation TemplateModel

-(instancetype)initWithTemplateName:(NSString*) templateName
                            andType:(TemplateType) type
                           withuuid:(NSString*) uuid
                            path:(NSString*) path
                             isFull:(BOOL) isFullTemplate {

    self = [super init];
    if (self) {
        _templateName = templateName;
        _type = type;
        _uuid = uuid;
        _path = path;
        _isFullTemplate = isFullTemplate;
    }
    return self;
}

-(NSString*)templateTypeString {
    
    switch (self.type) {
            
        case NotmalContract:
            return @"";
            
        case TokenType:
            return NSLocalizedString(@"Token", @"");
            
        case UndefinedContractType:
            return @"";
            
        case CrowdsaleType:
            return NSLocalizedString(@"Crowdsale", @"");
    }
}

-(NSString*)templateTypeStringForBackup {
    
    switch (self.type) {
        case TokenType:
            return @"token";
        case NotmalContract:
            return @"contract";
        case CrowdsaleType:
            return @"crowdsale";
        case UndefinedContractType:
            return @"undefined";
        default:
            return @"";
    }
}

+(TemplateType)templateTypeFromForBackupString:(NSString*) type {
    
    if ([type isEqualToString:@"token"]) {
        return TokenType;
    } else if ([type isEqualToString:@"contract"]) {
        return NotmalContract;
    } else if ([type isEqualToString:@"crowdsale"]) {
        return CrowdsaleType;
    } else if ([type isEqualToString:@"undefined"]) {
        return UndefinedContractType;
    } else {
        return UndefinedContractType;
    }
}

-(NSDate*)creationDate {
    return [[ContractFileManager sharedInstance] dateOfCreationTemplate:self.path];
}

-(NSString*)creationDateString {
    return [[[ContractFileManager sharedInstance] dateOfCreationTemplate:self.path] formatedDateString];
}

-(NSString*)creationFormattedDateString {
    return [[[ContractFileManager sharedInstance] dateOfCreationTemplate:self.path] string];
}

#pragma  mark - NSCoder

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.templateName forKey:@"templateName"];
    [aCoder encodeObject:@(self.type) forKey:@"type"];
    [aCoder encodeObject:self.uuid forKey:@"uuid"];
    [aCoder encodeObject:self.path forKey:@"path"];
    [aCoder encodeObject:@(self.isFullTemplate) forKey:@"isFullTemplate"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    NSString *templateName = [aDecoder decodeObjectForKey:@"templateName"];
    NSInteger type = [[aDecoder decodeObjectForKey:@"type"] integerValue];
    NSString *uuid = [[aDecoder decodeObjectForKey:@"uuid"] isKindOfClass:[NSNumber class]] ? [NSString stringWithFormat:@"%@",[aDecoder decodeObjectForKey:@"uuid"]] : [aDecoder decodeObjectForKey:@"uuid"];
    NSString *path = [aDecoder decodeObjectForKey:@"path"];
    BOOL isFullTemplate = [[aDecoder decodeObjectForKey:@"isFullTemplate"] boolValue];

    self = [super init];
    if (self) {
        _templateName = templateName;
        _type = type;
        _uuid = uuid;
        _path = path;
        _isFullTemplate = isFullTemplate;
    }
    
    return self;
}

#pragma mark - Equality

- (BOOL)isEqualToTemplateModel:(TemplateModel *)aModel {
    
    if (!aModel) {
        return NO;
    }

    BOOL haveEqualTemplateNames = (!self.templateName && !aModel.templateName) || [self.templateName isEqualToString:aModel.templateName];
    BOOL haveEqualPath = (!self.path && !aModel.path) || [self.path isEqualToString:aModel.path];
    BOOL haveEqualUuid = (!self.uuid && !aModel.uuid) || [self.uuid isEqualToString:aModel.uuid];
    BOOL haveEqualType = self.type == aModel.type;
    BOOL haveEqualFull = self.isFullTemplate == aModel.isFullTemplate;

    return haveEqualTemplateNames && haveEqualPath && haveEqualType && haveEqualUuid && haveEqualFull;
}

- (BOOL)isEqual:(id)anObject {
    
    if (self == anObject) {
        return YES;
    }
    
    if (![anObject isKindOfClass:[TemplateModel class]]) {
        return NO;
    }
    
    return [self isEqualToTemplateModel:(TemplateModel *)anObject];
}

- (NSUInteger)hash {
    
    return [self.templateName hash] ^ self.type ^ [self.path hash] ^ [self.uuid hash] ^ self.isFullTemplate;
}

@end
