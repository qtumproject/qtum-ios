//
//  CoreDataService.h
//  qtum wallet
//
//  Created by Fedorenko Nikita on 01.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WalletHistoryEntity;

@interface CoreDataService : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext* managedObjectContext;
- (void)saveWithcompletion:(void (^_Nullable)(BOOL contextDidSave, NSError *_Nullable error))complete;
- (WalletHistoryEntity *_Nonnull)createWalletHistoryEntityWith:(HistoryElement*_Nonnull) element;

@end
