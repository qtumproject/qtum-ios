//
//  TokenAddressLibraryCoordinator.m
//  qtum wallet
//
//  Created by Никита Федоренко on 03.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "TokenAddressLibraryCoordinator.h"
#import "TokenAddressLibraryOutput.h"

@interface TokenAddressLibraryCoordinator () <TokenAddressLibraryOutputDelegate>

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, weak) NSObject <TokenAddressLibraryOutput> *addressOutput;
@property (nonatomic, copy) NSDictionary <NSString*, BTCKey*> *addressKeyHashTable;

@end

@implementation TokenAddressLibraryCoordinator

-(instancetype)initWithNavigationViewController:(UINavigationController*)navigationController {
    
    self = [super init];
    if (self) {
        
        _navigationController = navigationController;
    }
    return self;
}

-(void)start {
    
    NSObject <TokenAddressLibraryOutput> *output = [[ControllersFactory sharedInstance] createTokenAddressControllOutput];
    output.delegate = self;
    self.addressOutput = output;
    [self.navigationController pushViewController:[output toPresent] animated:YES];
}

#pragma mark - TokenAddressLibraryOutputDelegate

-(void)didBackPress {
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate coordinatorLibraryDidEnd:self];
}

-(void)didPressCellAtIndexPath:(NSIndexPath*) indexPath withAddress:(NSString*)address {
    
}

@end
