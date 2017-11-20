//
//  SourceCodeFormatService.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.11.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SourceCodeFormatService : NSObject

- (NSAttributedString *)formattingSourceCodeStringWithString:(NSString *) sourceCode;

@end
