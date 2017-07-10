//
//  OpenURLManager.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 05.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "OpenURLManager.h"
#import "NSUserDefaults+Settings.h"
#import "NSString+Extension.h"

@implementation OpenURLManager

-(void)launchFromUrl:(NSURL*)url {
    
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url
                                                resolvingAgainstBaseURL:NO];
    NSArray *queryItems = urlComponents.queryItems;
    
    NSString *address = [NSString valueForKey:@"adress" fromQueryItems:queryItems];
    NSString *amount = [NSString valueForKey:@"amount" fromQueryItems:queryItems];
    
    [[ApplicationCoordinator sharedInstance] startFromOpenURLWithAddress:address andAmount:amount];
}

-(void)storeAuthToYesWithAdddress:(NSString *)address {
    
    [NSUserDefaults saveWalletAddressKey:address];
    [NSUserDefaults saveIsHaveWalletKey:@"YES" ];
}

-(void)clear {
    
    [NSUserDefaults saveWalletAddressKey:nil];
    [NSUserDefaults saveIsHaveWalletKey:@"NO"];
}

@end
