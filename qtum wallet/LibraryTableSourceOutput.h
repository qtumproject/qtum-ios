//
//  LibraryTableSourceOutput.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 17.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "LibraryTableSourceOutputDelegate.h"

@protocol LibraryTableSourceOutput <NSObject, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) TemplateModel *activeTemplate;
@property (nonatomic) NSArray<TemplateModel *> *templetes;
@property (nonatomic, weak) id<LibraryTableSourceOutputDelegate> delegate;

@end
