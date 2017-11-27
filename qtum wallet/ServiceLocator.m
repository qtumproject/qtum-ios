//
//  ServiceLocator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 18.09.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "WalletManager.h"
#import "PopupFactory.h"

@implementation ServiceLocator

+ (instancetype)sharedInstance {

	static ServiceLocator *instance;
	static dispatch_once_t onceToken;
	dispatch_once (&onceToken, ^{
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
		_newsFacedeService = [NewsFacedeService new];
		_controllersFactory = [ControllersFactory new];
		_requestManager = [[RequestManager alloc] initWithBaseUrl:_appSettings.baseURL];
		_walletManager = [WalletManager new];
		_contractInfoFacade = [ContractInfoFacade new];
		_sourceCodeFormatService = [SourceCodeFormatService new];
	}
	return self;
}

#pragma mark - Lazy

- (ContractManager *)contractManager {

	if (!_contractManager) {
		_contractManager = [ContractManager new];
	}
	return _contractManager;
}

- (TouchIDService *)touchIDService {

	if (!_touchIDService) {
		_touchIDService = [TouchIDService new];
	}
	return _touchIDService;
}

- (PaymentValuesManager *)paymentValuesManager {

	if (!_paymentValuesManager) {
		_paymentValuesManager = [PaymentValuesManager new];
	}
	return _paymentValuesManager;
}

- (PopupService *)popupService {

	if (!_popupService) {
		_popupService = [PopupService new];
	}
	return _popupService;
}

- (TableSourcesFactory *)tableSourcesFactory {

	if (!_tableSourcesFactory) {
		_tableSourcesFactory = [TableSourcesFactory new];
	}
	return _tableSourcesFactory;
}

- (QStoreManager *)qStoreManager {

	if (!_qStoreManager) {
		_qStoreManager = [QStoreManager new];
	}
	return _qStoreManager;
}

- (WalletsFactory *)walletsFactory {

	if (!_walletsFactory) {
		_walletsFactory = [WalletsFactory new];
	}
	return _walletsFactory;
}

- (iOSSessionManager *)iOSSessionManager {

	if (!_iOSSessionManager) {
		_iOSSessionManager = [iOSSessionManager new];
	}
	return _iOSSessionManager;
}

- (ValidationInputService *)validationInputService {
    
    if (!_validationInputService) {
        _validationInputService = [[ValidationInputService alloc] initWithRegexProvider:[ValidationRegexProvider new]];
    }
    return _validationInputService;
}

- (id <PopupFactoryProtocol>)popupFactory {
    
    if (!_popupFactory) {
        _popupFactory = [PopupFactory new];
    }
    return _popupFactory;
}

-(WatchTokensFacadeService*)watchTokensFacadeService {
    
    if (!_watchTokensFacadeService) {
        _watchTokensFacadeService = [WatchTokensFacadeService new];
    }
    return _watchTokensFacadeService;
}


@end
