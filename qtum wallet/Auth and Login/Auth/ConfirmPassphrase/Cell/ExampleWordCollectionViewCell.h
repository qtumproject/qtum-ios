//
//  ExampleWordCollectionViewCell.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.01.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* exampleWordCollectionViewCellIdentifire;

@interface ExampleWordCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end
