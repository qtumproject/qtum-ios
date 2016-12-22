//
//  AppDelegate.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 29.10.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "AppDelegate.h"
#import "ApplicationCoordinator.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[ApplicationCoordinator sharedInstance] start];
    
    // TEST 1 create mnemonic
    NSString *password = @"1234";
    NSArray *array = @[@"abandon", @"ability", @"able", @"abortion", @"about", @"aggressive", @"consultant", @"consumption", @"custom", @"depression", @"destroy", @"furniture"];
    BTCMnemonic *mnemonic1 = [[BTCMnemonic alloc] initWithWords:array password:password wordListType:BTCMnemonicWordListTypeUnknown];
    NSLog(@"%@", mnemonic1.seed);
    BTCMnemonic *mnemonic2 = [[BTCMnemonic alloc] initWithWords:array password:password wordListType:BTCMnemonicWordListTypeUnknown];
    NSLog(@"%@", mnemonic2.seed);
    
    //TEST 2 create keychain
    BTCKeychain *keychain1 = [[BTCKeychain alloc] initWithSeed:mnemonic1.seed];
    

    for (NSInteger i = 0; i < 101; i++) {
        BTCKey *key = [keychain1 keyAtIndex:(unsigned)i];
        NSLog(@"Keychain 1 WIF %ld: %@", (long)i, key.WIF);
    }

    
    /*
    BTCKeychain *keychain2 = [[BTCKeychain alloc] initWithSeed:mnemonic2.seed];
    
    for (NSInteger i = 0; i < 6; i++) {
        BTCKey *key = [keychain2 keyAtIndex:(unsigned)i];
        NSLog(@"Keychain 2 WIF %ld: %@", (long)i, key.WIF);
    }
    
    
    for (NSInteger i = 0; i < 6; i++) {
        BTCKey *key = [mnemonic2.keychain keyAtIndex:(unsigned)i];
        NSLog(@"Keychain 3 WIF %ld: %@", (long)i, key.WIF);
    }

    
    // TEST 3 random words
    for (NSInteger i = 0; i < 10; i++) {
        NSLog(@"ARRAY %ld : %@", (long)i , [self getRandomWordsFromWordsArray:12]);
    }
    */
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
