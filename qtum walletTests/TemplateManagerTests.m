//
//  TemplateManagerTests.m
//  qtum walletTests
//
//  Created by Vladimir Sharaev on 03.10.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TemplateManager.h"

@interface TemplateManagerTests : XCTestCase

@end

@implementation TemplateManagerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [[TemplateManager sharedInstance] clear];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_Standart_Pack {
    NSInteger countTemplates = [[TemplateManager sharedInstance] standartPackOfTemplates].count;
    NSInteger countTokenTemplates = [[TemplateManager sharedInstance] standartPackOfTokenTemplates].count;
    XCTAssertTrue(countTemplates == 3);
    XCTAssertTrue(countTokenTemplates == 2);
}

- (void)test_Clear {
    NSInteger countTemplates = [[TemplateManager sharedInstance] availebaleTemplates].count;
    NSInteger countTokenTemplates = [[TemplateManager sharedInstance] availebaleTokenTemplates].count;
    XCTAssertTrue(countTemplates == 3);
    XCTAssertTrue(countTokenTemplates == 2);
}

- (void)test_Add {
    NSInteger countTemplates = [[TemplateManager sharedInstance] availebaleTemplates].count;
    TemplateModel *model = [[[TemplateManager sharedInstance] standartPackOfTemplates] firstObject];
    [[TemplateManager sharedInstance] saveTemplate:model];
    NSInteger newCountTemplates = [[TemplateManager sharedInstance] availebaleTemplates].count;
    
    XCTAssertTrue(countTemplates + 1 == newCountTemplates);
}

- (void)test_Add_Nil {
    NSInteger countTemplates = [[TemplateManager sharedInstance] availebaleTemplates].count;
    [[TemplateManager sharedInstance] saveTemplate:nil];
    NSInteger newCountTemplates = [[TemplateManager sharedInstance] availebaleTemplates].count;
    
    XCTAssertTrue(countTemplates == newCountTemplates);
}

- (void)test_Decode {
    NSArray *data = [[TemplateManager sharedInstance] decodeDataForBackup];
    
    XCTAssertTrue(data.count == [[TemplateManager sharedInstance] availebaleTemplates].count);
    
    for (NSObject *object in data) {
        XCTAssertTrue([object isKindOfClass:[NSDictionary class]]);
    }
}

- (void)test_Encode {
    NSMutableArray *data = [[[TemplateManager sharedInstance] decodeDataForBackup] mutableCopy];
    NSArray *array = [[TemplateManager sharedInstance] encodeDataForBacup:data];
    
    XCTAssertTrue(data.count == array.count);
    
    for (NSObject *object in array) {
        XCTAssertTrue([object isKindOfClass:[TemplateModel class]]);
    }
    
    NSArray *array3 = [[TemplateManager sharedInstance] encodeDataForBacup:nil];
    XCTAssertTrue(array3.count == 0);
    
    [data addObject:[NSObject new]];
    NSArray *array2 = [[TemplateManager sharedInstance] encodeDataForBacup:data];
    XCTAssertTrue(data.count - 1 == array2.count);
}

- (void)test_Template_Token_Creation {
    TemplateModel *model = [[TemplateManager sharedInstance] createNewTokenTemplateWithAbi:@"test" contractAddress:@"test" andName:@"test"];
    XCTAssertNil(model);
    
    model = [[TemplateManager sharedInstance] createNewTokenTemplateWithAbi:@"test" contractAddress:nil andName:@"test"];
    XCTAssertNil(model);
    
    model = [[TemplateManager sharedInstance] createNewTokenTemplateWithAbi:@"test" contractAddress:@"test" andName:nil];
    XCTAssertNil(model);
    
    model = [[TemplateManager sharedInstance] createNewTokenTemplateWithAbi:nil contractAddress:@"test" andName:@"test"];
    XCTAssertNil(model);
}

- (void)test_Template_Contract_Creation {
    TemplateModel *model = [[TemplateManager sharedInstance] createNewContractTemplateWithAbi:@"test" contractAddress:@"test" andName:@"test"];
    XCTAssertNil(model);
    
    model = [[TemplateManager sharedInstance] createNewContractTemplateWithAbi:@"test" contractAddress:nil andName:@"test"];
    XCTAssertNil(model);
    
    model = [[TemplateManager sharedInstance] createNewContractTemplateWithAbi:@"test" contractAddress:@"test" andName:nil];
    XCTAssertNil(model);
    
    model = [[TemplateManager sharedInstance] createNewContractTemplateWithAbi:nil contractAddress:@"test" andName:@"test"];
    XCTAssertNil(model);
}

- (void)test_Template_Creation {
    TemplateModel *model = [[TemplateManager sharedInstance] createNewTemplateWithAbi:@"test" bitecode:@"test" source:@"test" type:TokenType uuid:@"test" andName:@"test"];
    XCTAssertNil(model);
    
    model = [[TemplateManager sharedInstance] createNewTemplateWithAbi:@"test" bitecode:nil source:@"test" type:TokenType uuid:@"test" andName:@"test"];
    XCTAssertNil(model);
    
    model = [[TemplateManager sharedInstance] createNewTemplateWithAbi:@"test" bitecode:@"test" source:nil type:TokenType uuid:@"test" andName:@"test"];
    XCTAssertNil(model);
    
    model = [[TemplateManager sharedInstance] createNewTemplateWithAbi:@"test" bitecode:@"test" source:@"test" type:TokenType uuid:nil andName:@"test"];
    XCTAssertNil(model);
    
    model = [[TemplateManager sharedInstance] createNewTemplateWithAbi:@"test" bitecode:@"test" source:@"test" type:TokenType uuid:@"test" andName:nil];
    XCTAssertNil(model);
    
    model = [[TemplateManager sharedInstance] createNewTemplateWithAbi:nil bitecode:@"test" source:@"test" type:TokenType uuid:@"test" andName:@"test"];
    XCTAssertNil(model);
}

@end
