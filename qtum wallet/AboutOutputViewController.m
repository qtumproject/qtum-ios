//
//  AboutOutputViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 28.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "AboutOutputViewController.h"

@interface AboutOutputViewController ()

@end

@implementation AboutOutputViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Actions

- (IBAction)actionBack:(id)sender {
    
    [self.delegate didBackPressed];
}


@end
