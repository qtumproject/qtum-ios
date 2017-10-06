//
//  WalletManagerTests.m
//  qtum walletTests
//
//  Created by Vladimir Sharaev on 03.10.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WalletManager.h"

@interface WalletManagerTests : XCTestCase

@end

@implementation WalletManagerTests

- (void)test_Wallet_Creation {
    NSArray *worlds = @[@"contributor", @"lately", @"classroom", @"super", @"sphere", @"turn", @"confuse", @"leading", @"ease", @"brother", @"march", @"heavy"];
    
    // good flow
    
    WalletManager *walletManager = [WalletManager new];
    [walletManager createNewWalletWithName:@"name" pin:@"1111" seedWords:worlds withSuccessHandler:^(Wallet *newWallet) {
        XCTAssertTrue(newWallet);
    } andFailureHandler:^{
        XCTAssertTrue(NO);
    }];
    
    // words nil flow
    
    WalletManager *walletManager2 = [WalletManager new];
    [walletManager2 createNewWalletWithName:@"name" pin:@"1111" seedWords:nil withSuccessHandler:^(Wallet *newWallet) {
        XCTAssertTrue(NO);
    } andFailureHandler:^{
        XCTAssertTrue(YES);
    }];
    
    // 10 words flow
    
//    NSArray *worlds3 = @[@"contributor", @"lately", @"classroom", @"super", @"sphere", @"turn", @"confuse", @"leading", @"ease", @"brother"];
//    WalletManager *walletManager3 = [WalletManager new];
//    [walletManager3 createNewWalletWithName:@"name" pin:@"1111" seedWords:worlds3 withSuccessHandler:^(Wallet *newWallet) {
//        XCTAssertTrue(NO);
//    } andFailureHandler:^{
//        XCTAssertTrue(YES);
//    }];
    
    // pass nil flow
    
    WalletManager *walletManager4 = [WalletManager new];
    [walletManager4 createNewWalletWithName:@"name" pin:nil seedWords:worlds withSuccessHandler:^(Wallet *newWallet) {
        XCTAssertTrue(NO);
    } andFailureHandler:^{
        XCTAssertTrue(YES);
    }];
    
    // name nil flow
    
    WalletManager *walletManager5 = [WalletManager new];
    [walletManager5 createNewWalletWithName:nil pin:@"1111" seedWords:worlds withSuccessHandler:^(Wallet *newWallet) {
        XCTAssertTrue(YES);
    } andFailureHandler:^{
        XCTAssertTrue(NO);
    }];
}

- (void)test_Clear {
    NSArray *worlds = @[@"contributor", @"lately", @"classroom", @"super", @"sphere", @"turn", @"confuse", @"leading", @"ease", @"brother", @"march", @"heavy"];
    
    WalletManager *walletManager = [WalletManager new];
    [walletManager createNewWalletWithName:@"name" pin:@"1111" seedWords:worlds withSuccessHandler:^(Wallet *newWallet) {
        XCTAssertTrue(newWallet);
        
        [walletManager clear];
        
        XCTAssertNil(walletManager.wallet);
        
    } andFailureHandler:^{
        XCTAssertTrue(NO);
    }];
}

- (void)test_Pin_Change {
    NSArray *worlds = @[@"contributor", @"lately", @"classroom", @"super", @"sphere", @"turn", @"confuse", @"leading", @"ease", @"brother", @"march", @"heavy"];
    NSString *pin = @"1111";
    NSString *newPin = @"2222";
    NSString *nilPin = nil;
    
    WalletManager *walletManager = [WalletManager new];
    [walletManager createNewWalletWithName:@"name" pin:pin seedWords:worlds withSuccessHandler:^(Wallet *newWallet) {
        BOOL goodChange = [walletManager changePinFrom:pin toPin:newPin];
        XCTAssertTrue(goodChange == YES);
    } andFailureHandler:^{
        XCTAssertTrue(NO);
    }];
    
    [walletManager createNewWalletWithName:@"name" pin:pin seedWords:worlds withSuccessHandler:^(Wallet *newWallet) {
        BOOL badChange = [walletManager changePinFrom:newPin toPin:newPin];
        XCTAssertTrue(badChange == NO);
    } andFailureHandler:^{
        XCTAssertTrue(NO);
    }];
    
    [walletManager createNewWalletWithName:@"name" pin:pin seedWords:worlds withSuccessHandler:^(Wallet *newWallet) {
        BOOL nilChange = [walletManager changePinFrom:pin toPin:nilPin];
        XCTAssertTrue(nilChange == NO);
    } andFailureHandler:^{
        XCTAssertTrue(NO);
    }];
    
    [walletManager createNewWalletWithName:@"name" pin:pin seedWords:worlds withSuccessHandler:^(Wallet *newWallet) {
        BOOL doubleNilChange = [walletManager changePinFrom:nilPin toPin:nilPin];
        XCTAssertTrue(doubleNilChange == NO);
    } andFailureHandler:^{
        XCTAssertTrue(NO);
    }];
}

