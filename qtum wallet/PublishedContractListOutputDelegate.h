//
//  PublishedContractListOutputDelegates.h
//  qtum wallet
//
//  Created by Никита Федоренко on 28.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PublishedContractListOutputDelegate <NSObject>

-(void)didSelectContractWithIndexPath:(NSIndexPath*) indexPath withContract:(Contract*) contract;
-(void)didPressedBack;

@end
