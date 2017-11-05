//
//  QTUMBigDecimalStringsTest.m
//  qtum walletTests
//
//  Created by Никита Федоренко on 04.11.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "QTUMBigNumber.h"

@interface QTUMBigDecimalStringsTest : XCTestCase

@end

@implementation QTUMBigDecimalStringsTest

- (void)testShortStringDecimal1 {
    
    QTUMBigNumber *decimal = [QTUMBigNumber decimalWithString:@"400000000.6780"];
    
    NSString* result = [decimal shortFormatOfNumber];
    
    XCTAssertTrue([result isEqualToString:@"4E+8"]);
}

- (void)testShortStringDecimal2 {
    
    QTUMBigNumber *decimal = [QTUMBigNumber decimalWithString:@"4.678000000000000000000"];
    
    NSString* result = [decimal shortFormatOfNumber];
    
    XCTAssertTrue([result isEqualToString:@"4.68E+0"]);
}

- (void)testShortStringDecimal3 {
    
    QTUMBigNumber *decimal = [QTUMBigNumber decimalWithString:@"0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000678000000000000000000"];
    
    NSString* result = [decimal shortFormatOfNumber];
    
    XCTAssertTrue([result isEqualToString:@"6.78E-151"]);
}

- (void)testShortStringDecimal4 {
    
    QTUMBigNumber *decimal = [QTUMBigNumber decimalWithString:@"0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000678000000000000000000"];
    
    NSString* result = [decimal shortFormatOfNumber];
    
    XCTAssertTrue([result isEqualToString:@"6.78E-301"]);
}

- (void)testShortStringDecimal5 {
    
    QTUMBigNumber *decimal = [QTUMBigNumber decimalWithString:@"0.5"];
    QTUMBigNumber *power = [QTUMBigNumber decimalWithString:@"-501"];

    NSString* result = [decimal shortFormatOfNumberWithPowerOf10:power];
    
    XCTAssertTrue([result isEqualToString:@"5E-502"]);
}

- (void)testShortStringDecimal6 {
    
    QTUMBigNumber *decimal = [QTUMBigNumber decimalWithString:@"0.5"];
    QTUMBigNumber *power = [QTUMBigNumber decimalWithString:@"501"];
    
    NSString* result = [decimal shortFormatOfNumberWithPowerOf10:power];
    
    XCTAssertTrue([result isEqualToString:@"5E+500"]);
}

- (void)testShortStringDecimal7 {
    
    QTUMBigNumber *decimal = [QTUMBigNumber decimalWithString:@"5"];
    QTUMBigNumber *power = [QTUMBigNumber decimalWithString:@"1024"];
    
    NSString* result = [decimal shortFormatOfNumberWithPowerOf10:power];
    
    XCTAssertTrue([result isEqualToString:@"5E+1024"]);
}

- (void)testShortStringDecimal8 {
    
    QTUMBigNumber *decimal = [QTUMBigNumber decimalWithString:@"5000000000000"];
    QTUMBigNumber *power = [QTUMBigNumber decimalWithString:@"1024"];
    
    NSString* result = [decimal shortFormatOfNumberWithPowerOf10:power];
    
    XCTAssertTrue([result isEqualToString:@"5E+1036"]);
}

- (void)testShortStringDecimal9 {
    
    QTUMBigNumber *decimal = [QTUMBigNumber decimalWithString:@"5"];
    QTUMBigNumber *power = [QTUMBigNumber decimalWithString:@"10000000000000000"];
    
    NSString* result = [decimal shortFormatOfNumberWithPowerOf10:power];
    
    XCTAssertTrue([result isEqualToString:@"5E+10000000000000000"]);
}

- (void)testShortStringDecimal10 {
    
    QTUMBigNumber *decimal = [QTUMBigNumber decimalWithString:@"5"];
    QTUMBigNumber *power = [QTUMBigNumber decimalWithString:@"9223372036854775808"];
    
    NSString* result = [decimal shortFormatOfNumberWithPowerOf10:power];
    
    XCTAssertTrue([result isEqualToString:@"5E+9223372036854775808"]);
}

- (void)testShortStringDecimal11 {
    
    QTUMBigNumber *decimal = [QTUMBigNumber decimalWithString:@"9.999999"];
    QTUMBigNumber *power = [QTUMBigNumber decimalWithString:@"9223371231231231231231231231231231231231231231231231231231231231231232036854775808"];
    
    NSString* result = [decimal shortFormatOfNumberWithPowerOf10:power];
    
    XCTAssertTrue([result isEqualToString:@"9.99E+9223371231231231231231231231231231231231231231231231231231231231231232036854775808"]);
}

@end
