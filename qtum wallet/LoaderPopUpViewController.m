//
//  LoaderPopUpViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 08.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "LoaderPopUpViewController.h"
#import "SpinnerView.h"

@interface LoaderPopUpViewController ()
@property (weak, nonatomic) IBOutlet SpinnerView *LoaderView;

@end

@implementation LoaderPopUpViewController

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)reloadLoaderAnimation {
	[self.LoaderView startAnimating];
}
@end
