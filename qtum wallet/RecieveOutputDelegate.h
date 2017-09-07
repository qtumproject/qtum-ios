//
//  RecieveOutputDelegate.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 11.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

@protocol RecieveOutputDelegate <NSObject>

- (void)didBackPressed;
@optional
-(void)didPressedChooseAddressWithPreviusAddress:(NSString*) prevAddress;

@end
