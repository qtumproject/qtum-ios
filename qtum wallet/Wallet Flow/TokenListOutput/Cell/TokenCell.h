//
//  TokenCell.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *tokenCellIdentifire = @"tokenCellIdentifire";
static NSString *tokenCellUnsupportedIdentifire = @"tokenCellIdentifireUnsupported";

typedef NS_ENUM(NSUInteger, TokenCellType) {
    Normal,
    Unsupported
};


@interface TokenCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *tokenName;
@property (weak, nonatomic) IBOutlet UILabel *mainSymbol;
@property (weak, nonatomic) IBOutlet UILabel *symbol;
@property (weak, nonatomic) IBOutlet UILabel *mainValue;
@property (weak, nonatomic) IBOutlet UILabel *value;
@property (weak, nonatomic) Contract *token;
@property (assign, nonatomic) TokenCellType type;

- (void)setupWithObject:(id) object;

- (void)changeHighlight:(BOOL) value;

@end
