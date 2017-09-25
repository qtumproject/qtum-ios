//
//  AboutOutputViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 28.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "AboutOutputViewController.h"

@interface AboutOutputViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *companyAndVersionText;

@end

@implementation AboutOutputViewController

@synthesize delegate;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configLogo];
    [self configText];
}

#pragma mark - Configuration

-(void)configLogo {
    
    UIImage *originalImage = [UIImage imageNamed:@"new-logo.png"];
    UIImage *tintedImage = [originalImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.logoImage.tintColor = [self logoColor];
    self.logoImage.image = tintedImage;
}

-(void)configText {
    
    NSString* text = [NSString stringWithFormat:@"© 2017 Qtum\nVersion %@ (%@)",[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"],[[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey]];
    self.companyAndVersionText.text = NSLocalizedString(text, @"");
}

-(UIColor*)logoColor {
    return lightDarkGrayColor();
}

#pragma mark - Actions

- (IBAction)actionBack:(id)sender {
    
    [self.delegate didBackPressed];
}


@end
