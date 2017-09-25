//
//  QStoreBuyRequest.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 11.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QStoreBuyRequest.h"

NSString *const QStoreBuyRequestStateKey = @"state";
NSString *const QStoreBuyRequestContractIdKey = @"contract_id";
NSString *const QStoreBuyRequestAddressKey = @"address";
NSString *const QStoreBuyRequestRequestIdKey = @"request_id";
NSString *const QStoreBuyRequestAccessTokenKey = @"access_token";
NSString *const QStoreBuyRequestAmountStringKey = @"amount";
NSString *const QStoreBuyRequestCreateDateStringKey = @"created_at";
NSString *const QStoreBuyRequestPayDateStringKey = @"payed_at";
NSString *const QStoreBuyRequestProductNameKey = @"QStoreBuyRequestProductNameKey";
NSString *const QStoreBuyRequestProductTypeKey = @"QStoreBuyRequestProductTypeKey";

@interface QStoreBuyRequest() <NSCoding>

@property (copy, nonatomic) NSString *contractId;
@property (copy, nonatomic) NSString *addressString;
@property (copy, nonatomic) NSString *requestId;
@property (copy, nonatomic) NSString *accessToken;
@property (copy, nonatomic) NSString *amountString;
@property (copy, nonatomic) NSString *createDateString;
@property (copy, nonatomic) NSString *payDateString;
@property (nonatomic, copy) NSString *templateName;
@property (nonatomic, assign) TemplateType templateType;

@end

@implementation QStoreBuyRequest

+ (QStoreBuyRequest *)createFromDictionary:(NSDictionary *)dictionary
                             andContractId:(NSString *)contractId
                           withProductName:(NSString*)productName
                           withProductType:(TemplateType)productType {
    
    NSString *address = [dictionary objectForKey:QStoreBuyRequestAddressKey];
    NSString *requestId = [dictionary objectForKey:QStoreBuyRequestRequestIdKey];
    NSString *accessToken = [dictionary objectForKey:QStoreBuyRequestAccessTokenKey];
    NSString *amountString = [dictionary objectForKey:QStoreBuyRequestAmountStringKey];
    
    QStoreBuyRequest *request = [QStoreBuyRequest new];
    request.addressString = address;
    request.requestId = requestId;
    request.accessToken = accessToken;
    request.amountString = amountString;
    request.contractId = contractId;
    request.templateName = productName;
    request.templateType = productType;
    
    request.state = QStoreBuyRequestStateInPayment;
    
    return request;
}

- (QStoreBuyRequest *)upateFromDictionary:(NSDictionary *)dictionary {
    
    NSString *address = [dictionary objectForKey:QStoreBuyRequestAddressKey];
    NSString *requestId = [dictionary objectForKey:QStoreBuyRequestRequestIdKey];
    NSString *accessToken = [dictionary objectForKey:QStoreBuyRequestAccessTokenKey];
    NSString *amountString = [dictionary objectForKey:QStoreBuyRequestAmountStringKey];
    NSString *createDate = [dictionary objectForKey:QStoreBuyRequestCreateDateStringKey];
    NSString *payDate = [dictionary objectForKey:QStoreBuyRequestPayDateStringKey];
    NSString *contractId = [dictionary objectForKey:QStoreBuyRequestContractIdKey];

    self.addressString = address ?: self.addressString;
    self.requestId = requestId ?: self.requestId;
    self.accessToken = accessToken ?: self.accessToken;
    self.amountString = amountString ?: self.amountString;
    self.contractId = contractId ?: self.contractId;
    self.createDateString = createDate ?: self.createDateString;
    self.payDateString = (![payDate isKindOfClass:[NSNull class]] && payDate) ? payDate : nil;

    self.state = self.payDateString ? QStoreBuyRequestStateIsPaid : QStoreBuyRequestStateInPayment;
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeInteger:self.state forKey:QStoreBuyRequestStateKey];
    [aCoder encodeInteger:self.templateType forKey:QStoreBuyRequestProductTypeKey];
    [aCoder encodeObject:self.contractId forKey:QStoreBuyRequestContractIdKey];
    [aCoder encodeObject:self.addressString forKey:QStoreBuyRequestAddressKey];
    [aCoder encodeObject:self.requestId forKey:QStoreBuyRequestRequestIdKey];
    [aCoder encodeObject:self.accessToken forKey:QStoreBuyRequestAccessTokenKey];
    [aCoder encodeObject:self.amountString forKey:QStoreBuyRequestAmountStringKey];
    [aCoder encodeObject:self.createDateString forKey:QStoreBuyRequestCreateDateStringKey];
    [aCoder encodeObject:self.payDateString forKey:QStoreBuyRequestPayDateStringKey];
    [aCoder encodeObject:self.templateName forKey:QStoreBuyRequestProductNameKey];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    QStoreBuyRequestState state = [aDecoder decodeIntegerForKey:QStoreBuyRequestStateKey];
    TemplateType type = [aDecoder decodeIntegerForKey:QStoreBuyRequestProductTypeKey];
    NSString *contractId = [aDecoder decodeObjectForKey:QStoreBuyRequestContractIdKey];
    NSString *address = [aDecoder decodeObjectForKey:QStoreBuyRequestAddressKey];
    NSString *requestId = [aDecoder decodeObjectForKey:QStoreBuyRequestRequestIdKey];
    NSString *accessToken = [aDecoder decodeObjectForKey:QStoreBuyRequestAccessTokenKey];
    NSString *amountString = [aDecoder decodeObjectForKey:QStoreBuyRequestAmountStringKey];
    NSString *createDate = [aDecoder decodeObjectForKey:QStoreBuyRequestCreateDateStringKey];
    NSString *payDate = [aDecoder decodeObjectForKey:QStoreBuyRequestPayDateStringKey];
    NSString *templateName = [aDecoder decodeObjectForKey:QStoreBuyRequestProductNameKey];
    
    self = [super init];

    if (self) {

        _addressString = address;
        _requestId = requestId;
        _accessToken = accessToken;
        _amountString = amountString;
        _contractId = contractId;
        _state = state;
        _createDateString = createDate;
        _payDateString = payDate;
        _templateType = type;
        _templateName = templateName;
    }
    
    return self;
}

- (NSNumber *)getAmountNumber {
    
    return [NSDecimalNumber decimalNumberWithString:self.amountString];
}

@end
