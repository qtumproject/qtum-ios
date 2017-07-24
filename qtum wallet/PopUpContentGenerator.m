//
//  PopUpContentGenerator.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 03.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "PopUpContentGenerator.h"
#import "PopUpContent.h"

@implementation PopUpContentGenerator

+ (PopUpContent *)contentForOupsPopUp{
    PopUpContent *content = [[PopUpContent alloc] initWithTitle:NSLocalizedString(@"Oops", nil) message:NSLocalizedString(@"Something went wrong", nil) okTitle:NSLocalizedString(@"OK", nil) cancelTitle:NSLocalizedString(@"TRY AGAIN", nil)];
    return content;
}

+ (PopUpContent *)contentForPhotoLibrary{
    PopUpContent *content = [[PopUpContent alloc] initWithTitle:NSLocalizedString(@"QTUM App would like to access your photos", nil) message:nil okTitle:NSLocalizedString(@"OK", nil) cancelTitle:NSLocalizedString(@"TRY AGAIN", nil)];
    return content;
}

+ (PopUpContent *)contentForUpdateBalance{
    PopUpContent *content = [[PopUpContent alloc] initWithTitle:NSLocalizedString(@"Your balance was updated", nil) message:nil okTitle:NSLocalizedString(@"OK", nil) cancelTitle:nil];
    return content;
}

+ (PopUpContent *)contentForCreateContract{
    PopUpContent *content = [[PopUpContent alloc] initWithTitle:NSLocalizedString(@"Contract created successfully", nil) message:nil okTitle:NSLocalizedString(@"OK", nil) cancelTitle:nil];
    return content;
}

+ (PopUpContent *)contentForSend{
    PopUpContent *content = [[PopUpContent alloc] initWithTitle:NSLocalizedString(@"Payment completed successfully", nil) message:nil okTitle:NSLocalizedString(@"OK", nil) cancelTitle:nil];
    return content;
}

+ (PopUpContent *)contentForCompletedBackupFile{
    PopUpContent *content = [[PopUpContent alloc] initWithTitle:NSLocalizedString(@"File saved successfully", nil) message:nil okTitle:NSLocalizedString(@"OK", nil) cancelTitle:nil];
    return content;
}

+ (PopUpContent *)contentForBrainCodeCopied{
    PopUpContent *content = [[PopUpContent alloc] initWithTitle:NSLocalizedString(@"Passphrase copied", nil) message:nil okTitle:NSLocalizedString(@"OK", nil) cancelTitle:nil];
    return content;
}

+ (PopUpContent *)contentForAddressCopied{
    PopUpContent *content = [[PopUpContent alloc] initWithTitle:NSLocalizedString(@"Address copied", nil) message:nil okTitle:NSLocalizedString(@"OK", nil) cancelTitle:nil];
    return content;
}

+ (PopUpContent *)contentForAbiCopied{
    PopUpContent *content = [[PopUpContent alloc] initWithTitle:NSLocalizedString(@"ABI copied", nil) message:nil okTitle:NSLocalizedString(@"OK", nil) cancelTitle:nil];
    return content;
}

+ (PopUpContent *)contentForTokenAdded{
    PopUpContent *content = [[PopUpContent alloc] initWithTitle:NSLocalizedString(@"Token was added to your wallet", nil) message:nil okTitle:NSLocalizedString(@"OK", nil) cancelTitle:nil];
    return content;
}

+ (PopUpContent *)contentForContractAdded{
    PopUpContent *content = [[PopUpContent alloc] initWithTitle:NSLocalizedString(@"Contract was added to your wallet", nil) message:nil okTitle:NSLocalizedString(@"OK", nil) cancelTitle:nil];
    return content;
}

+ (PopUpContent *)contentForSourceCode{
    PopUpContent *content = [[PopUpContent alloc] initWithTitle:NSLocalizedString(@"Source Code", nil) message:nil okTitle:NSLocalizedString(@"Copy", nil) cancelTitle:nil];
    return content;
}

+ (PopUpContent *)contentForRequestTokenPopUp{
    PopUpContent *content = [[PopUpContent alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Requested Token not found", nil) okTitle:NSLocalizedString(@"OK", nil) cancelTitle:NSLocalizedString(@"TRY AGAIN", nil)];
    return content;
}

+ (PopUpContent *)contentForInvalidQRCodeFormatPopUp{
    PopUpContent *content = [[PopUpContent alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Invalid QR Code format", nil) okTitle:NSLocalizedString(@"OK", nil) cancelTitle:NSLocalizedString(@"TRY AGAIN", nil)];
    return content;
}

@end
