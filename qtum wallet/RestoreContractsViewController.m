//
//  RestoreContractsViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 12.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "RestoreContractsViewController.h"
#import "CheckboxButton.h"
#import "RestoreContractsPopUpViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "BackupFileManager.h"
#import "ErrorPopUpViewController.h"


@interface RestoreContractsViewController () <CheckboxButtonDelegate, PopUpWithTwoButtonsViewControllerDelegate, UIDocumentMenuDelegate, UIDocumentPickerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *restoreButton;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIView *containerForButtons;
@property (weak, nonatomic) IBOutlet UIView *fileView;

@property (strong, nonatomic) NSMutableArray <CheckboxButton*> *buttons;

@property (assign, nonatomic) BOOL haveFile;
@property (strong, nonatomic) NSURL *fileUrl;

@end

@implementation RestoreContractsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewForFile];
    [self createCheckButtons];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionSelectFile)];
    [self.fileView addGestureRecognizer:recognizer];
}

- (void)setupViewForFile {
    NSString *imageName = self.haveFile ? @"delete" : @"ic-attach";
    self.iconImageView.image = [UIImage imageNamed:imageName];
    self.sizeLabel.hidden = !self.haveFile;
    self.fileNameLabel.text = self.haveFile ? [self.fileUrl lastPathComponent] : NSLocalizedString(@"Select back-up file", @"");
}

- (void)createCheckButtons {
    NSArray *titles = @[NSLocalizedString(@"Restore Templates", @""), NSLocalizedString(@"Restore Contracts", @""), NSLocalizedString(@"Restore Tokens", @""), NSLocalizedString(@"Restore All", @"")];
    
    NSMutableArray *buttons = [NSMutableArray new];
    self.buttons = buttons;
    
    UIView *container = [[UIView alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    container.backgroundColor = [UIColor clearColor];
    [self.containerForButtons addSubview:container];
    NSArray *constaintsForContrainer = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[container]-0-|" options:0 metrics:nil views:@{@"container" : container}];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:container attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.containerForButtons attribute:NSLayoutAttributeCenterY multiplier:1 constant:0.0f];
    [self.containerForButtons addConstraints:constaintsForContrainer];
    [self.containerForButtons addConstraint:centerY];
    
    
    for (NSInteger i = 0; i < titles.count; i++) {
        CheckboxButton *button = [[[NSBundle mainBundle] loadNibNamed:@"CheckButton" owner:self options:nil] firstObject];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button setTitle:titles[i]];
        button.delegate = self;
        [container addSubview:button];
        
        [buttons addObject:button];
        
        NSDictionary *metrics = @{@"height" : @(40.0f), @"offset" : @(10.0f)};
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

#pragma mark - Private Methods 

-(BackupOption)checkRestoreButtonsStateForRestore {
    
    BackupOption option = (Tokens | Templates | Contracts);
    for (int i = 0; i < self.buttons.count; i++) {
        if (!self.buttons[i].isChecked) {
            switch (i) {
                case 0:
                    option &= ~Templates;
                    break;
                case 1:
                    option &= ~Contracts;
                    break;
                case 2:
                    option &= ~Tokens;
                    break;
                    
                default:
                    break;
            }
        }
    }
        
    return option;
}

-(void)clearControls {
    
    self.haveFile = NO;
    self.fileUrl = nil;
    self.sizeLabel.text = @"";
    [self setupViewForFile];
    [self setCheckForAllButtons:NO];
}

#pragma mark - Actions

- (void)actionSelectFile {
    
    if (self.haveFile) {
        self.haveFile = NO;
        self.fileUrl = nil;
        self.sizeLabel.text = @"";
        [self setupViewForFile];
        return;
    }
    
    NSArray *types = @[(NSString*)kUTTypeJSON,(NSString*)kUTTypeFolder,(NSString*)kUTTypeZipArchive];
    UIDocumentMenuViewController *vc = [[UIDocumentMenuViewController alloc] initWithDocumentTypes:types inMode:UIDocumentPickerModeImport];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)actionRestore:(id)sender {
    
    if (self.fileUrl) {
        
        [BackupFileManager getQuickInfoFileWithUrl:self.fileUrl andOption:[self checkRestoreButtonsStateForRestore] andCompletession:^(NSString *date, NSString *version, NSInteger contractCount, NSInteger templateCount, NSInteger tokenCount) {
            RestoreContractsPopUpViewController *poUp = [[PopUpsManager sharedInstance] showRestoreContractsPopUp:self presenter:nil completion:nil];
            poUp.dateLabel.text = date;
            poUp.versionLabel.text = version;
            poUp.tokensCountLabel.text = [NSString stringWithFormat:@"%li",(long)tokenCount];
            poUp.contractsCountLabel.text = [NSString stringWithFormat:@"%li",(long)contractCount];
            poUp.templateCounLabel.text = [NSString stringWithFormat:@"%li",(long)templateCount];
        }];
        
    }
}

- (IBAction)actionBack:(id)sender {
    [self.delegate didPressedBack];
}

#pragma mark - CheckboxButtonDelegate and buttons Logic

- (void)didStateChanged:(CheckboxButton *)sender {
    
    if (self.buttons.count - 1 == [self.buttons indexOfObject:sender]) {
        [self setCheckForAllButtons:[sender isChecked]];
    }else{
        [self checkAllSelectedAndChangeLastButton];
    }
}

- (void)checkAllSelectedAndChangeLastButton {
    
    BOOL allSelected = YES;
    for (NSInteger i = 0; i < self.buttons.count - 1; i++) {
        
        CheckboxButton *button = self.buttons[i];
        
        if (![button isChecked]) {
            allSelected = NO;
        }
    }
    CheckboxButton *lastButton = [self.buttons lastObject];
    [lastButton setCheck:allSelected];
}

- (void)setCheckForAllButtons:(BOOL)value {
    
    for (CheckboxButton *button in self.buttons) {
        [button setCheck:value];
    }
}

#pragma mark - PopUpWithTwoButtonsViewControllerDelegate

- (void)okButtonPressed:(PopUpViewController *)sender {

    if ([sender isKindOfClass:[ErrorPopUpViewController class]]) {
        
        [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
        
    } else {
        [BackupFileManager setBackupFileWithUrl:self.fileUrl andOption:[self checkRestoreButtonsStateForRestore] andCompletession:^(BOOL success) {
            if (success) {
                [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
            } else {
                [[PopUpsManager sharedInstance] showErrorPopUp:self withContent:[PopUpContentGenerator contentForOupsPopUp] presenter:nil completion:nil];
            }
        }];
    }
    [self clearControls];
}

- (void)cancelButtonPressed:(PopUpViewController *)sender {
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
}

#pragma mark - UIDocumentMenuDelegate, UIDocumentPickerDelegate

- (void)documentMenu:(UIDocumentMenuViewController *)documentMenu didPickDocumentPicker:(UIDocumentPickerViewController *)documentPicker {
    documentPicker.delegate = self;
    [self presentViewController:documentPicker animated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    
    self.fileUrl = url;
    NSData *fileData = [NSData dataWithContentsOfURL:url];
    NSString *fileSizeString = [NSByteCountFormatter stringFromByteCount:fileData.length countStyle:NSByteCountFormatterCountStyleFile];
    self.sizeLabel.text = fileSizeString;
    self.haveFile = YES;
    
    [self setupViewForFile];
}

@end
