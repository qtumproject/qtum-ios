//
//  LanguageOutput.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 10.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LanguageOutputDelegate.h"

@protocol LanguageOutput <NSObject>

@property (nonatomic, weak) id <LanguageOutputDelegate> delegate;

@end
