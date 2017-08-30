//
//  AbiRegexTest.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+AbiRegex.h"

@interface AbiRegexTest : XCTestCase

@end

@implementation AbiRegexTest

- (void)test_Uint_Detection {
    
    NSString* abiField = @"uint32";
    XCTAssertTrue([abiField isUintFromAbi]);
    
    abiField = @"uint32sd";
    XCTAssertFalse([abiField isUintFromAbi]);
    
    abiField = @"uint";
    XCTAssertTrue([abiField isUintFromAbi]);
    
    abiField = @"uin32";
    XCTAssertFalse([abiField isUintFromAbi]);
    
    abiField = @"int32";
    XCTAssertFalse([abiField isUintFromAbi]);
    
    abiField = @"uint[]";
    XCTAssertFalse([abiField isUintFromAbi]);
}

- (void)test_Int_Detection {
    
    NSString* abiField = @"int32";
    XCTAssertTrue([abiField isIntFromAbi]);
    
    abiField = @"int256";
    XCTAssertTrue([abiField isIntFromAbi]);
    
    abiField = @"int32sd";
    XCTAssertFalse([abiField isIntFromAbi]);
    
    abiField = @"int";
    XCTAssertTrue([abiField isIntFromAbi]);
    
    abiField = @"uin32";
    XCTAssertFalse([abiField isIntFromAbi]);
    
    abiField = @"int3s2";
    XCTAssertFalse([abiField isIntFromAbi]);
    
    abiField = @"uint[]";
    XCTAssertFalse([abiField isIntFromAbi]);
}


- (void)test_Fixed_Bytes_Detection {
    
    NSString* abiField = @"bytes9";
    XCTAssertTrue([abiField isBytesFixedFromAbi]);
    
    abiField = @"bytes32";
    XCTAssertTrue([abiField isBytesFixedFromAbi]);
    
    abiField = @"bytes";
    XCTAssertFalse([abiField isBytesFixedFromAbi]);
    
    abiField = @"bytes[9]";
    XCTAssertFalse([abiField isBytesFixedFromAbi]);
    
    abiField = @"bytes[0s]";
    XCTAssertFalse([abiField isBytesFixedFromAbi]);
    
    abiField = @"int[]";
    XCTAssertFalse([abiField isBytesFixedFromAbi]);
    
    abiField = @"bytes[a]";
    XCTAssertFalse([abiField isBytesFixedFromAbi]);
}

- (void)test_Bytes_Detection {
    
    NSString* abiField = @"bytes";
    XCTAssertTrue([abiField isBytesFromAbi]);
    
    abiField = @"bytes32";
    XCTAssertFalse([abiField isBytesFromAbi]);
    
    abiField = @"bytes[9]";
    XCTAssertFalse([abiField isBytesFromAbi]);
    
    abiField = @"bytes[0s]";
    XCTAssertFalse([abiField isBytesFromAbi]);
    
    abiField = @"int[]";
    XCTAssertFalse([abiField isBytesFromAbi]);
    
    abiField = @"bytes[a]";
    XCTAssertFalse([abiField isBytesFromAbi]);
}

- (void)test_Array_Detection {
    
    NSString* abiField = @"bytes[]";
    XCTAssertTrue([abiField isArrayFromAbi]);
    
    abiField = @"bytes[a]";
    XCTAssertFalse([abiField isArrayFromAbi]);
    
    abiField = @"bytes[10]";
    XCTAssertTrue([abiField isArrayFromAbi]);
}

- (void)test_Fixed_Bytes_Size_Detection {
    
    NSString* abiField = @"bytes9";
    XCTAssertTrue([abiField fixedBytesSize] == 9);
}

- (void)test_Uint_Size_Detection {
    
    NSString* abiField = @"uint256";
    XCTAssertTrue([abiField fixedBytesSize] == 256);
}

- (void)test_Int_Size_Detection {
    
    NSString* abiField = @"int128";
    XCTAssertTrue([abiField fixedBytesSize] == 128);
}



@end
