//
//  SubscribeTokenDataDisplayManagerDelegate.h
//  qtum wallet
//
//  Created by Никита Федоренко on 27.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SubscribeTokenDataDisplayManagerDelegate <NSObject>

- (void)tableView:(UITableView *)tableView didSelectContract:(Contract *) contract;

@end
