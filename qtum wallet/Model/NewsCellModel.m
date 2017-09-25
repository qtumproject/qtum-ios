//
//  NewsCellModel.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 07.02.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NewsCellModel.h"

@interface NewsCellModel ()

@property (strong,nonatomic) NSString* body;
@property (strong,nonatomic) NSDate* date;
@property (strong,nonatomic) NSString* identifire;
@property (strong,nonatomic) NSString* imageUrl;
@property (strong,nonatomic) NSString* linkUrl;
@property (strong,nonatomic) NSString* shortString;
@property (strong,nonatomic) NSString* title;

@end

@implementation NewsCellModel

-(instancetype)initWithDict:(NSDictionary*) dict{
    self = [super init];
    if (self) {
        [self setupWithDict:dict];
    }
    return self;
}

-(void)setupWithDict:(NSDictionary*)dict{
    
    if ([dict isNull]) {return;}
    
    if (dict[@"date"] && ![dict[@"date"] isNull]) {
        self.date = dict[@"date"];
    }
    if (dict[@"link"] && ![dict[@"link"] isNull]) {
        self.title = dict[@"link"];
    }
    if (dict[@"id"] && ![dict[@"id"] isNull]) {
        self.identifire = dict[@"id"];
    }
    if (dict[@"link"] && ![dict[@"link"] isNull]) {
        self.linkUrl = dict[@"link"];
    }
    if (dict[@"short"] && ![dict[@"short"] isNull]) {
        self.shortString = dict[@"short"];
    }
    if (dict[@"image"] && ![dict[@"image"] isNull]) {
        self.imageUrl = dict[@"image"];
    }
    if (dict[@"title"] && ![dict[@"title"] isNull]) {
        self.title = dict[@"title"];
    }
    if (dict[@"body"] && ![dict[@"body"] isNull]) {
        self.body = dict[@"body"];
    }
}


@end
