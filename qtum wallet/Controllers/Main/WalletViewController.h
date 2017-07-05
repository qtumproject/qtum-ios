//
//  MainViewController.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.11.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletTableSource.h"
#import "WalletOutput.h"

@interface WalletViewController : BaseViewController <ControllerDelegate, WalletOutput>

// Output property
@property (strong, nonatomic) WalletTableSource* tableSource;
@property (weak, nonatomic) id <WalletOutputDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
