//
//  TokenListOutput.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 07.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TokenListOutputDelegate.h"

@protocol TokenListOutput <NSObject>

@property (copy, nonatomic) NSArray<Contract*>* tokens;
@property (weak,nonatomic) id <TokenListOutputDelegate> delegate;

-(void)reloadTable;

@end
