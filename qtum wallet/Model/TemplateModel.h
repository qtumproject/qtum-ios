//
//  TemplateModel.h
//  qtum wallet
//
//  Created by Никита Федоренко on 30.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TemplateType) {
    
    TokenType,
    NotmalContract,
    CrowdsaleType,
    UndefinedContractType,
};

@interface TemplateModel : NSObject

@property (copy, nonatomic) NSString* templateName;
@property (copy, nonatomic,readonly) NSString* templateTypeString;
@property (strong, nonatomic,readonly) NSDate* creationDate;
@property (copy, nonatomic,readonly) NSString* creationDateString;
@property (assign, nonatomic) TemplateType type;

-(instancetype)initWithTemplateName:(NSString*) templateName andType:(TemplateType) type;

@end
