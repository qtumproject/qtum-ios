//
//  PublishedContractListOutput.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 28.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PublishedContractListOutputDelegate.h"
#import "Presentable.h"

@protocol PublishedContractListOutput <Presentable>

@property (copy, nonatomic) NSArray <Contract*>* contracts;
@property (strong, nonatomic) NSDictionary *smartContractPretendents;
@property (weak, nonatomic) id <PublishedContractListOutputDelegate> delegate;

@end
