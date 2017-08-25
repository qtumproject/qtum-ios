//
//  QStoreViewController.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 26.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QStoreMainOutput.h"
#import "Presentable.h"
#import "CustomSearchBar.h"
#import "QStoreTableSource.h"
#import "SelectSearchTypeView.h"
#import "QStoreSearchTableSource.h"

@interface QStoreViewController : UIViewController <QStoreMainOutput, Presentable, SelectSearchTypeViewDelegate, QStoreTableSourceDelegate, QStoreSearchTableSourceDelegate>

@property (nonatomic) UIView *containerForSearchElements;
@property (nonatomic) SelectSearchTypeView *selectSearchType;
@property (nonatomic) NSLayoutConstraint *bottomConstraintForContainer;
@property (weak, nonatomic) IBOutlet CustomSearchBar *searchBar;
@property (nonatomic) UITableView *searchTableView;
@property (nonatomic) QStoreTableSource *source;
@property (nonatomic) QStoreSearchTableSource *searchSource;

@end
