//
//  RecieveOutput.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 11.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "RecieveOutputDelegate.h"

@protocol RecieveOutput <NSObject>

@property (nonatomic, weak) id<RecieveOutputDelegate> delegate;
@property (nonatomic, weak) id<Spendable> wallet;

@end
