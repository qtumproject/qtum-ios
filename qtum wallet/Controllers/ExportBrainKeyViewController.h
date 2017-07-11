//
//  ExportBrainKeyViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 22.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExportBrainKeyOutput.h"
#import "Presentable.h"

@interface ExportBrainKeyViewController : BaseViewController <ExportBrainKeyOutput, Presentable>

@property (nonatomic, weak) id<ExportBrainKeyOutputDelegate> delegate;

@end
