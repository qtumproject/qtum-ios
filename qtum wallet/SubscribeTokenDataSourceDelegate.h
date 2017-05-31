//
//  SubscribeTokenDataSourceDelegate.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Spendable.h"

@interface SubscribeTokenDataSourceDelegate : NSObject <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) NSArray <Spendable>* tokensArray;

@end
