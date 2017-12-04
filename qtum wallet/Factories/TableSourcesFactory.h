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

- (WalletTableSource *)createWalletSource;

- (NSObject <ChooseTokenPaymentDelegateDataSourceProtocol> *)createSendTokenPaymentSource;

- (NSObject <LibraryTableSourceOutput> *)createLibrarySource;

- (NSObject <FavouriteTemplatesCollectionSourceOutput> *)createFavouriteTemplatesSource;

- (NSObject <TokenDetailDataDisplayManager> *)createTokenDetailSource;

- (NSObject <SubscribeTokenDataDisplayManagerProtocol> *)createSubscribeTokenDataDisplayManager;

@end
