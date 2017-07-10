//
//  QRCodeViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 21.11.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "QRCodeViewController.h"
#import <MTBBarcodeScanner.h>

@interface QRCodeViewController ()

@property (nonatomic, strong) MTBBarcodeScanner *scanner;
@property (nonatomic, copy) void (^scanningCompletion)(NSArray *codes);

@property (weak, nonatomic) IBOutlet UIView *cameraView;

- (IBAction)backButtonWasPressed:(id)sender;
@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    __weak typeof(self) weakSelf = self;
    self.scanningCompletion = ^(NSArray *codes) {
        
        [weakSelf.scanner stopScanning];
        
        AVMetadataMachineReadableCodeObject *code = codes.firstObject;
        
        if ([weakSelf.delegate respondsToSelector:@selector(didQRCodeScannedWithDict:)]) {
            [weakSelf.delegate didQRCodeScannedWithDict:[QRCodeManager getNewPaymentDictionaryFromString:code.stringValue]];
        }
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.scanner) {
        
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
        __weak typeof(self) weakSelf = self;
        [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
            if (success)
            {
                weakSelf.scanner.resultBlock = weakSelf.scanningCompletion;
                [weakSelf.scanner startScanning];
                
            } else
            {
                [weakSelf showCameraPermissionAlertWithTitle:@"Error" mesage:NSLocalizedString(@"Camera premission not found", "") andActions:nil];
            }
        }];
    }
}

- (IBAction)backButtonWasPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didBackPressed)]) {
        [self.delegate didBackPressed];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
@end
