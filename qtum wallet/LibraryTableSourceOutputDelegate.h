//
//  LibraryTableSourceOutputDelegate.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 17.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

@protocol LibraryTableSourceOutputDelegate <NSObject>

@required
- (void)didSelectTemplate:(TemplateModel *)template sender:(id)sender;
- (void)didResetToDefaults:(id)sender;

@end
