//
//  QStoreTemplateDetailOutput.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 24.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Presentable.h"
#import "QStoreTemplateDetailOutputDelegate.h"

@class InterfaceInputFormModel;

@protocol QStoreTemplateDetailOutput <Presentable>

@property (weak, nonatomic) id <QStoreTemplateDetailOutputDelegate> delegate;
@property (strong,nonatomic) InterfaceInputFormModel* formModel;

@end
