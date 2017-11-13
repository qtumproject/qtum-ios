//
//  SourceCodeOutput.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.11.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Presentable.h"

@protocol SourceCodeOutputDelegate <NSObject>

-(void)didBackPressed;

@end

@protocol SourceCodeOutput <Presentable>

@property (weak, nonatomic) id <SourceCodeOutputDelegate> delegate;
@property (strong,nonatomic) NSAttributedString* sourceCode;

@end
