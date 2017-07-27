//
//  WatchContractOutputDelegate.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 27.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WatchContractOutputDelegate <NSObject>

- (void)didSelectChooseFromLibrary:(id)sender;
- (void)didChangeAbiText;
- (void)didPressedBack;

@end
