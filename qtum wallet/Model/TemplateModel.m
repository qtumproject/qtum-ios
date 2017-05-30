//
//  TemplateModel.m
//  qtum wallet
//
//  Created by Никита Федоренко on 30.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "TemplateModel.h"
#import "ContractFileManager.h"
#import "NSDate+Extension.h"

@implementation TemplateModel

-(instancetype)initWithTemplateName:(NSString*) templateName andType:(TemplateType) type {

    self = [super init];
    if (self) {
        _templateName = templateName;
        _type = type;
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

-(NSDate*)creationDate {
    return [[ContractFileManager sharedInstance] getDateOfCreationTemplate:self.templateName];
}

-(NSString*)creationDateString {
    return [[[ContractFileManager sharedInstance] getDateOfCreationTemplate:self.templateName] formatedDateString];
}

#pragma  mark - NSCoder

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.templateName forKey:@"templateName"];
    [aCoder encodeObject:@(self.type) forKey:@"type"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    NSString *templateName = [aDecoder decodeObjectForKey:@"templateName"];
    NSInteger type = [[aDecoder decodeObjectForKey:@"type"] integerValue];

    self = [super init];
    if (self) {
        _templateName = templateName;
        _type = type;
    }
    
    return self;
}

@end
