//
//  QTUMHtmlParcer.m
//  qtum wallet
//
//  Created by Никита Федоренко on 19.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QTUMHtmlParcer.h"
#import "NSString+HTML.h"
#import "TFHpple.h"

@interface QTUMHtmlParcer ()

@property (nonatomic, copy) QTUMTagsItems completion;
@property (nonatomic, strong) NSMutableArray<QTUMHTMLTagItem*>* tagsItems;
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

-(NSMutableArray*)tagsItems {
    
    if (!_tagsItems) {
        _tagsItems = @[].mutableCopy;
    }
    return _tagsItems;
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
        
        [weakSelf createThreeOfTagsWith:[nodes[0] children]];
        
        if (weakSelf.completion) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.completion(self.tagsItems);
            });
        }
    };

    self.completion = completion;
    [self.workingQueue addOperationWithBlock:block];

}

#pragma mark - Private

-(NSArray<QTUMHTMLTagItem*>*)createThreeOfTagsWith:(NSArray<TFHppleElement*>*) elements{
    
    for (TFHppleElement* happleElement in elements) {
        
        QTUMHTMLTagItem* tag = [[QTUMHTMLTagItem alloc] init];
        tag.content = happleElement.content;
        tag.name = happleElement.tagName;
        tag.raw = happleElement.raw;
        
        NSMutableArray* attributes = @[].mutableCopy;
//        for (TFHppleElement* attributesElement in happleElement.attributes) {
//            
//            QTUMTagsAttribute* attribute = [[QTUMTagsAttribute alloc] init];
//            attribute.name = attributesElement.tagName;
//            attribute.content = attributesElement.content;
//            [attributes addObject:attribute];
//        }

        tag.attributes = attributes;
        
        [self.tagsItems addObject:tag];
        
        if (happleElement.children.count > 0) {
            [self createThreeOfTagsWith:happleElement.children];
        }
    }
    
    return nil;
}

@end
