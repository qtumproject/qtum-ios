//
//  NewsDataSourceAndDelegate.h
//  qtum wallet
//
//  Created by Никита Федоренко on 20.02.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NewsCellModel;

@interface NewsDataSourceAndDelegate : NSObject <UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) NSMutableArray <NewsCellModel*> * dataArray;

@end
