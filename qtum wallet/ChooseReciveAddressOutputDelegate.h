//
//  ChooseReciveAddressOutputDelegate.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 23.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChooseReciveAddressOutputDelegate <NSObject>

-(void)didChooseAddress:(NSString*) address;
-(void)didBackPressed;

@end
