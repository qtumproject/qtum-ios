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
<<<<<<< HEAD
    // Override point for customization after application launch.
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSString *rootVCkey;
    if ([KeysManager sharedInstance].keys.count != 0) {
        rootVCkey = @"MainViewController";
    }else{
        rootVCkey = @"StartViewController";
    }
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:rootVCkey];
    self.window.rootViewController = vc;
    
    [[SVProgressHUD appearance] setDefaultStyle:SVProgressHUDStyleCustom];
    [[SVProgressHUD appearance] setForegroundColor:[UIColor colorWithRed:104/255.0f green:195/255.0f blue:207/255.0f alpha:1.0f]];
    [[SVProgressHUD appearance] setBackgroundColor:[UIColor whiteColor]];
    [[SVProgressHUD appearance] setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [[SVProgressHUD appearance] setMinimumDismissTimeInterval:1];
    
    
    // TEST 1 create mnemonic
    NSString *password = @"1234";
    NSArray *array = @[@"abandon", @"ability", @"able", @"abortion", @"about", @"aggressive", @"consultant", @"consumption", @"custom", @"depression", @"destroy", @"furniture"];
    BTCMnemonic *mnemonic1 = [[BTCMnemonic alloc] initWithWords:array password:password wordListType:BTCMnemonicWordListTypeUnknown];
    NSLog(@"%@", mnemonic1.seed);
    BTCMnemonic *mnemonic2 = [[BTCMnemonic alloc] initWithWords:array password:password wordListType:BTCMnemonicWordListTypeUnknown];
    NSLog(@"%@", mnemonic2.seed);
    
    //TEST 2 create keychain
    BTCKeychain *keychain1 = [[BTCKeychain alloc] initWithSeed:mnemonic1.seed];
    
    for (NSInteger i = 0; i < 6; i++) {
        BTCKey *key = [keychain1 keyAtIndex:(unsigned)i];
        NSLog(@"Keychain 1 WIF %ld: %@", (long)i, key.WIF);
    }
    
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


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
=======
>>>>>>> f6fefab908c611f913eb7f616cdd5bbc84cb1121

    [[ApplicationCoordinator sharedInstance] start];
    return YES;
}



@end
