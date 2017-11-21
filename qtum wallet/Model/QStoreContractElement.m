//
//  QStoreContractElement.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 11.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QStoreContractElement.h"
#import "NSUserDefaults+Settings.h"

// Short
NSString *const QStoreContractElementIdKey = @"_id";
NSString *const QStoreContractElementNameKey = @"name";
NSString *const QStoreContractElementPriceStringKey = @"price";
NSString *const QStoreContractElementCountBuyKey = @"count_buy";
NSString *const QStoreContractElementCountDownloadsKey = @"count_downloads";
NSString *const QStoreContractElementCreatedAtKey = @"created_at";
NSString *const QStoreContractElementTypeStringKey = @"type";

// Full
NSString *const QStoreContractElementContractDescriptionKey = @"description";
NSString *const QStoreContractElementPublisherAddressKey = @"publisher_address";
NSString *const QStoreContractElementSizeKey = @"size";
NSString *const QStoreContractElementCompletedOnKey = @"completed_on";
NSString *const QStoreContractElementTagsKey = @"tags";
NSString *const QStoreContractElementWithSourseCodeKey = @"with_source_code";

@interface QStoreContractElement ()

// Short
@property (nonatomic) QStoreElementState elementState;
@property (nonatomic) NSString *idString;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *priceString;
@property (nonatomic) NSNumber *countBuy;
@property (nonatomic) NSNumber *countDownloads;
@property (nonatomic) NSDate *createdAt;
@property (nonatomic) NSString *typeString;
@property (nonatomic) TemplateType type;

// Full
@property (nonatomic) NSString *contractDescription;
@property (nonatomic) NSString *publisherAddress;
@property (nonatomic) NSString *size;
@property (nonatomic) NSString *completedOn;
@property (nonatomic) NSArray<NSString *> *tags;
@property (nonatomic) BOOL withSourseCode;

@end

@implementation QStoreContractElement

- (instancetype)initWithIdString:(NSString *) idString
							name:(NSString *) name
					 priceString:(NSString *) priceString
						countBuy:(NSNumber *) countBuy
				  countDownloads:(NSNumber *) countDownloads
					   createdAt:(NSDate *) createdAt
					  typeString:(NSString *) typeString {

	self = [super init];
	if (self) {
		_idString = idString;
		_name = name;
		_priceString = priceString;
		_countBuy = countBuy;
		_countDownloads = countDownloads;
		_createdAt = createdAt;
		_typeString = typeString;
		_type = [self getTypeByString:typeString];
		_elementState = QStoreElementStateCategory;
	}
	return self;
}

- (instancetype)initWithIdString:(NSString *) idString
							name:(NSString *) name
					 priceString:(NSString *) priceString
						countBuy:(NSNumber *) countBuy
				  countDownloads:(NSNumber *) countDownloads
					   createdAt:(NSDate *) createdAt
					  typeString:(NSString *) typeString
			 contractDescription:(NSString *) contractDescription
				publisherAddress:(NSString *) publisherAddress
							size:(NSString *) size
					 completedOn:(NSString *) completedOn
							tags:(NSArray<NSString *> *) tags
				  withSourseCode:(BOOL) withSourseCode {

	self = [self initWithIdString:idString name:name priceString:priceString countBuy:countBuy countDownloads:countDownloads createdAt:createdAt typeString:typeString];
	if (self) {
		_contractDescription = contractDescription;
		_publisherAddress = publisherAddress;
		_size = size;
		_completedOn = completedOn;
		_tags = tags;
		_withSourseCode = withSourseCode;
		_elementState = QStoreElementStateFull;
	}
	return self;
}

- (instancetype)initWithIdString:(NSString *) idString
							name:(NSString *) name
					 priceString:(NSString *) priceString
						countBuy:(NSNumber *) countBuy
				  countDownloads:(NSNumber *) countDownloads
					   createdAt:(NSDate *) createdAt
					  typeString:(NSString *) typeString
							tags:(NSArray<NSString *> *) tags {

	self = [self initWithIdString:idString name:name
					  priceString:priceString
						 countBuy:countBuy
				   countDownloads:countDownloads
						createdAt:createdAt
					   typeString:typeString];
	if (self) {
		_tags = tags;
		_elementState = QStoreElementStateSearch;
	}
	return self;
}

