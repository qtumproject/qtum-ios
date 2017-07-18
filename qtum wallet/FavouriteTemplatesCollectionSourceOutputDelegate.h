//
//  FavouriteTemplatesCollectionSourceOutputDelegate.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 17.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

@protocol FavouriteTemplatesCollectionSourceOutputDelegate <NSObject>

@required
- (void)didSelectTemplate:(TemplateModel *)template sender:(id)sender;
- (void)didResetToDefaults:(id)sender;

@end
