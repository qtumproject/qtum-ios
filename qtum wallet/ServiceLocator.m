//
//  ServiceLocator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 18.09.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "ServiceLocator.h"
#import "RequestManager.h"

@implementation ServiceLocator

+ (instancetype)sharedInstance {
    
    static ServiceLocator *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] initUniqueInstance];
    });
    return instance;
}

- (instancetype)initUniqueInstance {
    
    self = [super init];
    
    if (self != nil) {
        _backupFileManager = [BackupFileManager new];
        _templateManager = [TemplateManager new];
        _contractArgumentsInterpretator = [ContractArgumentsInterpretator new];
        _contractFileManager = [ContractFileManager new];
        _contractInterfaceManager = [ContractInterfaceManager new];
        _dataOperation = [DataOperation new];
        _imageLoader = [ImageLoader new];
        _notificationManager = [NotificationManager new];
        _openURLManager = [OpenURLManager new];
        _transactionManager = [TransactionManager new];
        _appSettings = [AppSettings new];
        _newsDataProvider = [NewsDataProvider new];
        _requestManager = [RequestManager new];
        
    }
    return self;
}

@end
