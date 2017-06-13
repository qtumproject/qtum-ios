//
//  CheckboxButton.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 12.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CheckboxButtonDelegate;

@interface CheckboxButton : UIView

- (void)setTitle:(NSString *)value;
- (void)setCheck:(BOOL)value;
- (BOOL)isChecked;

@property (nonatomic, weak) id<CheckboxButtonDelegate> delegate;

@end

@protocol CheckboxButtonDelegate <NSObject>

- (void)didStateChanged:(CheckboxButton *)sender;

@end
