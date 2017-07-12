//
//  ExportBrainKeyOutput.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 10.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "ExportBrainKeyOutputDelegate.h"

@protocol ExportBrainKeyOutput <NSObject>

@property (nonatomic, weak) id<ExportBrainKeyOutputDelegate> delegate;

@end
