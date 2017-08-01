//
//  BackupContractOutput.h
//  qtum wallet
//
//  Created by Никита Федоренко on 01.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BackupContractOutputDelegate.h"
#import "Presentable.h"

@protocol BackupContractOutput <Presentable>

@property (weak,nonatomic) id <BackupContractOutputDelegate> delegate;

@end
