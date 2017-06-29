//
//  QStoreListViewController.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 28.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContractCoordinator.h"

typedef NS_ENUM(NSInteger, QStoreListType) {
    QStoreCategories,
    QStoreContracts
};

@interface QStoreListViewController : UIViewController

@property (weak,nonatomic) id <ContractCoordinatorDelegate> delegate;

@property (nonatomic) QStoreListType type;
@property (nonatomic) NSString *categoryTitle;

@end
