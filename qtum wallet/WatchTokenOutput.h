//
//  WatchTokenOutput.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 24.11.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Presentable.h"

@protocol WatchTokenOutputDelegate <NSObject>

- (void)didPressedBack;
- (void)didEnterValidAddress:(NSString*) address;
- (void)didPressedCreateTokenWithName:(NSString*) tokenName andAddress:(NSString*) tokenAddress;

@end

@protocol WatchTokenOutput <Presentable>

@property (weak, nonatomic) id <WatchTokenOutputDelegate> delegate;

- (void)setTokenName:(NSString*) tokenName;

@end
