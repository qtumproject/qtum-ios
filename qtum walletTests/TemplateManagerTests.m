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

@property (strong, nonatomic) TemplateManager *templateManager;

@end

@implementation TemplateManagerTests

- (void)setUp {

	[super setUp];
	self.templateManager = [TemplateManager new];
}

- (void)tearDown {
	[super tearDown];
	[self.templateManager clear];

}

- (void)test_Standart_Pack {
	NSInteger countTemplates = [self.templateManager standartPackOfTemplates].count;
	NSInteger countTokenTemplates = [self.templateManager standartPackOfTokenTemplates].count;
	XCTAssertTrue(countTemplates == 3);
	XCTAssertTrue(countTokenTemplates == 3);
}

- (void)test_Clear {
	NSInteger countTemplates = [self.templateManager availebaleTemplates].count;
	NSInteger countTokenTemplates = [self.templateManager availebaleTokenTemplates].count;
	XCTAssertTrue(countTemplates == 3);
	XCTAssertTrue(countTokenTemplates == 3);
}

- (void)test_Add {
	NSInteger countTemplates = [self.templateManager availebaleTemplates].count;
	TemplateModel *model = [[self.templateManager standartPackOfTemplates] firstObject];
	[self.templateManager saveTemplate:model];
	NSInteger newCountTemplates = [self.templateManager availebaleTemplates].count;

	XCTAssertTrue(countTemplates + 1 == newCountTemplates);
}

- (void)test_Add_Nil {
	NSInteger countTemplates = [self.templateManager availebaleTemplates].count;
	[self.templateManager saveTemplate:nil];
	NSInteger newCountTemplates = [self.templateManager availebaleTemplates].count;

	XCTAssertTrue(countTemplates == newCountTemplates);
}

- (void)test_Decode {
	NSArray *data = [self.templateManager decodeDataForBackup];

	XCTAssertTrue(data.count == [self.templateManager availebaleTemplates].count);

	for (NSObject *object in data) {
		XCTAssertTrue([object isKindOfClass:[NSDictionary class]]);
	}
}

- (void)test_Encode {

	NSMutableArray *data = [[self.templateManager decodeDataForBackup] mutableCopy];
	NSArray *array = [self.templateManager encodeDataForBacup:data];

	XCTAssertTrue(data.count == array.count);

	for (NSObject *object in array) {
		XCTAssertTrue([object isKindOfClass:[TemplateModel class]]);
	}

	NSArray *array3 = [self.templateManager encodeDataForBacup:nil];
	XCTAssertTrue(array3.count == 0);

	[data addObject:[NSObject new]];
	NSArray *array2 = [self.templateManager encodeDataForBacup:data];
	XCTAssertTrue(data.count - 1 == array2.count);
}

- (void)test_Template_Token_Creation {

	TemplateModel *model = [self.templateManager createNewTokenTemplateWithAbi:@"test" contractAddress:@"test" andName:@"test"];
	XCTAssertNil(model);

	model = [self.templateManager createNewTokenTemplateWithAbi:@"test" contractAddress:nil andName:@"test"];
	XCTAssertNil(model);

	model = [self.templateManager createNewTokenTemplateWithAbi:@"test" contractAddress:@"test" andName:nil];
	XCTAssertNil(model);

	model = [self.templateManager createNewTokenTemplateWithAbi:nil contractAddress:@"test" andName:@"test"];
	XCTAssertNil(model);
}

- (void)test_Template_Contract_Creation {
	TemplateModel *model = [self.templateManager createNewContractTemplateWithAbi:@"test" contractAddress:@"test" andName:@"test"];
	XCTAssertNil(model);

	model = [self.templateManager createNewContractTemplateWithAbi:@"test" contractAddress:nil andName:@"test"];
	XCTAssertNil(model);

	model = [self.templateManager createNewContractTemplateWithAbi:@"test" contractAddress:@"test" andName:nil];
	XCTAssertNil(model);

	model = [self.templateManager createNewContractTemplateWithAbi:nil contractAddress:@"test" andName:@"test"];
	XCTAssertNil(model);
}

- (void)test_Template_Creation {

	TemplateModel *model = [self.templateManager createNewTemplateWithAbi:@"test" bitecode:@"test" source:@"test" type:TokenType uuid:@"test" andName:@"test"];
	XCTAssertNil(model);

	model = [self.templateManager createNewTemplateWithAbi:@"test" bitecode:nil source:@"test" type:TokenType uuid:@"test" andName:@"test"];
	XCTAssertNil(model);

	model = [self.templateManager createNewTemplateWithAbi:@"test" bitecode:@"test" source:nil type:TokenType uuid:@"test" andName:@"test"];
	XCTAssertNil(model);

	model = [self.templateManager createNewTemplateWithAbi:@"test" bitecode:@"test" source:@"test" type:TokenType uuid:nil andName:@"test"];
	XCTAssertNil(model);

	model = [self.templateManager createNewTemplateWithAbi:@"test" bitecode:@"test" source:@"test" type:TokenType uuid:@"test" andName:nil];
	XCTAssertNil(model);

	model = [self.templateManager createNewTemplateWithAbi:nil bitecode:@"test" source:@"test" type:TokenType uuid:@"test" andName:@"test"];
	XCTAssertNil(model);
}

@end
