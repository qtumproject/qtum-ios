//
//  PhotoLibraryPopUpViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "PhotoLibraryPopUpViewController.h"

@interface PhotoLibraryPopUpViewController ()

- (IBAction)dontAllowButtonWasPressed:(id)sender;
- (IBAction)okButtonWasPressed:(id)sender;

@end

@implementation PhotoLibraryPopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dontAllowButtonWasPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(cancelButtonPressed)]) {
        [self.delegate cancelButtonPressed];
    }
}

- (IBAction)okButtonWasPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(okButtonPressed)]) {
        [self.delegate okButtonPressed];
    }
}
@end
