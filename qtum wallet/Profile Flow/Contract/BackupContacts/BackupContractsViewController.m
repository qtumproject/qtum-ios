//
//  BackupContractsViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 13.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "BackupContractsViewController.h"

@interface BackupContractsViewController () <UIDocumentMenuDelegate, UIDocumentPickerDelegate, PopUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileSizeLabel;
@property (weak, nonatomic) IBOutlet UIView *loaderView;
@property (assign, nonatomic) BOOL isBackupCreated;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;

@property (nonatomic) NSString *filePath;

@end

@implementation BackupContractsViewController

@synthesize delegate;

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];

	self.centerView.alpha = 0.0f;

    [self addTapRecognizer];
    [self bindToNotifications];
}

- (void)viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    
    __weak __typeof (self) weakSelf = self;
    if (!self.isBackupCreated) {
        [SLocator.backupFileManager getBackupFile:^(NSDictionary *file, NSString *path, NSInteger size) {
            
            [weakSelf fileWasCreatedWithURL:path andSize:size];
            weakSelf.isBackupCreated = YES;
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addTapRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector (actionUpload)];
    [self.centerView addGestureRecognizer:tap];
}

-(void)bindToNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disappearToBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

-(void)disappearToBackground {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Configuration

-(void)configLocalization {
    
    self.fileNameLabel.text = NSLocalizedString(@"Tap to save the file", @"");
    self.titleTextLabel.text = NSLocalizedString(@"Backup Contracts", @"Backup Contracts Controllers Title");
}

#pragma mark - Actions

- (IBAction)actionBack:(id) sender {
	[self.delegate didPressedBack];
}

- (void)actionUpload {
	UIDocumentMenuViewController *vc = [[UIDocumentMenuViewController alloc] initWithURL:[NSURL fileURLWithPath:self.filePath] inMode:UIDocumentPickerModeExportToService];
	vc.delegate = self;
	[self presentViewController:vc animated:YES completion:nil];
}

- (void)fileWasCreatedWithURL:(NSString *) path andSize:(NSUInteger) size {

	self.filePath = path;
	NSString *fileSizeString = [NSByteCountFormatter stringFromByteCount:size countStyle:NSByteCountFormatterCountStyleFile];
	self.fileSizeLabel.text = fileSizeString;

	[UIView animateWithDuration:0.3f animations:^{
		self.centerView.alpha = 1.0f;
		self.loaderView.alpha = 0.0f;
	}];
}

#pragma mark - UIDocumentMenuDelegate, UIDocumentPickerDelegate

- (void)documentMenu:(UIDocumentMenuViewController *) documentMenu didPickDocumentPicker:(UIDocumentPickerViewController *) documentPicker {
	documentPicker.delegate = self;
	[self presentViewController:documentPicker animated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *) controller didPickDocumentAtURL:(NSURL *) url {

	[SLocator.popupService showInformationPopUp:self withContent:[PopUpContentGenerator contentForCompletedBackupFile] presenter:nil completion:nil];
}

#pragma mark - PopUpViewControllerDelegate

- (void)okButtonPressed:(PopUpViewController *) sender {
	[SLocator.popupService hideCurrentPopUp:YES completion:^{
		[self.delegate didPressedBack];
	}];
}

@end
