//
//  PhotoLibraryPopUpViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "PhotoLibraryPopUpViewController.h"

@interface PhotoLibraryPopUpViewController ()

- (IBAction)dontAllowButtonWasPressed:(id) sender;

- (IBAction)okButtonWasPressed:(id) sender;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoTextLabel;

@end

@implementation PhotoLibraryPopUpViewController

#pragma mark - Lifecycle

-(void)viewDidLoad {
    [super viewDidLoad];
    [self configLocalization];
}

#pragma mark - Configuration

-(void)configLocalization {
    
    self.titleTextLabel.text = NSLocalizedString(@"QTUM App Would Like\nto Access Your Photos", @"");
    self.infoTextLabel.text = NSLocalizedString(@"QTUM App will only upload\nand share photos you choose.", @"");
}

#pragma mark - Action

- (IBAction)dontAllowButtonWasPressed:(id) sender {
	if ([self.delegate respondsToSelector:@selector (cancelButtonPressed:)]) {
		[self.delegate cancelButtonPressed:self];
	}
}

- (IBAction)okButtonWasPressed:(id) sender {
	if ([self.delegate respondsToSelector:@selector (okButtonPressed:)]) {
		[self.delegate okButtonPressed:self];
	}
}
@end
