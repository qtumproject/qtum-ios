//
//  PageControl.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 06.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PageControlItem;

@interface PageControl : UIView

@property (nonatomic) NSInteger pagesCount;
@property (nonatomic) NSInteger selectedPage;

- (UIView <PageControlItem> *)createViewItem;

- (CGFloat)spaceBetweenItems;

@end
