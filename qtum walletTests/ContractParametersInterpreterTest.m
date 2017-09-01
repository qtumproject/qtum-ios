//
//  ContractParametersInterpreterTest.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 28.08.17.
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

- (void)testEncode_Uint256_String {
    
    NSArray* values = @[@"123",@"Hello, World!"];
    AbiParameterTypeUInt* uint = [[AbiParameterTypeUInt alloc] initWithSize:256];
    AbiParameterTypeString* string = [AbiParameterTypeString new];

    NSArray* types = @[uint, string];
    
    NSData* args = [[ContractArgumentsInterpretator sharedInstance] contactArgumentsFromArrayOfValues:values andArrayOfTypes:types];
    NSString* decodedParams = @"000000000000000000000000000000000000000000000000000000000000007b0000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000d48656c6c6f2c20576f726c642100000000000000000000000000000000000000";
    
    XCTAssertTrue([[NSString hexadecimalString:args] isEqualToString:decodedParams]);
}

- (void)testEncode_Uint256_Uint256_String {
    
    NSArray* values = @[@"123",@"456",@"thequickbrownfoxjumpsoverthelazydog"];
    AbiParameterTypeUInt* uint = [[AbiParameterTypeUInt alloc] initWithSize:256];
    AbiParameterTypeString* string = [AbiParameterTypeString new];
    NSArray* types = @[uint, uint, string];
    
    NSData* args = [[ContractArgumentsInterpretator sharedInstance] contactArgumentsFromArrayOfValues:values andArrayOfTypes:types];
    NSString* decodedParams = @"000000000000000000000000000000000000000000000000000000000000007b00000000000000000000000000000000000000000000000000000000000001c800000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000000000000000000023746865717569636b62726f776e666f786a756d70736f7665727468656c617a79646f670000000000000000000000000000000000000000000000000000000000";
    
    XCTAssertTrue([[NSString hexadecimalString:args] isEqualToString:decodedParams]);
}

- (void)testEncode_Uint256_Uint256_String_string {
    
    NSArray* values = @[@"123",@"456",@"thequickbrownfoxjumpsoverthelazydog", @"shesellsseashellsontheseashore"];
    AbiParameterTypeUInt* uint = [[AbiParameterTypeUInt alloc] initWithSize:256];
    AbiParameterTypeString* string = [AbiParameterTypeString new];
    NSArray* types = @[uint, uint, string, string];
    
    NSData* args = [[ContractArgumentsInterpretator sharedInstance] contactArgumentsFromArrayOfValues:values andArrayOfTypes:types];
    NSString* decodedParams = @"000000000000000000000000000000000000000000000000000000000000007b00000000000000000000000000000000000000000000000000000000000001c8000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000e00000000000000000000000000000000000000000000000000000000000000023746865717569636b62726f776e666f786a756d70736f7665727468656c617a79646f670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001e73686573656c6c737365617368656c6c736f6e74686573656173686f72650000";
    
    XCTAssertTrue([[NSString hexadecimalString:args] isEqualToString:decodedParams]);
}

- (void)testEncode_address {
    
    NSArray* values = @[@"QQ2aC88XdLragnPUBPyex3qDvhNYyHXG5Y"];
    
    AbiParameterTypeAddress* address = [AbiParameterTypeAddress new];
    NSArray* types = @[address];
    
    NSData* args = [[ContractArgumentsInterpretator sharedInstance] contactArgumentsFromArrayOfValues:values andArrayOfTypes:types];
    NSString* decodedParams = @"000000000000000000000000258ecfc80aadffb3f00e9183b3fda62f63280b54";
    
    XCTAssertTrue([[NSString hexadecimalString:args] isEqualToString:decodedParams]);
}

- (void)testEncode_Address_Uint256_Uint256_String_String {
    
    NSArray* values = @[@"QQ2aC88XdLragnPUBPyex3qDvhNYyHXG5Y",@"123",@"456",@"thequickbrownfoxjumpsoverthelazydog", @"shesellsseashellsontheseashore"];
    
    AbiParameterTypeAddress* address = [AbiParameterTypeAddress new];
    AbiParameterTypeUInt* uint = [[AbiParameterTypeUInt alloc] initWithSize:256];
    AbiParameterTypeString* string = [AbiParameterTypeString new];

    NSArray* types = @[address,uint, uint, string, string];
    
    NSData* args = [[ContractArgumentsInterpretator sharedInstance] contactArgumentsFromArrayOfValues:values andArrayOfTypes:types];
    NSString* decodedParams = @"000000000000000000000000258ecfc80aadffb3f00e9183b3fda62f63280b54000000000000000000000000000000000000000000000000000000000000007b00000000000000000000000000000000000000000000000000000000000001c800000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000023746865717569636b62726f776e666f786a756d70736f7665727468656c617a79646f670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001e73686573656c6c737365617368656c6c736f6e74686573656173686f72650000";
    
    XCTAssertTrue([[NSString hexadecimalString:args] isEqualToString:decodedParams]);
}

- (void)testEncode_Bool_String_String_Uint8_Bool {
    
    NSArray* values = @[@"1",@"sd",@"asd",@"255",@"0"];
    AbiParameterTypeUInt* uint = [[AbiParameterTypeUInt alloc] initWithSize:8];
    AbiParameterTypeString* string = [AbiParameterTypeString new];
    AbiParameterTypeBool* boolType = [[AbiParameterTypeBool alloc] initWithSize:0];

    NSArray* types = @[boolType,string, string, uint, boolType];
    
    NSData* args = [[ContractArgumentsInterpretator sharedInstance] contactArgumentsFromArrayOfValues:values andArrayOfTypes:types];
    NSString* decodedParams = @"000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e000000000000000000000000000000000000000000000000000000000000000ff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002736400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000036173640000000000000000000000000000000000000000000000000000000000";
    
    XCTAssertTrue([[NSString hexadecimalString:args] isEqualToString:decodedParams]);
}

- (void)test_Ether_Example_Decode_Uint32_Bool {
    
    NSArray* values = @[@"69",@"1"];
    AbiParameterTypeUInt* uint32 = [[AbiParameterTypeUInt alloc] initWithSize:32];
    AbiParameterTypeBool* boolType = [[AbiParameterTypeBool alloc] initWithSize:0];
    
    NSArray* types = @[uint32,boolType];
    
    NSData* args = [[ContractArgumentsInterpretator sharedInstance] contactArgumentsFromArrayOfValues:values andArrayOfTypes:types];
    NSString* decodedParams = @"00000000000000000000000000000000000000000000000000000000000000450000000000000000000000000000000000000000000000000000000000000001";
    
    XCTAssertTrue([[NSString hexadecimalString:args] isEqualToString:decodedParams]);
}

- (void)test_Transfer_Params_Decode_Address_Uint256 {
    
    NSArray* values = @[@"QQ2aC88XdLragnPUBPyex3qDvhNYyHXG5Y",@"100"];
    AbiParameterTypeUInt* uint256 = [[AbiParameterTypeUInt alloc] initWithSize:256];
    AbiParameterTypeAddress* address = [AbiParameterTypeAddress new];
    
    NSArray* types = @[address,uint256];
    
    NSData* args = [[ContractArgumentsInterpretator sharedInstance] contactArgumentsFromArrayOfValues:values andArrayOfTypes:types];
    NSString* decodedParams = @"000000000000000000000000258ecfc80aadffb3f00e9183b3fda62f63280b540000000000000000000000000000000000000000000000000000000000000064";
    
    XCTAssertTrue([[NSString hexadecimalString:args] isEqualToString:decodedParams]);
}



@end
