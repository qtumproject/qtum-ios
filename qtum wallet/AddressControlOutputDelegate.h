//
//  AddressControlOutputDelegate.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AddressControlOutputDelegate <NSObject>

-(void)didBackPress;
-(void)didPressCellAtIndexPath:(NSIndexPath*) indexPath withAddress:(NSString*)address;

@end
