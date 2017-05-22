//
//  TokenDetailsTableSource.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 19.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TokenDetailsTableSourceDelegate <NSObject>

- (void)scrollViewDidScrollWithSecondSectionHeaderY:(CGFloat)headerY;

@end

@interface TokenDetailsTableSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<TokenDetailsTableSourceDelegate> delegate;

@end
