//
//  ChoseTokenPaymentOutputDelegate.h
//  qtum wallet
//
//  Created by Никита Федоренко on 04.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChoseTokenPaymentOutputDelegate <NSObject>

@required
- (void)didSelectTokenIndexPath:(NSIndexPath *)indexPath withItem:(Contract*) item;
- (void)didDeselectTokenIndexPath:(NSIndexPath *)indexPath withItem:(Contract*) item;
- (void)resetToDefaults;

@end
