//
//  QStoreCategory.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreCategory.h"
#import "QStoreCategoryElement.h"

@interface QStoreCategory()

@property (nonatomic) NSInteger identifier;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *urlPath;
@property (nonatomic) NSArray<QStoreCategoryElement *> *elements;

@end

@implementation QStoreCategory

- (instancetype)initWithIdentifier:(NSInteger)identifier
                             title:(NSString *)title
                           urlPath:(NSString *)urlPath {
    
    self = [super init];
    if (self) {
        _identifier = identifier;
        _title = title;
        _urlPath = urlPath;
        _elements = [NSArray<QStoreCategoryElement *> new];
    }
    return self;
}

- (void)parseElementsFromJSONArray:(NSArray *)array {
    NSMutableArray *mutArray = [NSMutableArray new];
    for (NSDictionary *dictionary in array) {
        QStoreCategoryElement *element = [QStoreCategoryElement createFromDictionary:dictionary];
        if (element) {
            [mutArray addObject:element];
        }
    }
    self.elements = [NSArray arrayWithArray:mutArray];
}

@end