- (void)test_Pin_Verify {
    NSArray *worlds = @[@"contributor", @"lately", @"classroom", @"super", @"sphere", @"turn", @"confuse", @"leading", @"ease", @"brother", @"march", @"heavy"];
    NSString *pin = @"1111";
    NSString *newPin = @"2222";
    NSString *nilPin = nil;
    
    WalletManager *walletManager = [WalletManager new];
    [walletManager createNewWalletWithName:@"name" pin:pin seedWords:worlds withSuccessHandler:^(Wallet *newWallet) {
        [walletManager storePin:pin];
        
        BOOL goodVerify = [walletManager verifyPin:pin];
        XCTAssertTrue(goodVerify == YES);
        
        BOOL badVerify = [walletManager verifyPin:newPin];
        XCTAssertTrue(badVerify == NO);
        
        BOOL nilVerify = [walletManager verifyPin:nilPin];
        XCTAssertTrue(nilVerify == NO);
    } andFailureHandler:^{
        XCTAssertTrue(NO);
    }];
}

- (void)test_Signed_In {
    NSArray *worlds = @[@"contributor", @"lately", @"classroom", @"super", @"sphere", @"turn", @"confuse", @"leading", @"ease", @"brother", @"march", @"heavy"];
    NSString *pin = @"1111";
    
    WalletManager *walletManager = [WalletManager new];
    [walletManager createNewWalletWithName:@"name" pin:pin seedWords:worlds withSuccessHandler:^(Wallet *newWallet) {
        [walletManager storePin:pin];
        
        BOOL goodSignedIn = [walletManager isSignedIn];
        XCTAssertTrue(goodSignedIn == YES);
    } andFailureHandler:^{
        XCTAssertTrue(NO);
    }];
}

- (void)test_Start {
    
    NSArray *worlds = @[@"contributor", @"lately", @"classroom", @"super", @"sphere", @"turn", @"confuse", @"leading", @"ease", @"brother", @"march", @"heavy"];
    NSString *pin = @"1111";
    NSString *newPin = @"2222";
    NSString *nilPin = nil;
    
    WalletManager *walletManager = [WalletManager new];
    [walletManager createNewWalletWithName:@"name" pin:pin seedWords:worlds withSuccessHandler:^(Wallet *newWallet) {
        [walletManager storePin:pin];
        
        BOOL goodStart = [walletManager startWithPin:pin];
        XCTAssertTrue(goodStart == YES);
        
        BOOL badStart = [walletManager startWithPin:newPin];
        XCTAssertTrue(badStart == NO);
        
        BOOL nilStart = [walletManager startWithPin:nilPin];
        XCTAssertTrue(nilStart == NO);
    } andFailureHandler:^{
        XCTAssertTrue(NO);
    }];
}

- (void)test_BrainKey {
    
    NSArray *worlds = @[@"contributor", @"lately", @"classroom", @"super", @"sphere", @"turn", @"confuse", @"leading", @"ease", @"brother", @"march", @"heavy"];
    NSString *stringWords = @"contributor lately classroom super sphere turn confuse leading ease brother march heavy";
    NSString *pin = @"1111";
    NSString *newPin = @"2222";
    NSString *nilPin = nil;
    
    WalletManager *walletManager = [WalletManager new];
    [walletManager createNewWalletWithName:@"name" pin:pin seedWords:worlds withSuccessHandler:^(Wallet *newWallet) {
        [walletManager storePin:pin];
        
        NSString *goodBrainKey = [walletManager brandKeyWithPin:pin];
        XCTAssertTrue([goodBrainKey isEqualToString:stringWords]);
        
        NSString *badBrainKey = [walletManager brandKeyWithPin:newPin];
        XCTAssertTrue(![badBrainKey isEqualToString:stringWords]);
        
        NSString *nilBrainKey = [walletManager brandKeyWithPin:nilPin];
        XCTAssertTrue(![nilBrainKey isEqualToString:stringWords]);
    } andFailureHandler:^{
        XCTAssertTrue(NO);
    }];
}

@end
