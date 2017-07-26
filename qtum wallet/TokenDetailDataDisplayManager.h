//
//  TokenDetailDataDisplayManager.h
//  qtum wallet
//
//  Created by Никита Федоренко on 24.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TokenDetailDisplayDataManagerDelegate.h"
#import "Contract.h"

@protocol TokenDetailDataDisplayManager <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<TokenDetailDisplayDataManagerDelegate> delegate;
@property (nonatomic, strong) Contract* token;

@end
