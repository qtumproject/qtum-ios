//
//  WalletTypeCellWithCollection.m
//  qtum wallet
//
//  Created by Никита Федоренко on 03.04.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "WalletTypeCellWithCollection.h"

@implementation WalletTypeCellWithCollection

//-(void)prepareForReuse {
//    self.customImageView.image = [UIImage imageNamed:@"no-image"];
//    self.customTopLabel.text = @"";
//    self.customBottomLabel.text = @"";
//}
//
//#pragma mark - Public Methods
//
//-(void)setContentWithDict:(NewsCellModel*) object {
//    __weak __typeof(self)weakSelf = self;
//    NSString* url = object.imageUrl;
//    self.customImageView.associatedObject = url;
//    [[ImageLoader sharedInstance] getImageWithUrl:url withResultHandler:^(UIImage *image) {
//        if ([weakSelf.customImageView.associatedObject isEqualToString:url] && image) {
//            weakSelf.customImageView.image = image;
//        }
//    }];
//    self.customTopLabel.text = object.title;
//    self.customBottomLabel.text = [NSString stringWithFormat:@"%@", object.date];
//}

@end
