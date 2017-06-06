//
//  InterfaceController.m
//  QTUM Watch Extension
//
//  Created by Sharaev Vladimir on 06.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "InterfaceController.h"
#import "SessionManager.h"

@interface InterfaceController ()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *imageView;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *reloadButton;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *statusLabel;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

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

- (IBAction)reloadAction {
    
    [self.statusLabel setText:@"Loading"];
    [self.reloadButton setEnabled:NO];
    
    typeof(self) weakSelf = self;
    [[SessionManager sharedInstance] sendGetQRCodeForSize:[WKInterfaceDevice currentDevice].screenBounds.size.width replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
        NSData *data = replyMessage[@"data"];
        NSString *key = replyMessage[@"key"];
        
        UIImage *image = [UIImage imageWithData:data];
        [weakSelf.imageView setImage:image];
        [weakSelf.statusLabel setText:key];
        [weakSelf.reloadButton setEnabled:YES];
    } errorHandler:^(NSError * _Nonnull error) {
        [weakSelf.statusLabel setText:@"Error"];
        [weakSelf.reloadButton setEnabled:YES];
    }];
}

- (void)getText:(NSString *)text{
    [self.statusLabel setText:text];
    
}
@end



