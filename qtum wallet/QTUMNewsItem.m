//
//  QTUMNewsItem.m
//  qtum wallet
//
//  Created by Никита Федоренко on 19.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QTUMNewsItem.h"


@interface QTUMNewsItem ()

@property (nonatomic, strong) NSArray<QTUMHTMLTagItem*>* tags;
@property (nonatomic, strong) QTUMFeedItem* feed;
@property (nonatomic, strong) NSString* identifire;

@end

@implementation QTUMNewsItem

-(instancetype)initWithTags:(NSArray<QTUMHTMLTagItem*>*) tags andFeed:(QTUMFeedItem*) feed {
    
    self = [super init];
    if (self) {
        _tags = tags;
        _feed = feed;
        _identifire = feed.identifier;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    
    if (self) {
        
        self.tags = [decoder decodeObjectForKey:@"tags"];
        self.feed = [decoder decodeObjectForKey:@"feed"];
        self.identifire = [decoder decodeObjectForKey:@"identifire"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.tags forKey:@"tags"];
    [encoder encodeObject:self.feed forKey:@"feed"];
    [encoder encodeObject:self.identifire forKey:@"identifire"];
}

#pragma mark - Equality

- (BOOL)isEqualToNewsItem:(QTUMNewsItem *)aNewsItem {
    
    if (!aNewsItem) {
        return NO;
    }
    
    BOOL haveEqualTags = (!self.tags && !aNewsItem.tags) || [self.tags isEqualToArray:aNewsItem.tags];
    BOOL haveEqualFeed = (!self.feed && !aNewsItem.feed) || [self.feed isEqual:aNewsItem.feed];
    BOOL haveEqualIdentifires = (!self.identifire && !aNewsItem.identifire) || [self.identifire isEqualToString:aNewsItem.identifire];
    
    return haveEqualTags && haveEqualFeed && haveEqualIdentifires;
}

- (BOOL)isEqual:(id)anObject {
    
    if (self == anObject) {
        return YES;
    }
    
    if (![anObject isKindOfClass:[QTUMNewsItem class]]) {
        return NO;
    }
    
    return [self isEqualToNewsItem:(QTUMNewsItem *)anObject];
}

- (NSUInteger)hash {
    
    return [self.tags hash]  ^ [self.feed hash] ^ [self.identifire hash];
}

@end