- (TemplateType)getTypeByString:(NSString *) stringType {

	if ([stringType isEqualToString:@"Crowdsale"]) {
		return CrowdsaleType;
	}

	if ([stringType isEqualToString:@"QRC20 Token"]) {
		return TokenType;
	}

	return UndefinedContractType;
}

- (NSString *)getImageNameByType {

	if ([NSUserDefaults isDarkSchemeSetting]) {
		switch (self.type) {
			case TokenType:
				return @"QRC20 Token";
			case CrowdsaleType:
				return @"Crowdsale";
			default:
				return @"Smart Contract";
		};
	} else {
		switch (self.type) {
			case TokenType:
				return @"QRC20 Token-light";
			case CrowdsaleType:
				return @"Crowdsale-light";
			default:
				return @"Smart Contract-light";
		};
	}
}

- (void)updateWithFullDictionary:(NSDictionary *) dictionary {

	self.contractDescription = [dictionary objectForKey:QStoreContractElementContractDescriptionKey];
	self.publisherAddress = [dictionary objectForKey:QStoreContractElementPublisherAddressKey];
	self.size = [dictionary objectForKey:QStoreContractElementSizeKey];
	self.completedOn = [dictionary objectForKey:QStoreContractElementCompletedOnKey];
	self.tags = [dictionary objectForKey:QStoreContractElementTagsKey];
	self.withSourseCode = [[dictionary objectForKey:QStoreContractElementWithSourseCodeKey] boolValue];

	self.elementState = QStoreElementStateFull;
}

- (void)updateWithSearchDictionary:(NSDictionary *) dictionary {
	self.tags = [dictionary objectForKey:QStoreContractElementTagsKey];
	self.elementState = QStoreElementStateFull;
}

#pragma mark - Create

+ (QStoreContractElement *)createFromCategoryDictionary:(NSDictionary *) dictionary {

	if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]]) {
		return nil;
	}

	NSString *idString = [dictionary objectForKey:QStoreContractElementIdKey];
	NSString *name = [dictionary objectForKey:QStoreContractElementNameKey];
	NSString *priceString = [dictionary objectForKey:QStoreContractElementPriceStringKey];
	NSNumber *countBuy = [dictionary objectForKey:QStoreContractElementCountBuyKey];
	NSNumber *countDownloads = [dictionary objectForKey:QStoreContractElementCountDownloadsKey];
	NSString *createdAtString = [dictionary objectForKey:QStoreContractElementCreatedAtKey];
	NSString *typeString = [dictionary objectForKey:QStoreContractElementTypeStringKey];

	NSDateFormatter *formatter = [NSDateFormatter new];
	[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"];
	NSDate *createdAt = [formatter dateFromString:createdAtString];

	QStoreContractElement *element = [[QStoreContractElement alloc] initWithIdString:idString
																				name:name
																		 priceString:priceString
																			countBuy:countBuy
																	  countDownloads:countDownloads
																		   createdAt:createdAt
																		  typeString:typeString];

	return element;
}

+ (QStoreContractElement *)createFromFullDictionary:(NSDictionary *) dictionary {

	if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]]) {
		return nil;
	}

	QStoreContractElement *shortElement = [QStoreContractElement createFromCategoryDictionary:dictionary];
	[shortElement updateWithFullDictionary:dictionary];

	return shortElement;
}

+ (QStoreContractElement *)createFromSearchDictionary:(NSDictionary *) dictionary {

	if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]]) {
		return nil;
	}

	QStoreContractElement *shortElement = [QStoreContractElement createFromCategoryDictionary:dictionary];
	[shortElement updateWithSearchDictionary:dictionary];

	return shortElement;
}

@end
