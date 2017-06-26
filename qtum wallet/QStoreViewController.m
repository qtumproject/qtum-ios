//
//  QStoreViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 26.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreViewController.h"
#import "QStoreCollectionViewSource.h"

@interface QStoreViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic) QStoreCollectionViewSource *source;

@end

@implementation QStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.source = [QStoreCollectionViewSource new];
    self.collectionView.dataSource = self.source;
    self.collectionView.delegate = self.source;
}

- (IBAction)actionBack:(id)sender {
    NSLog(@"Back");
}

- (IBAction)actionAdd:(id)sender {
    NSLog(@"Add");
}

- (IBAction)actionCategories:(id)sender {
    NSLog(@"Categories");
}

@end
