//
//  SourceCodeViewController.m
//  qtum wallet
//
//  Created by Fedorenko Nikita on 13.11.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "SourceCodeViewController.h"

@interface SourceCodeViewController ()

@property (weak, nonatomic) IBOutlet UITextView *codeTextView;

@end

@implementation SourceCodeViewController

@synthesize delegate, sourceCode;

#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.codeTextView.attributedText = self.sourceCode;
}

#pragma mark - IBActions

- (IBAction)doBackAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didBackPressed)]) {
        
        [self.delegate didBackPressed];
    }
}

@end
