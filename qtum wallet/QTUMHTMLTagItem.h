//
//  QTUMHTMLTagItem.h
//  qtum wallet
//
//  Created by Никита Федоренко on 19.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QTUMTagsAttribute.h"

@interface QTUMHTMLTagItem : NSObject

@property (nonatomic, copy) NSString* raw;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* content;
@property (nonatomic, copy) NSDictionary* attributes;
@property (nonatomic, copy) NSArray<QTUMHTMLTagItem*>* childrenTags;

@end

