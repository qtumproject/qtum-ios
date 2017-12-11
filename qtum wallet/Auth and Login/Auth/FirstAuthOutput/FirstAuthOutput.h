//
//  FirstAuthOutput.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 10.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FirstAuthOutputDelegate.h"
#import "Presentable.h"

@protocol FirstAuthOutput <Presentable>

@property (weak, nonatomic) id <FirstAuthOutputDelegate> delegate;

@end
