//
//  LibraryTableSourceOutputDelegate.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 17.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

@protocol LibraryTableSourceOutputDelegate <NSObject>

@required
- (void)didSelectTemplateIndexPath:(NSIndexPath *)indexPath withItem:(TemplateModel *)contract;
- (void)didResetToDefaults;

@end
