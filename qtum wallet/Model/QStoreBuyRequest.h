//
//  QStoreBuyRequest.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 11.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, QStoreBuyRequestState) {
    QStoreBuyRequestStateInPayment,
    QStoreBuyRequestStateIsPaid
};

@interface QStoreBuyRequest : NSObject

@property (nonatomic) QStoreBuyRequestState state;
@property (nonatomic, readonly) NSString *contractId;
@property (nonatomic, readonly) NSString *addressString;
@property (nonatomic, readonly) NSString *requestId;
@property (nonatomic, readonly) NSString *accessToken;
@property (nonatomic, readonly) NSString *amountString;

+ (QStoreBuyRequest *)createFromDictionary:(NSDictionary *)dictionary andContractId:(NSString *)contractId;

@end
