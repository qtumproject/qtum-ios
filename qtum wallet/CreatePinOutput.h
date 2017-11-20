//
//  CreatePinOutput.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 10.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreatePinOutputDelegate.h"

@protocol CreatePinOutput <NSObject>

@property (weak, nonatomic) id <CreatePinOutputDelegate> delegate;

@end
