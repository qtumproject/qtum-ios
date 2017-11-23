//
//  PopupFactory.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 23.11.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "PopupFactory.h"

@implementation PopupFactory


- (NoInternetConnectionPopUpViewController *)createNoInternetConnectionPopUpViewController {
    
    NSString *storyboard = @"NoInternetConnectionPopUp";
    NSString *identifire = [self identifireDependsOnStyleWithIdentifire:@"NoInternetConnectionPopUpViewController"];
    NoInternetConnectionPopUpViewController *controller = (NoInternetConnectionPopUpViewController *)[UIViewController controllerInStoryboard:storyboard withIdentifire:identifire];
    return controller;
}

- (PhotoLibraryPopUpViewController *)createPhotoLibraryPopUpViewController {
    
    NSString *storyboard = @"PhotoLibraryPopUp";
    NSString *identifire = [self identifireDependsOnStyleWithIdentifire:@"PhotoLibraryPopUpViewController"];
    PhotoLibraryPopUpViewController *controller = (PhotoLibraryPopUpViewController *)[UIViewController controllerInStoryboard:storyboard withIdentifire:identifire];
    return controller;
}

- (ErrorPopUpViewController *)createErrorPopUpViewController {
    
    NSString *storyboard = @"ErrorPopUp";
    NSString *identifire = [self identifireDependsOnStyleWithIdentifire:@"ErrorPopUpViewController"];
    ErrorPopUpViewController *controller = (ErrorPopUpViewController *)[UIViewController controllerInStoryboard:storyboard withIdentifire:identifire];
    return controller;
}

- (InformationPopUpViewController *)createInformationPopUpViewController {
    
    NSString *storyboard = @"InformationPopUp";
    NSString *identifire = [self identifireDependsOnStyleWithIdentifire:@"InformationPopUpViewController"];
    InformationPopUpViewController *controller = (InformationPopUpViewController *)[UIViewController controllerInStoryboard:storyboard withIdentifire:identifire];
    return controller;
}

- (ConfirmPopUpViewController *)createConfirmPopUpViewController {
    
    NSString *storyboard = @"ConfirmPopUp";
    NSString *identifire = [self identifireDependsOnStyleWithIdentifire:@"ConfirmPopUpViewController"];
    ConfirmPopUpViewController *controller = (ConfirmPopUpViewController *)[UIViewController controllerInStoryboard:storyboard withIdentifire:identifire];
    return controller;
}

- (LoaderPopUpViewController *)createLoaderViewController {
    
    NSString *storyboard = @"LoaderPopUp";
    NSString *identifire = [self identifireDependsOnStyleWithIdentifire:@"LoaderPopUpViewController"];
    LoaderPopUpViewController *controller = (LoaderPopUpViewController *)[UIViewController controllerInStoryboard:storyboard withIdentifire:identifire];
    return controller;
}

- (RestoreContractsPopUpViewController *)createRestoreContractsPopUpViewController {
    
    NSString *storyboard = @"RestoreContractsPopUp";
    NSString *identifire = [self identifireDependsOnStyleWithIdentifire:@"RestoreContractsPopUpViewController"];
    RestoreContractsPopUpViewController *controller = (RestoreContractsPopUpViewController *)[UIViewController controllerInStoryboard:storyboard withIdentifire:identifire];
    return controller;
}

- (SourceCodePopUpViewController *)createSourceCodePopUpViewController {
    
    NSString *storyboard = @"SourceCodePopUp";
    NSString *identifire = [self identifireDependsOnStyleWithIdentifire:@"SourceCodePopUpViewController"];
    SourceCodePopUpViewController *controller = (SourceCodePopUpViewController *)[UIViewController controllerInStoryboard:storyboard withIdentifire:identifire];
    return controller;
}

- (SecurityPopupViewController *)createSecurityPopupViewController {
    
    NSString *storyboard = @"SecurityPopup";
    NSString *identifire = [self identifireDependsOnStyleWithIdentifire:@"SecurityPopupViewController"];
    SecurityPopupViewController *controller = (SecurityPopupViewController *)[UIViewController controllerInStoryboard:storyboard withIdentifire:identifire];
    return controller;
}

- (AddressTransferPopupViewController *)createAddressTransferPopupViewController {
    
    NSString *storyboard = @"AddressTransferPopup";
    NSString *identifire = [self identifireDependsOnStyleWithIdentifire:@"AddressTransferPopupViewController"];
    AddressTransferPopupViewController *controller = (AddressTransferPopupViewController *)[UIViewController controllerInStoryboard:storyboard withIdentifire:identifire];
    return controller;
}


- (ConfirmPurchasePopUpViewController *)createConfirmPurchasePopUpViewController {
    
    NSString *storyboard = @"ConfirmPurchasePopUp";
    NSString *identifire = [self identifireDependsOnStyleWithIdentifire:@"ConfirmPurchasePopUpViewController"];
    ConfirmPurchasePopUpViewController *controller = (ConfirmPurchasePopUpViewController *)[UIViewController controllerInStoryboard:storyboard withIdentifire:identifire];
    return controller;
}

- (ShareTokenPopUpViewController *)createShareTokenPopUpViewController {
    
    NSString *storuboard = @"ShareTokenPopUp";
    NSString *identifire = [self identifireDependsOnStyleWithIdentifire:@"ShareTokenPopUpViewController"];
    ShareTokenPopUpViewController *controller = (ShareTokenPopUpViewController *)[UIViewController controllerInStoryboard:storuboard withIdentifire:identifire];
    return controller;
}

@end
