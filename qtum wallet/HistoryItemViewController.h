//
//  HistoryItemViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.04.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HistoryElement;

@interface HistoryItemViewController : UIViewController

@property (strong, nonatomic)HistoryElement* item;

@end
