//
//  ExportWalletBrandKeyOutput.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 10.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExportWalletBrandKeyOutputDelegate.h"

@protocol ExportWalletBrandKeyOutput <NSObject>

@property (weak,nonatomic) id <ExportWalletBrandKeyOutputDelegate> delegate;

@end
