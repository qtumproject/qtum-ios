//
//  PopUpContent.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 03.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PopUpContent : NSObject

@property (nonatomic) NSString *titleString;
@property (nonatomic) NSString *messageString;
@property (nonatomic) NSString *okButtonTitle;
@property (nonatomic) NSString *cancelButtonTitle;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message okTitle:(NSString *)okTitle cancelTitle:(NSString *)cancelTitle;

@end
