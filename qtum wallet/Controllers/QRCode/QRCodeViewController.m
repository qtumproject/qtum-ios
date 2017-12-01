//
//  QRCodeViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 21.11.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "QRCodeViewController.h"
#import "SpinnerView.h"
#import <MTBBarcodeScanner.h>
#import "QRCodeManager.h"

@interface QRCodeViewController ()

@property (nonatomic, strong) MTBBarcodeScanner *scanner;
@property (nonatomic, copy) void (^scanningCompletion)(NSArray *codes);

@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet SpinnerView *spinnerView;

- (IBAction)backButtonWasPressed:(id) sender;
@end

@implementation QRCodeViewController

@synthesize delegate = _delegate;

- (void)viewDidLoad {
	[super viewDidLoad];


	__weak typeof (self) weakSelf = self;
	self.scanningCompletion = ^(NSArray *codes) {

		[weakSelf.scanner stopScanning];

		AVMetadataMachineReadableCodeObject *code = codes.firstObject;

		if ([weakSelf.delegate respondsToSelector:@selector (didQRCodeScannedWithSendInfoItem:)]) {
			[weakSelf.delegate didQRCodeScannedWithSendInfoItem:[QRCodeManager getNewPaymentDictionaryFromString:code.stringValue]];
		}
	};
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL) animated {
	[super viewDidAppear:animated];

	if (!self.scanner) {

		dispatch_after (dispatch_time (DISPATCH_TIME_NOW, (int64_t)(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"9.0") ? 0 : 3 * NSEC_PER_SEC)), dispatch_get_main_queue (), ^{
			self.scanner = [[MTBBarcodeScanner alloc] initWithMetadataObjectTypes:@[AVMetadataObjectTypeUPCECode,
							AVMetadataObjectTypeCode39Code,
							AVMetadataObjectTypeCode39Mod43Code,
							AVMetadataObjectTypeEAN13Code,
							AVMetadataObjectTypeEAN8Code,
							AVMetadataObjectTypeCode93Code,
							AVMetadataObjectTypeCode128Code,
							AVMetadataObjectTypePDF417Code,
							AVMetadataObjectTypeQRCode,
							AVMetadataObjectTypeAztecCode]
																	  previewView:self.cameraView];

			__weak typeof (self) weakSelf = self;
			self.scanner.didStartScanningBlock = ^{
				weakSelf.cameraView.alpha = 1.0f;
			};

			[MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
				if (success) {
					weakSelf.scanner.resultBlock = weakSelf.scanningCompletion;
					[weakSelf.scanner startScanning];

				} else {
					[weakSelf showCameraPermissionAlertWithTitle:@"Error" mesage:NSLocalizedString(@"Camera premission not found", "") andActions:nil];
				}
			}];
		});
	}
}

- (void)viewWillDisappear:(BOOL) animated {
	[super viewWillDisappear:animated];

	[self.scanner stopScanning];
	self.scanner = nil;
}

- (void)viewWillAppear:(BOOL) animated {
	[super viewWillAppear:animated];

	self.cameraView.alpha = 0.0f;
	[self.spinnerView startAnimating];
}

- (IBAction)backButtonWasPressed:(id) sender {
	if ([self.delegate respondsToSelector:@selector (didBackPressed)]) {
		[self.delegate didBackPressed];
	} else {
		[self.navigationController popToRootViewControllerAnimated:YES];
	}
}
@end
