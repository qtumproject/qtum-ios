//
//  NewsCellModel.h
//  qtum wallet
//
//  Created by Никита Федоренко on 07.02.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsCellModel : NSObject

@property (strong,nonatomic,readonly) NSString* body;
@property (strong,nonatomic,readonly) NSDate* date;
@property (strong,nonatomic,readonly) NSString* identifire;
@property (strong,nonatomic,readonly) NSString* imageUrl;
@property (strong,nonatomic,readonly) NSString* linkUrl;
@property (strong,nonatomic,readonly) NSString* shortString;
@property (strong,nonatomic,readonly) NSString* title;

-(instancetype)initWithDict:(NSDictionary*) dict;

@end
