//
//  NewsDataSourceAndDelegate.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 20.02.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NewsCellModel;

@interface NewsDataSourceAndDelegate : NSObject <UITableViewDelegate,UITableViewDataSource>

@property (copy,nonatomic) NSArray <NewsCellModel*> * dataArray;

@end
