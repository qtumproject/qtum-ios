//
//  WalletTests.m
//  qtum walletTests
//
//  Created by Vladimir Sharaev on 03.10.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Wallet.h"
#import <BTCKey.h>

@interface WalletTests : XCTestCase

@property (nonatomic) NSString *nameSring;
@property (nonatomic) NSString *nilName;
@property (nonatomic) NSString *pin;
@property (nonatomic) NSString *changedPin;
@property (nonatomic) NSString *nilPin;
@property (nonatomic) NSArray *words;
@property (nonatomic) NSArray *nilWords;
@property (nonatomic) NSString *worldsString;

@end

@implementation WalletTests

- (void)setUp {
    [super setUp];
    
    self.nameSring = @"name";
    self.nilName = nil;
    self.pin = @"1111";
    self.changedPin = @"2222";
    self.nilPin = nil;
    self.words = @[@"contributor", @"lately", @"classroom", @"super", @"sphere", @"turn", @"confuse", @"leading", @"ease", @"brother", @"march", @"heavy"];
    self.nilWords = nil;
    self.worldsString = @"contributor lately classroom super sphere turn confuse leading ease brother march heavy";
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_Good_Creation {
    Wallet *wallet = [[Wallet alloc] initWithName:self.nameSring pin:self.pin];
    XCTAssertTrue(wallet);
}

- (void)test_Nil_Pin_Creation {
    Wallet *wallet = [[Wallet alloc] initWithName:self.nameSring pin:self.nilPin];
    XCTAssertTrue(wallet);
}

- (void)test_Nil_Name_Creation {
    Wallet *wallet = [[Wallet alloc] initWithName:self.nilName pin:self.pin];
    XCTAssertTrue(wallet);
}

- (void)test_Good_Creation_Seed_Words {
    Wallet *wallet = [[Wallet alloc] initWithName:self.nameSring pin:self.pin seedWords:self.words];
    XCTAssertTrue(wallet);
}

- (void)test_Creation_Seed_NilWords {
    Wallet *wallet = [[Wallet alloc] initWithName:self.nameSring pin:self.pin seedWords:self.nilWords];
    XCTAssertNil(wallet);
}

- (void)test_Creation_Seed_Words_BadWords {
    NSMutableArray *mutWords = [self.words mutableCopy];
    [mutWords removeLastObject];
    [mutWords removeLastObject];
    [mutWords removeLastObject];
    [mutWords removeLastObject];
    Wallet *wallet = [[Wallet alloc] initWithName:self.nameSring pin:self.pin seedWords:mutWords];
    XCTAssertNil(wallet);
}

- (void)test_Addresses {
    Wallet *wallet = [[Wallet alloc] initWithName:self.nameSring pin:self.pin seedWords:self.words];
    NSArray *allAddresses = [wallet allKeysAdreeses];
    NSArray *allKeys = [wallet allKeys];
    XCTAssertNil(allAddresses);
    XCTAssertTrue(allKeys.count == 0);
    
    [wallet configAddressesWithPin:self.pin];
    allAddresses = [wallet allKeysAdreeses];
    allKeys = [wallet allKeys];
    XCTAssertTrue(allAddresses);
    XCTAssertTrue(allAddresses > 0);
    XCTAssertTrue(allKeys);
    XCTAssertTrue(allKeys > 0);
    XCTAssertTrue(allKeys.count == allAddresses.count);
    
    [wallet clearPublicAddresses];
    allAddresses = [wallet allKeysAdreeses];
    XCTAssertNil(allAddresses);
    
    [wallet configAddressesWithPin:self.changedPin];
    allAddresses = [wallet allKeysAdreeses];
    XCTAssertNil(allAddresses);
    
    [wallet clearPublicAddresses];
}

- (void)test_Change {
    Wallet *wallet = [[Wallet alloc] initWithName:self.nameSring pin:self.pin seedWords:self.words];
    XCTAssertTrue(![wallet changeBrandKeyPinWithOldPin:self.nilPin toNewPin:self.changedPin]);
    XCTAssertTrue(![wallet changeBrandKeyPinWithOldPin:self.changedPin toNewPin:self.changedPin]);
    XCTAssertTrue([wallet changeBrandKeyPinWithOldPin:self.pin toNewPin:self.changedPin]);
    XCTAssertTrue([wallet changeBrandKeyPinWithOldPin:self.changedPin toNewPin:self.nilPin]);
}

- (void)test_Get_Brain_Key_String {
    Wallet *wallet = [[Wallet alloc] initWithName:self.nameSring pin:self.pin seedWords:self.words];
    NSString *string = [wallet brandKeyWithPin:self.pin];
    XCTAssertTrue([string isEqualToString:self.worldsString]);
    
    [wallet changeBrandKeyPinWithOldPin:self.pin toNewPin:self.changedPin];
    string = [wallet brandKeyWithPin:self.changedPin];
    XCTAssertTrue([string isEqualToString:self.worldsString]);
    
    [wallet changeBrandKeyPinWithOldPin:self.pin toNewPin:self.nilPin];
    string = [wallet brandKeyWithPin:self.nilPin];
    XCTAssertTrue([string isEqualToString:self.worldsString]);
}

- (void)test_Keys {
    Wallet *wallet = [[Wallet alloc] initWithName:self.nameSring pin:self.pin seedWords:self.words];
#warning Crash
//    XCTAssertNil([wallet lastRandomKeyOrRandomKey]);
//    XCTAssertNil([wallet randomKey]);
//    XCTAssertNil([wallet keyAtIndex:0]);
    
    [wallet configAddressesWithPin:self.pin];
    XCTAssertTrue([wallet lastRandomKeyOrRandomKey]);
    XCTAssertTrue([wallet randomKey]);
    XCTAssertTrue([wallet keyAtIndex:0]);
    XCTAssertTrue([wallet keyAtIndex:10]);
    XCTAssertTrue([wallet keyAtIndex:20]);
    XCTAssertTrue([wallet keyAtIndex:-1]);
}

- (void)test_Hash_Table {
    Wallet *wallet = [[Wallet alloc] initWithName:self.nameSring pin:self.pin seedWords:self.words];
    NSDictionary *hashTabel = [wallet addressKeyHashTable];
    XCTAssertTrue(hashTabel.allKeys.count == 0);
    [wallet configAddressesWithPin:self.pin];
    hashTabel = [wallet addressKeyHashTable];
    XCTAssertTrue(hashTabel.allKeys.count > 0);
    XCTAssertTrue(hashTabel.allKeys.count > [wallet allKeys].count);
    
}

@end
