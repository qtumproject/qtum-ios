//
//  PinController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 05.01.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "BaseViewController.h"

@interface PinController : BaseViewController

@property (assign, nonatomic, getter = isEditingEnabled) BOOL editingEnabled;

@end
