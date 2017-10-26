//
//  QTUMHtmlParcer.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QTUMHtmlParcer.h"
#import "NSString+HTML.h"
#import "TFHpple.h"

@interface QTUMHtmlParcer ()

@property (nonatomic, copy) QTUMTagsItems completion;
@property (nonatomic, strong) NSOperationQueue* workingQueue;
@property (nonatomic, strong) TFHpple *parser;
@end

@implementation QTUMHtmlParcer


#pragma mark - Custom Accessors

-(NSOperationQueue*)workingQueue {
    
    if (!_workingQueue) {
        _workingQueue = [[NSOperationQueue alloc] init];
        _workingQueue.maxConcurrentOperationCount = 1;
    }
    return _workingQueue;
}

#pragma mark - Public

-(void)parceNewsFromHTMLString:(NSString*) html withCompletion:(QTUMTagsItems) completion {
    
    __weak __typeof(self)weakSelf = self;

    dispatch_block_t block = ^{
        
        NSString* htmlWithDiv = [NSString stringWithFormat:@"<div class=\"medium-parcing-container\">%@</div>",html];
        NSData *htmlData = [htmlWithDiv dataUsingEncoding:NSUTF8StringEncoding];
        TFHpple *parser = [TFHpple hppleWithHTMLData:htmlData];
        weakSelf.parser = parser;
        NSString *xpathQueryString = @"//div[@class='medium-parcing-container']";
        NSArray *nodes = [parser searchWithXPathQuery:xpathQueryString];
        
        NSArray *tagItems = [weakSelf createThreeOfTagsWith:[nodes[0] children]];
        
        if (weakSelf.completion) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.completion(tagItems);
            });
        }
    };

    self.completion = completion;
    [self.workingQueue addOperationWithBlock:block];

}

#pragma mark - Private

-(NSArray<QTUMHTMLTagItem*>*)createThreeOfTagsWith:(NSArray<TFHppleElement*>*) elements{
    
    NSMutableArray<QTUMHTMLTagItem*>* tagsItems = @[].mutableCopy;
    
    for (TFHppleElement* happleElement in elements) {
        
        if ([happleElement.tagName isEqualToString:@"text"] || [happleElement.tagName isEqualToString:@"script"]) {
            continue;
        }
        
        if ([happleElement.tagName isEqualToString:@"img"] && [happleElement.attributes[@"width"] isEqualToString:@"1"]) {
            continue;
        }
        
        QTUMHTMLTagItem* tag = [[QTUMHTMLTagItem alloc] init];
        tag.content = happleElement.content;
        tag.name = happleElement.tagName;
        tag.raw = happleElement.raw;
        tag.attributes = happleElement.attributes;
        tag.attributedContent = [self attributedStringWithHTML:tag.raw];
        
        if (happleElement.children.count > 0) {
            
            tag.childrenTags = [self createThreeOfTagsWith:happleElement.children];
        }
        
        [tagsItems addObject:tag];
    }
    
    return [tagsItems copy];
}

- (NSAttributedString *)attributedStringWithHTML:(NSString *)HTML {
    
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                               NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
                               };
    NSMutableAttributedString* attrString = [[NSAttributedString alloc] initWithData:[HTML dataUsingEncoding:NSUTF8StringEncoding] options:options documentAttributes:NULL error:NULL].mutableCopy;
    
    while ([attrString.mutableString containsString:@"\n"]) {
        NSRange range = [attrString.mutableString rangeOfString:@"\n"];
        [attrString replaceCharactersInRange:range  withAttributedString:[[NSMutableAttributedString alloc] initWithString:@" "]];
    }
    return attrString;
}

@end
