//
//  LanguageTableSource.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 23.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LanguageTableSourceDelegate <NSObject>

- (void)languageDidChanged;

@end

@interface LanguageTableSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<LanguageTableSourceDelegate> delegate;
@property (nonatomic) NSString *cellIdentifier;

@end
