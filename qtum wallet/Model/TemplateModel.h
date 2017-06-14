//
//  TemplateModel.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
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
@property (copy, nonatomic,readonly) NSString* templateTypeStringForBackup;
@property (strong, nonatomic,readonly) NSDate* creationDate;
@property (copy, nonatomic,readonly) NSString* creationDateString;
@property (copy, nonatomic,readonly) NSString* creationFormattedDateString;
@property (assign, nonatomic) TemplateType type;
@property (assign, nonatomic) NSInteger uiid;

-(instancetype)initWithTemplateName:(NSString*) templateName andType:(TemplateType) type withUiid:(NSInteger) uiid;

@end
