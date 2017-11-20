//
//  ContractManagerTests.m
//  qtum walletTests
//
//  Created by Vladimir Sharaev on 03.10.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ContractManager.h"
#import "Contract.h"

@interface ContractManagerTests : XCTestCase

@end

@implementation ContractManagerTests

- (void)setUp {
	[super setUp];
}

- (void)tearDown {

	[super tearDown];
	[[ContractManager sharedInstance] clear];
}

- (void)test_Clear {

	[[ContractManager sharedInstance] clear];
	NSInteger contractCount = [ContractManager sharedInstance].allContracts.count;
	NSInteger tokensCount = [ContractManager sharedInstance].allTokens.count;
	NSInteger activeTokensCount = [ContractManager sharedInstance].allActiveTokens.count;

	XCTAssertTrue(contractCount == 0);
	XCTAssertTrue(tokensCount == 0);
	XCTAssertTrue(activeTokensCount == 0);
}

- (void)test_Add_New_Token {

	NSInteger tokensCount = [ContractManager sharedInstance].allContracts.count;
	[[ContractManager sharedInstance] addNewToken:[Contract new]];
	NSInteger newTokensCount = [ContractManager sharedInstance].allContracts.count;

	XCTAssertTrue(tokensCount + 1 == newTokensCount);

	NSInteger tokensCount5 = [ContractManager sharedInstance].allContracts.count;
	[[ContractManager sharedInstance] addNewTokenWithContractAddress:@"1234567890123456"];
	NSInteger newTokensCount5 = [ContractManager sharedInstance].allContracts.count;

	XCTAssertTrue(tokensCount5 + 1 == newTokensCount5);

	NSInteger tokensCount4 = [ContractManager sharedInstance].allContracts.count;
	[[ContractManager sharedInstance] addNewTokenWithContractAddress:nil];
	NSInteger newTokensCount4 = [ContractManager sharedInstance].allContracts.count;

	XCTAssertTrue(tokensCount4 == newTokensCount4);

	NSInteger tokensCount3 = [ContractManager sharedInstance].allContracts.count;
	[[ContractManager sharedInstance] addNewTokenWithContractAddress:@"asdfasf"];
	NSInteger newTokensCount3 = [ContractManager sharedInstance].allContracts.count;

	XCTAssertTrue(tokensCount3 + 1 == newTokensCount3);

	NSInteger tokensCount2 = [ContractManager sharedInstance].allContracts.count;
	[[ContractManager sharedInstance] addNewToken:nil];
	NSInteger newTokensCount2 = [ContractManager sharedInstance].allContracts.count;

	XCTAssertTrue(tokensCount2 == newTokensCount2);
}

@end

