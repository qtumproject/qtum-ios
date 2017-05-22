//
//  NewsDataSourceAndDelegate.h
//  qtum wallet
//
//  Created by Никита Федоренко on 20.02.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NewsCellModel;

@interface NewsDataSourceAndDelegate : NSObject <UITableViewDelegate,UITableViewDataSource>

@property (copy,nonatomic) NSArray <NewsCellModel*> * dataArray;

@end
