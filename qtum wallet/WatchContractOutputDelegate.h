//
//  WatchContractOutputDelegate.h
//  qtum wallet
//
//  Created by Никита Федоренко on 27.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WatchContractOutputDelegate <NSObject>

- (void)didSelectChooseFromLibrary:(id)sender;
- (void)didChangeAbiText;
- (void)didPressedBack;

@end
