//
//  SubscribeTokenDataDisplayManagerProtocol.h
//  qtum wallet
//
//  Created by Никита Федоренко on 27.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubscribeTokenDataDisplayManagerDelegate.h"

@protocol SubscribeTokenDataDisplayManagerProtocol <UITableViewDelegate,UITableViewDataSource>

@property (copy, nonatomic) NSArray <Contract*>* tokensArray;
@property (weak, nonatomic) id <SubscribeTokenDataDisplayManagerDelegate> delegate;

@end
