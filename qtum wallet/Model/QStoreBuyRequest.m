//
//  QStoreBuyRequest.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 11.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreBuyRequest.h"

NSString *const QStoreBuyRequestStateKey = @"state";
NSString *const QStoreBuyRequestContractIdKey = @"contract_id";
NSString *const QStoreBuyRequestAddressKey = @"address";
NSString *const QStoreBuyRequestRequestIdKey = @"request_id";
NSString *const QStoreBuyRequestAccessTokenKey = @"access_token";
NSString *const QStoreBuyRequestAmountStringKey = @"amount";

@interface QStoreBuyRequest() <NSCoding>

@property (nonatomic) NSString *contractId;
@property (nonatomic) NSString *addressString;
@property (nonatomic) NSString *requestId;
@property (nonatomic) NSString *accessToken;
@property (nonatomic) NSString *amountString;

@end

@implementation QStoreBuyRequest

+ (QStoreBuyRequest *)createFromDictionary:(NSDictionary *)dictionary andContractId:(NSString *)contractId {
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
    
    request.state = QStoreBuyRequestStateInPayment;
    
    return request;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.state forKey:QStoreBuyRequestStateKey];
    [aCoder encodeObject:self.contractId forKey:QStoreBuyRequestContractIdKey];
    [aCoder encodeObject:self.addressString forKey:QStoreBuyRequestAddressKey];
    [aCoder encodeObject:self.requestId forKey:QStoreBuyRequestRequestIdKey];
    [aCoder encodeObject:self.accessToken forKey:QStoreBuyRequestAccessTokenKey];
    [aCoder encodeObject:self.amountString forKey:QStoreBuyRequestAmountStringKey];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    QStoreBuyRequestState state = [aDecoder decodeIntegerForKey:QStoreBuyRequestStateKey];
    NSString *contractId = [aDecoder decodeObjectForKey:QStoreBuyRequestContractIdKey];
    NSString *address = [aDecoder decodeObjectForKey:QStoreBuyRequestAddressKey];
    NSString *requestId = [aDecoder decodeObjectForKey:QStoreBuyRequestRequestIdKey];
    NSString *accessToken = [aDecoder decodeObjectForKey:QStoreBuyRequestAccessTokenKey];
    NSString *amountString = [aDecoder decodeObjectForKey:QStoreBuyRequestAmountStringKey];
    
    QStoreBuyRequest *request = [QStoreBuyRequest new];
    request.addressString = address;
    request.requestId = requestId;
    request.accessToken = accessToken;
    request.amountString = amountString;
    request.contractId = contractId;
    
    request.state = state;
    
    return request;
}

@end
