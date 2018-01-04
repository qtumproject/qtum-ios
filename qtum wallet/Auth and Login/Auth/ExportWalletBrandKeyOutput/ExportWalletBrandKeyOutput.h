//
//  ExportWalletBrandKeyOutput.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 10.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExportWalletBrandKeyOutputDelegate.h"
#import "Presentable.h"

@protocol ExportWalletBrandKeyOutput <Presentable>

@property (weak, nonatomic) id <ExportWalletBrandKeyOutputDelegate> delegate;
@property (nonatomic, copy) NSArray<NSString*> *brandKey;

@end
