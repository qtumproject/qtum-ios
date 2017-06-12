//
//  RestoreContractsViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 12.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "RestoreContractsViewController.h"
#import "CheckboxButton.h"

@interface RestoreContractsViewController () <CheckboxButtonDelegate>

@property (weak, nonatomic) IBOutlet UIButton *restoreButton;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIView *containerForButtons;

@property (nonatomic) BOOL haveFile;

@end

@implementation RestoreContractsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewForFile];
    [self createCheckButtons];
}

- (void)setupViewForFile {
    NSString *imageName = self.haveFile ? @"delete" : @"ic-attach";
    self.iconImageView.image = [UIImage imageNamed:imageName];
    self.restoreButton.hidden =
    self.sizeLabel.hidden = !self.haveFile;
    self.fileNameLabel.text = self.haveFile ? NSLocalizedString(@"Select back-up file", @"") : @"";
}

- (void)createCheckButtons {
    NSArray *titles = @[NSLocalizedString(@"Restore Contracts", @""), NSLocalizedString(@"Restore Tokens", @""), NSLocalizedString(@"Restore All", @"")];
    
    NSMutableArray *buttons = [NSMutableArray new];
    
    UIView *container = [[UIView alloc] init];
    container.backgroundColor = [UIColor clearColor];
    [self.containerForButtons addSubview:container];
    NSArray *constaintsForContrainer = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[container]-0-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{@"container" : container}];
    [self.containerForButtons addConstraints:constaintsForContrainer];
    
    
    for (NSInteger i = 0; i < titles.count; i++) {
        CheckboxButton *button = [[[NSBundle mainBundle] loadNibNamed:@"CheckButton" owner:self options:nil] firstObject];
        [button setTitle:titles[i]];
        button.delegate = self;
        [container addSubview:button];
        
        [buttons addObject:button];
        
        NSDictionary *views;
        NSArray *verticalConstraints;
        if (i == 0) {
            views = @{@"button" : button};
            verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[button(25)]" options:0 metrics:nil views:views];
        } else if (i != titles.count - 1) {
            views = @{@"button" : button, @"prevButton" : buttons[i - 1]};
            verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[prevButton]-32-[button(25)]" options:0 metrics:nil views:views];
        } else if (i == titles.count - 1) {
            views = @{@"button" : button, @"prevButton" : buttons[i - 1]};
            verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[prevButton]-32-[button(25)]-0-|" options:0 metrics:nil views:views];
        }
        
        NSArray *horisontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[button]-0-|" options:0 metrics:nil views:views];
    
        [container addConstraints:horisontalConstraints];
        [container addConstraints:verticalConstraints];
    }
}

#pragma mark - Actions

- (IBAction)actionRestore:(id)sender {
    
}

- (IBAction)actionBack:(id)sender {
    [self.delegate didPressedBack];
}

#pragma mark - CheckboxButtonDelegate

- (void)didStateChanged:(CheckboxButton *)sender {
    
}


@end
