//
//  QStoreListViewControllerLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QStoreListViewControllerLight.h"
#import "QStoreListTableSourceLight.h"

@interface QStoreListViewControllerLight ()

@end

@implementation QStoreListViewControllerLight

@synthesize source = _source;

-(QStoreListTableSource*)source {
    
    if (!_source) {
        _source = [QStoreListTableSourceLight new];
    }
    return _source;
}

- (void)createSelectSearchView {
    
    self.selectSearchType = [[[NSBundle mainBundle] loadNibNamed:@"SelectSearchTypeViewLight" owner:self options:nil] firstObject];
    self.selectSearchType.alpha = 1.0f;
    self.selectSearchType.translatesAutoresizingMaskIntoConstraints = NO;
    self.selectSearchType.delegate = self;
    
    self.searhTypeContainer.clipsToBounds = YES;
    [self.searhTypeContainer addSubview:self.selectSearchType];
    
    NSDictionary *views = @{@"selectSearchType" : self.selectSearchType};
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[selectSearchType]-0-|" options:0 metrics:nil views:views];
    NSArray *horisontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[selectSearchType]-0-|" options:0 metrics:nil views:views];
    
    [self.searhTypeContainer addConstraints:horisontalConstraints];
    [self.searhTypeContainer addConstraints:verticalConstraints];
}

@end
