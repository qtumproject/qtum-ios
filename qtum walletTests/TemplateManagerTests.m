//
//  TemplateManagerTests.m
//  qtum walletTests
//
//  Created by Vladimir Sharaev on 03.10.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TemplateManager.h"
#import "ServiceLocator.h"

@interface TemplateManagerTests : XCTestCase

@end

@implementation TemplateManagerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [[ServiceLocator sharedInstance].templateManager clear];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_Standart_Pack {
    NSInteger countTemplates = [[ServiceLocator sharedInstance].templateManager standartPackOfTemplates].count;
    NSInteger countTokenTemplates = [[ServiceLocator sharedInstance].templateManager standartPackOfTokenTemplates].count;
    XCTAssertTrue(countTemplates == 3);
    XCTAssertTrue(countTokenTemplates == 2);
}

- (void)test_Clear {
    NSInteger countTemplates = [[ServiceLocator sharedInstance].templateManager availebaleTemplates].count;
    NSInteger countTokenTemplates = [[ServiceLocator sharedInstance].templateManager availebaleTokenTemplates].count;
    XCTAssertTrue(countTemplates == 3);
    XCTAssertTrue(countTokenTemplates == 2);
}

- (void)test_Add {
    NSInteger countTemplates = [[ServiceLocator sharedInstance].templateManager availebaleTemplates].count;
    TemplateModel *model = [[[ServiceLocator sharedInstance].templateManager standartPackOfTemplates] firstObject];
    [[ServiceLocator sharedInstance].templateManager saveTemplate:model];
    NSInteger newCountTemplates = [[ServiceLocator sharedInstance].templateManager availebaleTemplates].count;
    
    XCTAssertTrue(countTemplates + 1 == newCountTemplates);
}

- (void)test_Add_Nil {
    NSInteger countTemplates = [[ServiceLocator sharedInstance].templateManager availebaleTemplates].count;
    [[ServiceLocator sharedInstance].templateManager saveTemplate:nil];
    NSInteger newCountTemplates = [[ServiceLocator sharedInstance].templateManager availebaleTemplates].count;
    
    XCTAssertTrue(countTemplates == newCountTemplates);
}

- (void)test_Decode {
    NSArray *data = [[ServiceLocator sharedInstance].templateManager decodeDataForBackup];
    
    XCTAssertTrue(data.count == [[ServiceLocator sharedInstance].templateManager availebaleTemplates].count);
    
    for (NSObject *object in data) {
        XCTAssertTrue([object isKindOfClass:[NSDictionary class]]);
    }
}

- (void)test_Encode {
    
    NSMutableArray *data = [[[ServiceLocator sharedInstance].templateManager decodeDataForBackup] mutableCopy];
    NSArray *array = [[ServiceLocator sharedInstance].templateManager encodeDataForBacup:data];
    
    XCTAssertTrue(data.count == array.count);
    
    for (NSObject *object in array) {
        XCTAssertTrue([object isKindOfClass:[TemplateModel class]]);
    }
    
    NSArray *array3 = [[ServiceLocator sharedInstance].templateManager encodeDataForBacup:nil];
    XCTAssertTrue(array3.count == 0);
    
    [data addObject:[NSObject new]];
    NSArray *array2 = [[ServiceLocator sharedInstance].templateManager encodeDataForBacup:data];
    XCTAssertTrue(data.count - 1 == array2.count);
}

- (void)test_Template_Token_Creation {
    
    TemplateModel *model = [[ServiceLocator sharedInstance].templateManager createNewTokenTemplateWithAbi:@"test" contractAddress:@"test" andName:@"test"];
    XCTAssertNil(model);
    
    model = [[ServiceLocator sharedInstance].templateManager createNewTokenTemplateWithAbi:@"test" contractAddress:nil andName:@"test"];
    XCTAssertNil(model);
    
    model = [[ServiceLocator sharedInstance].templateManager createNewTokenTemplateWithAbi:@"test" contractAddress:@"test" andName:nil];
    XCTAssertNil(model);
    
    model = [[ServiceLocator sharedInstance].templateManager createNewTokenTemplateWithAbi:nil contractAddress:@"test" andName:@"test"];
    XCTAssertNil(model);
}

- (void)test_Template_Contract_Creation {
    TemplateModel *model = [[ServiceLocator sharedInstance].templateManager createNewContractTemplateWithAbi:@"test" contractAddress:@"test" andName:@"test"];
    XCTAssertNil(model);
    
    model = [[ServiceLocator sharedInstance].templateManager createNewContractTemplateWithAbi:@"test" contractAddress:nil andName:@"test"];
    XCTAssertNil(model);
    
    model = [[ServiceLocator sharedInstance].templateManager createNewContractTemplateWithAbi:@"test" contractAddress:@"test" andName:nil];
    XCTAssertNil(model);
    
    model = [[ServiceLocator sharedInstance].templateManager createNewContractTemplateWithAbi:nil contractAddress:@"test" andName:@"test"];
    XCTAssertNil(model);
}

- (void)test_Template_Creation {
    
    TemplateModel *model = [[ServiceLocator sharedInstance].templateManager createNewTemplateWithAbi:@"test" bitecode:@"test" source:@"test" type:TokenType uuid:@"test" andName:@"test"];
    XCTAssertNil(model);
    
    model = [[ServiceLocator sharedInstance].templateManager createNewTemplateWithAbi:@"test" bitecode:nil source:@"test" type:TokenType uuid:@"test" andName:@"test"];
    XCTAssertNil(model);
    
    model = [[ServiceLocator sharedInstance].templateManager createNewTemplateWithAbi:@"test" bitecode:@"test" source:nil type:TokenType uuid:@"test" andName:@"test"];
    XCTAssertNil(model);
    
    model = [[ServiceLocator sharedInstance].templateManager createNewTemplateWithAbi:@"test" bitecode:@"test" source:@"test" type:TokenType uuid:nil andName:@"test"];
    XCTAssertNil(model);
    
    model = [[ServiceLocator sharedInstance].templateManager createNewTemplateWithAbi:@"test" bitecode:@"test" source:@"test" type:TokenType uuid:@"test" andName:nil];
    XCTAssertNil(model);
    
    model = [[ServiceLocator sharedInstance].templateManager createNewTemplateWithAbi:nil bitecode:@"test" source:@"test" type:TokenType uuid:@"test" andName:@"test"];
    XCTAssertNil(model);
}

@end
