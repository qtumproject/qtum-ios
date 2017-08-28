//
//  AboutOutput.h
//  qtum wallet
//
//  Created by Никита Федоренко on 28.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Presentable.h"
#import "AboutOutputDelegate.h"

@protocol AboutOutput <Presentable>

@property (weak, nonatomic) id <AboutOutputDelegate> delegate;

@end
