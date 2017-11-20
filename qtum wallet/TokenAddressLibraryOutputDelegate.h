//
//  TokenAddressLibraryOutputDelegate.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TokenAddressLibraryOutputDelegate <NSObject>

- (void)didBackPress;

- (void)didPressCellAtIndexPath:(NSIndexPath *) indexPath withAddress:(NSString *) address;

@end
