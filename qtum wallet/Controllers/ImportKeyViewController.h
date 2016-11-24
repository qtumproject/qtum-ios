//
//  ImportKeyViewController.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 24.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImportKeyViewControllerDelegate <NSObject>

- (void)addressImported;

@end

@interface ImportKeyViewController : UIViewController

@property (nonatomic, weak) id<ImportKeyViewControllerDelegate> delegate;

@end
