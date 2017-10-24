//
//  OpenURLManager.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 05.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "OpenURLManager.h"
#import "NSUserDefaults+Settings.h"
#import "NSString+Extension.h"
#import "ServiceLocator.h"

@implementation OpenURLManager

-(void)launchFromUrl:(NSURL*)url {
    
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url
                                                resolvingAgainstBaseURL:NO];
    NSArray *queryItems = urlComponents.queryItems;
    
    NSString *address = [NSString valueForKey:@"address" fromQueryItems:queryItems];
    NSString *amount = [NSString valueForKey:@"amount" fromQueryItems:queryItems];
    
    [[ApplicationCoordinator sharedInstance] startFromOpenURLWithAddress:address andAmount:amount];
}

-(void)storeAuthToYesWithAdddress:(NSString *)address {
    
    [SLocator.dataOperation addGropFileWithName:groupFileName dataSource:@{@"isHaveWallet" : @"YES",
                                                                   @"address" : address}];
}

-(void)clear {
    
    [SLocator.dataOperation addGropFileWithName:groupFileName dataSource:@{@"isHaveWallet" : @"NO",
                                                               @"address" : [NSNull null]}];
}

@end
