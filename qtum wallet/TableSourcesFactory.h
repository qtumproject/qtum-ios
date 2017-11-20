//
//  TableSourcesFactory.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 05.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WalletTableSource;
@protocol ChooseTokenPaymentDelegateDataSourceProtocol;
@protocol LibraryTableSourceOutput;
@protocol FavouriteTemplatesCollectionSourceOutput;
@protocol NewsTableSourceOutput;
@protocol TokenDetailDataDisplayManager;
@protocol SubscribeTokenDataDisplayManagerProtocol;


@interface TableSourcesFactory : NSObject

+ (instancetype)sharedInstance;

- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));

+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));

+ (instancetype)new __attribute__((unavailable("new not available, call sharedInstance instead")));

- (WalletTableSource *)createWalletSource;

- (NSObject <ChooseTokenPaymentDelegateDataSourceProtocol> *)createSendTokenPaymentSource;

- (NSObject <LibraryTableSourceOutput> *)createLibrarySource;

- (NSObject <FavouriteTemplatesCollectionSourceOutput> *)createFavouriteTemplatesSource;

- (NSObject <TokenDetailDataDisplayManager> *)createTokenDetailSource;

- (NSObject <SubscribeTokenDataDisplayManagerProtocol> *)createSubscribeTokenDataDisplayManager;

@end
