//
//  QStoreTableViewCellLight.m
//  qtum wallet
//
//  Created by Никита Федоренко on 18.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreTableViewCellLight.h"

@implementation QStoreTableViewCellLight

+ (CGFloat)getHeightCellForRowCount:(NSInteger)count {
    
    CGFloat heightCell = 130.0f;
    CGFloat spaceBetweenRows = 15.0f;
    CGFloat headerHeight = 33.0f;
    
   // return heightCell * count + spaceBetweenRows * (count - 1) + headerHeight;
    return 200;
}

@end
