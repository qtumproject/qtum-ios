//
//  TemplatesListOutput.h
//  qtum wallet
//
//  Created by Никита Федоренко on 28.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TemplatesListOutputDelegate.h"
#import "TemplateModel.h"
#import "Presentable.h"

@protocol TemplatesListOutput <Presentable>

@property (copy, nonatomic) NSArray <TemplateModel*>* templateModels;
@property (weak,nonatomic) id <TemplatesListOutputDelegate> delegate;

@end
