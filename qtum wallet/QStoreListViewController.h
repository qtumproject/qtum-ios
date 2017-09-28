//
//  QStoreListViewController.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 28.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QStoreListOutput.h"
#import "Presentable.h"
#import "QStoreListTableSource.h"
#import "SelectSearchTypeView.h"

@interface QStoreListViewController : UIViewController <QStoreListOutput, Presentable, SelectSearchTypeViewDelegate>

@property (nonatomic) QStoreListTableSource *source;
@property (nonatomic) SelectSearchTypeView *selectSearchType;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForSearhTypeContainer;
@property (weak, nonatomic) IBOutlet UIView *searhTypeContainer;

@end
