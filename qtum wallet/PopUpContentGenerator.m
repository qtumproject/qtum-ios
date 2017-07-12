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
    PopUpContent *content = [[PopUpContent alloc] initWithTitle:@"Oops" message:@"Something went wrong" okTitle:@"OK" cancelTitle:@"TRY AGAIN"];
    return content;
}

+ (PopUpContent *)contentForPhotoLibrary{
    PopUpContent *content = [[PopUpContent alloc] initWithTitle:@"QTUM App would like to access your photos" message:nil okTitle:@"OK" cancelTitle:@"DON'T ALLOW"];
    return content;
}

+ (PopUpContent *)contentForUpdateBalance{
    PopUpContent *content = [[PopUpContent alloc] initWithTitle:@"Your balance was updated" message:nil okTitle:@"OK" cancelTitle:nil];
    return content;
}

+ (PopUpContent *)contentForCreateContract{
    PopUpContent *content = [[PopUpContent alloc] initWithTitle:@"Contract created successfully" message:nil okTitle:@"OK" cancelTitle:nil];
    return content;
}

+ (PopUpContent *)contentForSend{
    PopUpContent *content = [[PopUpContent alloc] initWithTitle:@"Payment completed successfully" message:nil okTitle:@"OK" cancelTitle:nil];
    return content;
}

+ (PopUpContent *)contentForCompletedBackupFile{
    PopUpContent *content = [[PopUpContent alloc] initWithTitle:@"File saved successfully" message:nil okTitle:@"OK" cancelTitle:nil];
    return content;
}

+ (PopUpContent *)contentForBrainCodeCopied{
    PopUpContent *content = [[PopUpContent alloc] initWithTitle:NSLocalizedString(@"Passphrase copied", "") message:nil okTitle:NSLocalizedString(@"OK", "") cancelTitle:nil];
    return content;
}

+ (PopUpContent *)contentForAddressCopied{
    PopUpContent *content = [[PopUpContent alloc] initWithTitle:NSLocalizedString(@"Address copied", "") message:nil okTitle:NSLocalizedString(@"OK", "") cancelTitle:nil];
    return content;
}

+ (PopUpContent *)contentForSourceCode{
    PopUpContent *content = [[PopUpContent alloc] initWithTitle:NSLocalizedString(@"Source Code", "") message:nil okTitle:NSLocalizedString(@"Copy", "") cancelTitle:nil];
    return content;
}

@end
