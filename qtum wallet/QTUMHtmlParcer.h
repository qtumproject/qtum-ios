//
//  QTUMHtmlParcer.h
//  qtum wallet
//
//  Created by Никита Федоренко on 19.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QTUMHTMLTagItem.h"

typedef void(^QTUMTagsItems) (NSArray <QTUMHTMLTagItem*>* feeds);

@interface QTUMHtmlParcer : NSObject

-(void)parceNewsFromHTMLString:(NSString*) html withCompletion:(QTUMTagsItems) completion;

@end
