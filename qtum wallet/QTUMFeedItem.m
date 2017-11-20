//
//  QTUMFeedItem.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

@interface QTUMFeedItem()

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSDate *updated;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSArray *enclosures;

@end

@implementation QTUMFeedItem

-(instancetype)initWithItem:(MWFeedItem*) feedItem {
    
    self = [super init];
    
    if (self) {
        _identifier = feedItem.identifier;
        _title = feedItem.title;
        _link = feedItem.link;
        _date = feedItem.date;
        _updated = feedItem.updated;
        _summary = feedItem.summary;
        _content = feedItem.content;
        _author = feedItem.author;
        _enclosures = feedItem.enclosures;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    
    if (self) {
        
        self.identifier = [decoder decodeObjectForKey:@"identifier"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.link = [decoder decodeObjectForKey:@"link"];
        self.date = [decoder decodeObjectForKey:@"date"];
        self.updated = [decoder decodeObjectForKey:@"updated"];
        self.summary = [decoder decodeObjectForKey:@"summary"];
        self.content = [decoder decodeObjectForKey:@"content"];
        self.author = [decoder decodeObjectForKey:@"author"];
        self.enclosures = [decoder decodeObjectForKey:@"enclosures"];
        
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.identifier forKey:@"identifier"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.link forKey:@"link"];
    [encoder encodeObject:self.date forKey:@"date"];
    [encoder encodeObject:self.updated forKey:@"updated"];
    [encoder encodeObject:self.summary forKey:@"summary"];
    [encoder encodeObject:self.content forKey:@"content"];
    [encoder encodeObject:self.author forKey:@"author"];
    [encoder encodeObject:self.enclosures forKey:@"enclosures"];
}

#pragma mark - Equality

- (BOOL)isEqualToFeedItem:(QTUMFeedItem *)aFeedItem {
    
    if (!aFeedItem) {
        return NO;
    }
    
    BOOL haveEqualIdentifire = (!self.identifier && !aFeedItem.identifier) || [self.identifier isEqualToString:aFeedItem.identifier];
    BOOL haveEqualTitle = (!self.title && !aFeedItem.title) || [self.title isEqualToString:aFeedItem.title];
    BOOL haveEqualLink = (!self.link && !aFeedItem.link) || [self.link isEqualToString:aFeedItem.link];
    BOOL haveEqualSummary = (!self.summary && !aFeedItem.summary) || [self.summary isEqualToString:aFeedItem.summary];
    BOOL haveEqualContent = (!self.content && !aFeedItem.content) || [self.content isEqualToString:aFeedItem.content];
    BOOL haveEqualAuthor = (!self.author && !aFeedItem.author) || [self.author isEqualToString:aFeedItem.author];
    BOOL haveEqualDate = (!self.date && !aFeedItem.date) || [self.date isEqual:aFeedItem.date];
    BOOL haveEqualUpdate = (!self.updated && !aFeedItem.updated) || [self.updated isEqual:aFeedItem.updated];

    return haveEqualIdentifire && haveEqualTitle && haveEqualLink && haveEqualSummary && haveEqualContent && haveEqualAuthor && haveEqualDate && haveEqualUpdate;
}

- (BOOL)isEqual:(id)anObject {
    
    if (self == anObject) {
        return YES;
    }
    
    if (![anObject isKindOfClass:[QTUMFeedItem class]]) {
        return NO;
    }
    
    return [self isEqualToFeedItem:(QTUMFeedItem *)anObject];
}

- (NSUInteger)hash {
    
    return [self.identifier hash] ^ [self.title hash] ^ [self.link hash] ^ [self.date hash] ^ [self.updated hash] ^ [self.summary hash] ^ [self.content hash] ^ [self.author hash];
}

@end
