//
//  InterfaceController.m
//  QTUM Watch Extension
//
//  Created by Sharaev Vladimir on 06.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QRCodeController.h"
#import "SessionManager.h"
#import "WatchWallet.h"

@interface QRCodeController ()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *imageView;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *reloadButton;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *statusLabel;

@property (nonatomic) WatchWallet *wallet;

@end


@implementation QRCodeController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    self.wallet = (WatchWallet *)context;
    
    UIImage *image = [UIImage imageWithData:self.wallet.imageData];
    [self.imageView setImage:image];
    [self.statusLabel setText:self.wallet.address];

    [SessionManager sharedInstance];
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)getText:(NSString *)text{
    [self.statusLabel setText:text];
}

@end



