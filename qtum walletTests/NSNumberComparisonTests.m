//
//  NSNumberComparisonTests.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich  on 25.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSNumber+Comparison.h"
#import "NSDecimalNumber+Comparison.h"

@interface NSNumberComparisonTests : XCTestCase

@end

@implementation NSNumberComparisonTests


#pragma mark - isLessThan: tests

- (void)test_isLessThan_whenGreaterThan_returnsNO {

	NSNumber *numberA = [NSNumber numberWithFloat:4.6780];
	NSNumber *numberB = [NSNumber numberWithFloat:4.6779];

	BOOL result = [numberA isLessThan:numberB];

	XCTAssertFalse(result);
}

- (void)test_isLessThan_whenLessThan_returnsYES {

	NSNumber *numberA = [NSNumber numberWithFloat:4.6780];
	NSNumber *numberB = [NSNumber numberWithFloat:4.6781];

	BOOL result = [numberA isLessThan:numberB];

	XCTAssertTrue(result);
}

- (void)test_isLessThan_whenEqualTo_returnsNO {

	NSNumber *numberA = [NSNumber numberWithFloat:4.6780];
	NSNumber *numberB = [NSNumber numberWithFloat:4.6780];

	BOOL result = [numberA isGreaterThan:numberB];

	XCTAssertFalse(result);
}

#pragma mark - isLessThanOrEqualTo: tests

- (void)test_isLessThanOrEqualTo_whenGreaterThan_returnsNO {

	NSNumber *numberA = [NSNumber numberWithFloat:4.6780];
	NSNumber *numberB = [NSNumber numberWithFloat:4.6779];

	BOOL result = [numberA isLessThanOrEqualTo:numberB];

	XCTAssertFalse(result);
}

- (void)test_isLessThanOrEqualTo_whenLessThan_returnsYES {

	NSNumber *numberA = [NSNumber numberWithFloat:4.6780];
	NSNumber *numberB = [NSNumber numberWithFloat:4.6781];

	BOOL result = [numberA isLessThanOrEqualTo:numberB];

	XCTAssertTrue(result);
}

- (void)test_isLessThanOrEqualTo_whenEqualTo_returnsYES {

	NSNumber *numberA = [NSNumber numberWithFloat:4.6780];
	NSNumber *numberB = [NSNumber numberWithFloat:4.6780];

	BOOL result = [numberA isLessThanOrEqualTo:numberB];

	XCTAssertTrue(result);
}

#pragma mark - isGreaterThan: tests

- (void)test_isGreaterThan_whenGreaterThan_returnsYES {

	NSNumber *numberA = [NSNumber numberWithFloat:4.6780];
	NSNumber *numberB = [NSNumber numberWithFloat:4.6779];

	BOOL result = [numberA isGreaterThan:numberB];

	XCTAssertTrue(result);
}

- (void)test_isGreaterThan_whenLessThan_returnsNO {

	NSNumber *numberA = [NSNumber numberWithFloat:4.6780];
	NSNumber *numberB = [NSNumber numberWithFloat:4.6781];

	BOOL result = [numberA isGreaterThan:numberB];

	XCTAssertFalse(result);
}

- (void)test_isGreaterThan_whenEqualTo_returnsNO {

	NSNumber *numberA = [NSNumber numberWithFloat:4.6780];
	NSNumber *numberB = [NSNumber numberWithFloat:4.6780];

	BOOL result = [numberA isGreaterThan:numberB];

	XCTAssertFalse(result);
}

#pragma mark - isGreaterThanOrEqualTo: tests

- (void)test_isGreaterThanOrEqualTo_whenGreaterThan_returnsYES {

	NSNumber *numberA = [NSNumber numberWithFloat:4.6780];
	NSNumber *numberB = [NSNumber numberWithFloat:4.6779];

	BOOL result = [numberA isGreaterThanOrEqualTo:numberB];

	XCTAssertTrue(result);
}

- (void)test_isGreaterThanOrEqualTo_whenLessThan_returnsNO {

	NSNumber *numberA = [NSNumber numberWithFloat:4.6780];
	NSNumber *numberB = [NSNumber numberWithFloat:4.6781];

	BOOL result = [numberA isGreaterThanOrEqualTo:numberB];

	XCTAssertFalse(result);
}

- (void)test_isGreaterThanOrEqualTo_whenEqualTo_returnsYES {

	NSNumber *numberA = [NSNumber numberWithFloat:4.6780];
	NSNumber *numberB = [NSNumber numberWithFloat:4.6780];

	BOOL result = [numberA isGreaterThanOrEqualTo:numberB];

	XCTAssertTrue(result);
}

#pragma mark - isEqualToDecimalNumber: tests

- (void)test_isEqualToDecimalNumber_whenGreaterThan_returnsNO {

	NSNumber *numberA = [NSNumber numberWithFloat:4.6780];
	NSNumber *numberB = [NSNumber numberWithFloat:4.6779];

	BOOL result = [numberA isEqualToNumber:numberB];

	XCTAssertFalse(result);
}

- (void)test_isEqualToDecimalNumber_whenLessThan_returnsNO {

	NSNumber *numberA = [NSNumber numberWithFloat:4.6780];
	NSNumber *numberB = [NSNumber numberWithFloat:4.6781];

	BOOL result = [numberA isEqualToNumber:numberB];

	XCTAssertFalse(result);
}

- (void)test_isEqualToDecimalNumber_whenEqualTo_returnsYES {

	NSNumber *numberA = [NSNumber numberWithFloat:4.6780];
	NSNumber *numberB = [NSNumber numberWithFloat:4.6780];

	BOOL result = [numberA isEqualToNumber:numberB];

	XCTAssertTrue(result);
}

#pragma string is equal float

- (void)test_StringNumberIsEqualToDecimalNumber_whenEqualTo_returnsYES {

	NSNumber *numberA = @(@"4.6780".floatValue);
	NSNumber *numberB = [NSNumber numberWithFloat:4.6780];

	BOOL result = [numberA isEqualToNumber:numberB];

	XCTAssertTrue(result);
}

- (void)test_convertingToDecimal_IsEqualToDecimalNumber_whenEqualTo_returnsYES {

	NSNumber *numberA = @(@"4.6780".floatValue);
	NSNumber *numberB = [NSNumber numberWithFloat:4.6780];

	BOOL result = [numberA.decimalNumber isEqualToDecimalNumber:numberB.decimalNumber];

	XCTAssertTrue(result);

	result = [numberA.decimalNumber isEqualToNumber:numberB.decimalNumber];

	XCTAssertTrue(result);
}

@end
