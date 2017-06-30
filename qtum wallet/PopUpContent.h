//
//  PopUpContent.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 03.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PopUpContent : NSObject

@property (copy, nonatomic) NSString *titleString;
@property (copy, nonatomic) NSString *messageString;
@property (copy, nonatomic) NSString *okButtonTitle;
@property (copy, nonatomic) NSString *cancelButtonTitle;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message okTitle:(NSString *)okTitle cancelTitle:(NSString *)cancelTitle;

@end
