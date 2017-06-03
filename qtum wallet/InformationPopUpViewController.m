//
//  InformationPopUpViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 03.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "InformationPopUpViewController.h"

@interface InformationPopUpViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation InformationPopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PopUpContent *content = [self getContent];
    self.titleLabel.text = content.titleString;
    [self.okButton setTitle:content.okButtonTitle forState:UIControlStateNormal];
}

- (IBAction)actionOk:(id)sender {
    if ([self.delegate respondsToSelector:@selector(okButtonPressed:)]) {
        [self.delegate okButtonPressed:self];
    }
}


@end
