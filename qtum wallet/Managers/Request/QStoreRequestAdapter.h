//
//  QStoreRequestAdapter.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QStoreCategory;
@class QStoreFullContractElement;

@interface QStoreRequestAdapter : NSObject

- (void)getContractsForCategory:(QStoreCategory *)category
             withSuccessHandler:(void(^)(QStoreCategory *updatedCategory))success
              andFailureHandler:(void(^)(NSError * error, NSString* message))failure;

- (void)getFullContractById:(NSString *)contractId
         withSuccessHandler:(void(^)(QStoreFullContractElement *contract))success
          andFailureHandler:(void(^)(NSError * error, NSString* message))failure;
@end
