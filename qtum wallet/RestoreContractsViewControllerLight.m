//
//  RestoreContractsViewControllerLight.m
//  qtum wallet
//
//  Created by Никита Федоренко on 31.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "RestoreContractsViewControllerLight.h"

@interface RestoreContractsViewControllerLight ()

@end

@implementation RestoreContractsViewControllerLight

- (void)createCheckButtons {
    
    NSArray *titles = @[NSLocalizedString(@"Restore Templates", @""), NSLocalizedString(@"Restore Contracts", @""), NSLocalizedString(@"Restore Tokens", @""), NSLocalizedString(@"Restore All", @"")];
    
    NSMutableArray *buttons = [NSMutableArray new];
    self.buttons = buttons;
    
    UIView *container = [[UIView alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    container.backgroundColor = [UIColor clearColor];
    [self.containerForButtons addSubview:container];
    NSArray *constaintsForContrainer = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[container]-0-|" options:0 metrics:nil views:@{@"container" : container}];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:container attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.containerForButtons attribute:NSLayoutAttributeTop multiplier:1 constant:0.0f];
    [self.containerForButtons addConstraints:constaintsForContrainer];
    [self.containerForButtons addConstraint:centerY];
    
    
    for (NSInteger i = 0; i < titles.count; i++) {
        
        CheckboxButton *button = [[[NSBundle mainBundle] loadNibNamed:@"CheckButtonLight" owner:self options:nil] firstObject];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button setTitle:titles[i]];
        button.delegate = self;
        [container addSubview:button];
        
        [buttons addObject:button];
        
        NSDictionary *metrics = @{@"height" : @(40.0f), @"offset" : @(0.0f)};
        NSDictionary *views;
        NSArray *verticalConstraints;
        if (i == 0) {
            views = @{@"button" : button};
            verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[button(height)]" options:0 metrics:metrics views:views];
        } else if (i != titles.count - 1) {
            views = @{@"button" : button, @"prevButton" : buttons[i - 1]};
            verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[prevButton]-offset-[button(height)]" options:0 metrics:metrics views:views];
        } else if (i == titles.count - 1) {
            views = @{@"button" : button, @"prevButton" : buttons[i - 1]};
            verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[prevButton]-offset-[button(height)]-0-|" options:0 metrics:metrics views:views];
        }
        
        NSArray *horisontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[button]-0-|" options:0 metrics:nil views:views];
        
        [container addConstraints:horisontalConstraints];
        [container addConstraints:verticalConstraints];
    }
}

@end
