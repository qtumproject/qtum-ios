//
//  ChangePinOutput.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 11.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "ChangePinOutputDelegate.h"

@protocol ChangePinOutput <NSObject>

//@property (nonatomic, weak) id<ChangePinOutputDelegate> delegate;

- (void)setCustomTitle:(NSString *)title;

@end
