//
//  AppDelegate.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 29.10.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "AppDelegate.h"
#import "ApplicationCoordinator.h"
#import "RPCRequestManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[ApplicationCoordinator sharedInstance] start];
    
    // Send money for our wallet
    if ([[WalletManager sharedInstance] haveWallets]) {
        [[RPCRequestManager sharedInstance] sendToAddress:[[[WalletManager sharedInstance] getCurrentWallet] getRandomKey].address.string withSuccessHandler:^(id responseObject) {
            NSLog(@"yes");
        } andFailureHandler:^(NSError *error, NSString *message) {
            NSLog(@"no");
        }];
    }
    
    return YES;
}

- (NSArray *)getRandomWordsFromWordsArray:(NSInteger)count
{
    NSMutableArray *randomWords = [NSMutableArray new];
    
    NSInteger i = 0;
    
    while (i < count) {
        uint32_t rnd = arc4random_uniform((uint32_t)wordsArray().count);
        NSString *randomWord = [wordsArray() objectAtIndex:rnd];
        
        if (![randomWords containsObject:randomWord]) {
            [randomWords addObject:randomWord];
            i++;
        }
    }
    
    return randomWords;
}



@end
