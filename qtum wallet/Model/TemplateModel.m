//
//  TemplateModel.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "TemplateModel.h"
#import "ContractFileManager.h"
#import "NSDate+Extension.h"

@implementation TemplateModel

-(instancetype)initWithTemplateName:(NSString*) templateName andType:(TemplateType) type withUiid:(NSInteger) uiid {

    self = [super init];
    if (self) {
        _templateName = templateName;
        _type = type;
        _uiid = uiid;
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
            return @"Crowdsale";
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

-(NSDate*)creationDate {
    return [[ContractFileManager sharedInstance] getDateOfCreationTemplate:self.templateName];
}

-(NSString*)creationDateString {
    return [[[ContractFileManager sharedInstance] getDateOfCreationTemplate:self.templateName] formatedDateString];
}

-(NSString*)creationFormattedDateString {
    return [[[ContractFileManager sharedInstance] getDateOfCreationTemplate:self.templateName] string];
}

#pragma  mark - NSCoder

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.templateName forKey:@"templateName"];
    [aCoder encodeObject:@(self.type) forKey:@"type"];
    [aCoder encodeObject:@(self.uiid) forKey:@"uiid"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    NSString *templateName = [aDecoder decodeObjectForKey:@"templateName"];
    NSInteger type = [[aDecoder decodeObjectForKey:@"type"] integerValue];
    NSInteger uiid = [[aDecoder decodeObjectForKey:@"uiid"] integerValue];

    self = [super init];
    if (self) {
        _templateName = templateName;
        _type = type;
        _uiid = uiid;
    }
    
    return self;
}

@end
