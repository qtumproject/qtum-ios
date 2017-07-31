//
//  PublishedContractListOutput.h
//  qtum wallet
//
//  Created by Никита Федоренко on 28.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PublishedContractListOutputDelegate.h"
#import "Presentable.h"

@protocol PublishedContractListOutput <Presentable>

@property (copy, nonatomic) NSArray <Contract*>* contracts;
@property (weak,nonatomic) id <PublishedContractListOutputDelegate> delegate;

@end
