//
//  QTUMHtmlParcer.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QTUMHTMLTagItem.h"
#import "Cancelable.h"

typedef void(^QTUMTagsItems) (NSArray <QTUMHTMLTagItem*>* feeds);

@interface QTUMHtmlParcer : NSObject <Cancelable>

-(void)parceNewsFromHTMLString:(NSString*) html withCompletion:(QTUMTagsItems) completion;

@end
