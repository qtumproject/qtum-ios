//
//  HistoryItemViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.04.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HistoryElement;

@interface HistoryItemViewController : BaseViewController

@property (strong, nonatomic)HistoryElement* item;

@end
