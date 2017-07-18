//
//  WatchTokensViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 12.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContractCoordinator.h"

@protocol FavouriteTemplatesCollectionSourceOutput;

@interface WatchTokensViewController : BaseViewController <ScrollableContentViewController>

@property (weak,nonatomic) id <ContractCoordinatorDelegate> delegate;
@property (weak, nonatomic) id<FavouriteTemplatesCollectionSourceOutput> collectionSource;
@property (assign,nonatomic) UIEdgeInsets originInsets;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (void)changeStateForSelectedTemplate:(TemplateModel *)templateModel;

@end
