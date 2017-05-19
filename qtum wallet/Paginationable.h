//
//  Paginationable.h
//  qtum wallet
//
//  Created by Никита Федоренко on 19.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomPageControl;

@protocol Paginationable <NSObject>

-(void)setCurrentPage:(NSInteger) page;
-(void)setNumberPages:(NSInteger) number;

@end
