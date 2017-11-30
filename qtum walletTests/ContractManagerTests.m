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
#import "TemplateModel.h"

@interface ContractManagerTests : XCTestCase

@property (strong, nonatomic) ContractManager* contractManager;

@end

@implementation ContractManagerTests

- (void)setUp {
	[super setUp];
    self.contractManager = [ContractManager new];
}

- (void)tearDown {

	[super tearDown];
    [self.contractManager clear];
}

- (void)test_Clear {

	[self.contractManager clear];
	NSInteger contractCount = self.contractManager.allContracts.count;
	NSInteger tokensCount = self.contractManager.allTokens.count;
	NSInteger activeTokensCount = self.contractManager.allActiveTokens.count;

	XCTAssertTrue(contractCount == 0);
	XCTAssertTrue(tokensCount == 0);
	XCTAssertTrue(activeTokensCount == 0);
}

- (void)test_Add_New_Token {

	NSInteger tokensCount = self.contractManager.allContracts.count;
	[self.contractManager addNewContract:[Contract new]];
	NSInteger newTokensCount = self.contractManager.allContracts.count;

	XCTAssertTrue(tokensCount + 1 == newTokensCount);

	NSInteger tokensCount5 = self.contractManager.allContracts.count;
	[self.contractManager addNewTokenWithContractAddress:@"1234567890123456"];
	NSInteger newTokensCount5 = self.contractManager.allContracts.count;

	XCTAssertTrue(tokensCount5 + 1 == newTokensCount5);

	NSInteger tokensCount4 = self.contractManager.allContracts.count;
	[self.contractManager addNewTokenWithContractAddress:nil];
	NSInteger newTokensCount4 = self.contractManager.allContracts.count;

	XCTAssertTrue(tokensCount4 == newTokensCount4);

	NSInteger tokensCount3 = self.contractManager.allContracts.count;
	[self.contractManager addNewTokenWithContractAddress:@"asdfasf"];
	NSInteger newTokensCount3 = self.contractManager.allContracts.count;

	XCTAssertTrue(tokensCount3 + 1 == newTokensCount3);

	NSInteger tokensCount2 = self.contractManager.allContracts.count;
	[self.contractManager addNewContract:nil];
	NSInteger newTokensCount2 = self.contractManager.allContracts.count;

	XCTAssertTrue(tokensCount2 == newTokensCount2);
}

@end

