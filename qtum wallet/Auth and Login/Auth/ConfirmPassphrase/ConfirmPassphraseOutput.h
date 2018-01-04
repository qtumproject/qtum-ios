//
//  ConfirmPassphraseOutput.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.01.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Presentable.h"

@protocol ConfirmPassphraseOutputDelegate <NSObject>

-(void)didEnterWords:(NSArray<NSString*>*) words;
-(void)didBackPressed;

@end

@protocol ConfirmPassphraseOutput <Presentable>

@property (weak, nonatomic) id <ConfirmPassphraseOutputDelegate> delegate;
@property (copy, nonatomic) NSArray* bkWords;

-(void)failedRemindWords;

@end
