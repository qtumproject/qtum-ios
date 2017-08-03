//
//  TokenAddressLibraryOutput.h
//  qtum wallet
//
//  Created by Никита Федоренко on 03.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TokenAddressLibraryOutputDelegate.h"
#import "Presentable.h"

@protocol TokenAddressLibraryOutput <Presentable>

@property (weak, nonatomic) id <TokenAddressLibraryOutputDelegate> delegate;
@property (copy, nonatomic) NSDictionary <NSString*, NSNumber*>* addressesValueHashTable;

-(void)reloadData;

@end
