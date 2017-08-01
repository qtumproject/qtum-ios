//
//  TokenFunctionDetailViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 22.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContractFunctionDetailOutput.h"

@class Contract;

@interface TokenFunctionDetailViewController : BaseViewController <ScrollableContentViewController, ContractFunctionDetailOutput>

@end
