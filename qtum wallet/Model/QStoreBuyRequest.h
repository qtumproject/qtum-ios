//
//  QStoreBuyRequest.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 11.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, QStoreBuyRequestState) {
	QStoreBuyRequestStateInPayment,
	QStoreBuyRequestStateIsPaid
};

extern NSString *const QStoreBuyRequestStateKey;
extern NSString *const QStoreBuyRequestContractIdKey;
extern NSString *const QStoreBuyRequestAddressKey;
extern NSString *const QStoreBuyRequestRequestIdKey;
extern NSString *const QStoreBuyRequestAccessTokenKey;
extern NSString *const QStoreBuyRequestAmountStringKey;
extern NSString *const QStoreBuyRequestCreateDateStringKey;
extern NSString *const QStoreBuyRequestPayDateStringKey;
extern NSString *const QStoreBuyRequestProductNameKey;
extern NSString *const QStoreBuyRequestProductTypeKey;

@interface QStoreBuyRequest : NSObject

@property (nonatomic) QStoreBuyRequestState state;
@property (nonatomic, readonly) NSString *contractId;
@property (nonatomic, readonly) NSString *addressString;
@property (nonatomic, readonly) NSString *requestId;
@property (nonatomic, readonly) NSString *accessToken;
@property (nonatomic, readonly) NSString *amountString;
@property (nonatomic, readonly) NSString *createDateString;
@property (nonatomic, readonly) NSString *payDateString;
@property (nonatomic, readonly) NSString *templateName;
@property (nonatomic, readonly) TemplateType templateType;

- (NSNumber *)getAmountNumber;

+ (QStoreBuyRequest *)createFromDictionary:(NSDictionary *) dictionary
							 andContractId:(NSString *) contractId
						   withProductName:(NSString *) productName
						   withProductType:(TemplateType) productType;

- (QStoreBuyRequest *)upateFromDictionary:(NSDictionary *) dictionary;

@end
