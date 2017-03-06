//
//  WalletTypeCollectionCell.m
//  qtum wallet
//
//  Created by Никита Федоренко on 06.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "WalletTypeCollectionCell.h"

@interface WalletTypeCollectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeWalletLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressValueLabel;

@end

@implementation WalletTypeCollectionCell

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
