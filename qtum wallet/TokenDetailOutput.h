//
//  TokenDetailOutput.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 24.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TokenDetailOutputDelegate.h"
#import "Contract.h"
#import "TokenDetailDataDisplayManager.h"
#import "Presentable.h"

@protocol TokenDetailOutput <NSObject, Presentable>

@property (nonatomic, weak) id<TokenDetailOutputDelegate> delegate;
@property (nonatomic, strong) Contract* token;
@property (nonatomic, weak) id <TokenDetailDataDisplayManager> source;

-(void)updateControls;

@end
