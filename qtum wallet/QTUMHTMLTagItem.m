//
//  QTUMHTMLTagItem.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

@implementation QTUMHTMLTagItem

- (instancetype)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    
    if (self) {
        
        self.raw = [decoder decodeObjectForKey:@"raw"];
        self.attributedContent = [decoder decodeObjectForKey:@"attributedContent"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.content = [decoder decodeObjectForKey:@"content"];
        self.attributes = [decoder decodeObjectForKey:@"attributes"];
        self.childrenTags = [decoder decodeObjectForKey:@"childrenTags"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.raw forKey:@"raw"];
    [encoder encodeObject:self.attributedContent forKey:@"attributedContent"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.content forKey:@"content"];
    [encoder encodeObject:self.attributes forKey:@"attributes"];
    [encoder encodeObject:self.childrenTags forKey:@"childrenTags"];
}

- (BOOL)isEqualToTagItem:(QTUMHTMLTagItem *)aTagItem {
    
    if (!aTagItem) {
        return NO;
    }
    
    BOOL haveEqualRaw = (!self.raw && !aTagItem.raw) || [self.raw isEqualToString:aTagItem.raw];
    BOOL haveEqualName = (!self.name && !aTagItem.name) || [self.name isEqualToString:aTagItem.name];
    BOOL haveEqualContent = (!self.content && !aTagItem.content) || [self.content isEqualToString:aTagItem.content];
    BOOL haveEqualAttributs = (!self.attributes && !aTagItem.attributes) || [self.attributes isEqualToDictionary:aTagItem.attributes];
    BOOL haveEqualChildren = (!self.childrenTags && !aTagItem.childrenTags) || [self.childrenTags isEqualToArray:aTagItem.childrenTags];

    return haveEqualRaw && haveEqualName && haveEqualContent && haveEqualAttributs && haveEqualChildren;
}

- (BOOL)isEqual:(id)anObject {
    
    if (self == anObject) {
        return YES;
    }
    
    if (![anObject isKindOfClass:[QTUMHTMLTagItem class]]) {
        return NO;
    }
    
    return [self isEqualToTagItem:(QTUMHTMLTagItem *)anObject];
}

- (NSUInteger)hash {
    
    return [self.raw hash] ^ [self.attributedContent hash] ^ [self.name hash] ^ [self.content hash] ^ [self.attributes hash] ^ [self.childrenTags hash];
}

@end
