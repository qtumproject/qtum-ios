//
//  ServiceLocator.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 18.09.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TemplateManager.h"
#import "BackupFileManager.h"
#import "ContractArgumentsInterpretator.h"
#import "ContractFileManager.h"
#import "ContractInterfaceManager.h"
#import "DataOperation.h"
#import "ImageLoader.h"
#import "NotificationManager.h"
#import "OpenURLManager.h"
#import "TransactionManager.h"
#import "AppSettings.h"
#import "NewsDataProvider.h"


@interface ServiceLocator : NSObject

@property (strong, nonatomic) TemplateManager* templateManager;
@property (strong, nonatomic) BackupFileManager* backupFileManager;
@property (strong, nonatomic) ContractArgumentsInterpretator* contractArgumentsInterpretator;
@property (strong, nonatomic) ContractFileManager* contractFileManager;
@property (strong, nonatomic) ContractInterfaceManager* contractInterfaceManager;
@property (strong, nonatomic) DataOperation* dataOperation;
@property (strong, nonatomic) ImageLoader* imageLoader;
@property (strong, nonatomic) NotificationManager* notificationManager;
@property (strong, nonatomic) OpenURLManager* openURLManager;
@property (strong, nonatomic) TransactionManager* transactionManager;
@property (strong, nonatomic) AppSettings* appSettings;
@property (strong, nonatomic) NewsDataProvider* newsDataProvider;


+ (instancetype)sharedInstance;
- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

@end
