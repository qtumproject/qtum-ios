//
//  ContractParametersInterpreterTest.m
//  qtum wallet
//
//  Created by Никита Федоренко on 28.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ContractArgumentsInterpretator.h"
#import "AbiinterfaceEntries.h"
#import "NSString+Extension.h"

@interface ContractParametersInterpreterTest : XCTestCase

@end

@implementation ContractParametersInterpreterTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testDecode_Uint256_String {
    
    NSArray* values = @[@123,@"Hello, World!"];
    NSArray* types = @[@(UInt256Type), @(StringType)];
    
    NSData* args = [[ContractArgumentsInterpretator sharedInstance] contactArgumentFromArrayOfValues:values andArrayOfTypes:types];
    NSString* decodedParams = @"000000000000000000000000000000000000000000000000000000000000007b0000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000d48656c6c6f2c20576f726c642100000000000000000000000000000000000000";
    
    XCTAssertTrue([[NSString hexadecimalString:args] isEqualToString:decodedParams]);
}

- (void)testDecode_Uint256_Uint256_String {
    
    NSArray* values = @[@123,@456,@"thequickbrownfoxjumpsoverthelazydog"];
    NSArray* types = @[@(UInt256Type), @(UInt256Type), @(StringType)];
    
    NSData* args = [[ContractArgumentsInterpretator sharedInstance] contactArgumentFromArrayOfValues:values andArrayOfTypes:types];
    NSString* decodedParams = @"000000000000000000000000000000000000000000000000000000000000007b00000000000000000000000000000000000000000000000000000000000001c800000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000000000000000000023746865717569636b62726f776e666f786a756d70736f7665727468656c617a79646f670000000000000000000000000000000000000000000000000000000000";
    
    XCTAssertTrue([[NSString hexadecimalString:args] isEqualToString:decodedParams]);
}

- (void)testDecode_Uint256_Uint256_String_string {
    
    NSArray* values = @[@123,@456,@"thequickbrownfoxjumpsoverthelazydog", @"shesellsseashellsontheseashore"];
    NSArray* types = @[@(UInt256Type), @(UInt256Type), @(StringType), @(StringType)];
    
    NSData* args = [[ContractArgumentsInterpretator sharedInstance] contactArgumentFromArrayOfValues:values andArrayOfTypes:types];
    NSString* decodedParams = @"000000000000000000000000000000000000000000000000000000000000007b00000000000000000000000000000000000000000000000000000000000001c8000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000e00000000000000000000000000000000000000000000000000000000000000023746865717569636b62726f776e666f786a756d70736f7665727468656c617a79646f670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001e73686573656c6c737365617368656c6c736f6e74686573656173686f72650000";
    
    XCTAssertTrue([[NSString hexadecimalString:args] isEqualToString:decodedParams]);
}


@end
