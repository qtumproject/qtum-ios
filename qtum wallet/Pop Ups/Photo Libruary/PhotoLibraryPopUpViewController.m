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

@end

@implementation PhotoLibraryPopUpViewController

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
