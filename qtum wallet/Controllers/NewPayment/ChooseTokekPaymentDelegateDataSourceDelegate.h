//
//  ChooseTokekPaymentDelegateDataSourceDelegate.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 10.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChooseTokekPaymentDelegateDataSourceDelegate <NSObject>

@required
- (void)didSelectTokenIndexPath:(NSIndexPath *)indexPath withItem:(Contract*) item;
- (void)didResetToDefaults;

@optional
- (void)didDeselectTokenIndexPath:(NSIndexPath *)indexPath withItem:(Contract*) item;

@end
