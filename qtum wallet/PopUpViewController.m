//
//  PopUpViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "PopUpViewController.h"

@interface PopUpViewController ()

@property (nonatomic) PopUpContent *content;

@end

@implementation PopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)showFromViewController:(UIViewController *)controller animated:(BOOL)animated completion:(void (^)(void))completion
{
    if (controller == nil) return;
    
    [controller presentViewController:self animated:animated completion:completion];
}

- (void)hide:(BOOL)animated completion:(void (^)(void))completion
{
    [self dismissViewControllerAnimated:animated completion:completion];
}

- (void)setContent:(PopUpContent *)content{
    self.content = content;
}

- (PopUpContent *)getContent{
    return self.content;
}

@end
