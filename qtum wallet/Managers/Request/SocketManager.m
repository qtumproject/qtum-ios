//
//  SocketManager.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 24.03.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "SocketManager.h"
#import "QStoreManager.h"

NSString *const kSocketDidConnect = @"kSocketDidConnect";
NSString *const kSocketDidDisconnect = @"kSocketDidDisconnect";

@import SocketIO;

@interface SocketManager ()

@property (strong, nonatomic) SocketIOClient *currentSocket;
@property (assign, nonatomic) ConnectionStatus status;
@property (nonatomic, copy) void (^onConnected)(void);
@property (nonatomic, strong) NSOperationQueue *requestQueue;

@end

@implementation SocketManager

- (instancetype)init {

	self = [super init];
	if (self) {
		_requestQueue = [[NSOperationQueue alloc] init];
		_requestQueue.maxConcurrentOperationCount = 1;
		[self startAndSubscribeWithHandler:nil];
	}
	return self;
}

#pragma mark - Setter/Getter

- (void)setStatus:(ConnectionStatus) status {

	_status = status;

	switch (_status) {
		case Connected:
			[[NSNotificationCenter defaultCenter] postNotificationName:kSocketDidConnect object:nil];
			break;
		case Disconnected:
			[[NSNotificationCenter defaultCenter] postNotificationName:kSocketDidDisconnect object:nil];
			break;
		case Reconnecting:
			[[NSNotificationCenter defaultCenter] postNotificationName:kSocketDidDisconnect object:nil];
			break;
		default:
			break;
	}
}

- (NSString *)baseURL {

	return SLocator.appSettings.baseURL;
}

- (void)startAndSubscribeWithHandler:(void (^)(void)) handler {

	__weak __typeof (self) weakSelf = self;

	dispatch_block_t block = ^{

		NSURL *url = [[NSURL alloc] initWithString:[self baseURL]];
		weakSelf.currentSocket = [[SocketIOClient alloc] initWithSocketURL:url config:@{@"log": @YES, @"forcePolling": @YES}];
		weakSelf.onConnected = handler;

		dispatch_semaphore_t semaphore = dispatch_semaphore_create (0);

		[weakSelf.currentSocket on:@"connect" callback:^(NSArray *data, SocketAckEmitter *ack) {

			weakSelf.status = Connected;

			static dispatch_once_t onceToken;
			dispatch_once (&onceToken, ^{
				[weakSelf subscribeToEvents];
			});

			dispatch_semaphore_signal (semaphore);

			if (weakSelf.onConnected) {
				weakSelf.onConnected ();
			}
		}];

		[weakSelf.currentSocket connect];

		dispatch_semaphore_wait (semaphore, DISPATCH_TIME_FOREVER);
	};

	[_requestQueue addOperationWithBlock:block];
}

- (void)subscripeToUpdateWalletAdresses:(NSArray *) addresses {

	dispatch_block_t block = ^{

		NSString *token = [SLocator.notificationManager token];
		NSString *prevToken = [SLocator.notificationManager prevToken];

		[self.currentSocket emit:@"subscribe" with:@[@"balance_subscribe", addresses, @{@"notificationToken": token ? : [NSNull null],
				@"prevToken": prevToken ? : [NSNull null],
				@"language": [LanguageManager currentLanguageCode]}]];
	};

	[_requestQueue addOperationWithBlock:block];
}

- (void)subscribeToEvents {

	__weak __typeof (self) weakSelf = self;

	[self.currentSocket on:@"balance_changed" callback:^(NSArray *data, SocketAckEmitter *ack) {

		NSAssert([data isKindOfClass:[NSArray class]], @"result must be an array");
		[SLocator.walletManager updateSpendablesBalansesWithObject:[self.delegate.adapter adaptiveDataForBalance:data[0]]];
	}];

	[self.currentSocket on:@"new_transaction" callback:^(NSArray *data, SocketAckEmitter *ack) {

		NSAssert([data isKindOfClass:[NSArray class]], @"result must be an array");
		[SLocator.walletManager updateSpendablesHistoriesWithObject:(NSDictionary *)data[0]];
		[SLocator.notificationManager createLocalNotificationWithString:@"New Transaction" andIdentifire:@"new_transaction"];
	}];

	[self.currentSocket on:@"token_balance_change" callback:^(NSArray *data, SocketAckEmitter *ack) {

		[[ContractManager sharedInstance] updateTokenWithContractAddress:data[0][@"contract_address"] withAddressBalanceDictionary:data[0]];
	}];

	[self.currentSocket on:@"disconnect" callback:^(NSArray *data, SocketAckEmitter *ack) {
		weakSelf.status = Disconnected;
	}];

	[self.currentSocket on:@"reconnect" callback:^(NSArray *data, SocketAckEmitter *ack) {
		weakSelf.status = Reconnecting;
	}];

	[self.currentSocket on:@"contract_purchase" callback:^(NSArray *data, SocketAckEmitter *ack) {

		NSAssert([data isKindOfClass:[NSArray class]], @"result must be an array");
		[[QStoreManager sharedInstance] updateContractRequestsWithDict:data[0]];
		DLog(@"%@", data[0]);
	}];
}

- (void)stoptWithHandler:(void (^)(void)) handler {

	NSString *token = [SLocator.notificationManager token];
	[self.currentSocket emit:@"unsubscribe" with:@[@"balance_subscribe", [NSNull null], @{@"notificationToken": token ? : [NSNull null]}]];
	[self.currentSocket emit:@"unsubscribe" with:@[@"token_balance_change", [NSNull null], @{@"notificationToken": token ? : [NSNull null]}]];
	// [self.currentSocket disconnect];
}

- (void)startObservingToken:(Contract *) token withHandler:(void (^)(void)) handler {

	__weak __typeof (self) weakSelf = self;
	__weak __typeof (Contract * ) weakToken = token;
	NSString *deviceToken = [SLocator.notificationManager token];
	NSString *prevToken = [SLocator.notificationManager prevToken];
	dispatch_block_t block = ^{
		if (weakToken) {
			[weakSelf.currentSocket emit:@"subscribe" with:@[@"token_balance_change", @{@"contract_address": weakToken.contractAddress, @"addresses": [[SLocator.walletManager hashTableOfKeys] allKeys]}, @{@"notificationToken": deviceToken ? : [NSNull null],
					@"prevToken": prevToken ? : [NSNull null],
					@"language": [LanguageManager currentLanguageCode]}]];
		}
	};

	[_requestQueue addOperationWithBlock:block];
}

- (void)stopObservingToken:(Contract *) token withHandler:(void (^)(void)) handler {

	__weak __typeof (self) weakSelf = self;
	__weak __typeof (Contract * ) weakToken = token;
	NSString *deviceToken = [SLocator.notificationManager token];
	dispatch_block_t block = ^{
		if (weakToken) {
			[weakSelf.currentSocket emit:@"subscribe" with:@[@"token_balance_change", @{@"contract_address": weakToken.contractAddress, @"addresses": [[SLocator.walletManager hashTableOfKeys] allKeys]}, @{@"notificationToken": deviceToken ? : [NSNull null]}]];
		}
	};
	[_requestQueue addOperationWithBlock:block];
}

- (void)startObservingContractPurchase:(NSString *) requestId withHandler:(void (^)(void)) handler {

	__weak __typeof (self) weakSelf = self;
	dispatch_block_t block = ^{
		[weakSelf.currentSocket emit:@"subscribe" with:@[@"contract_purchase", requestId]];
	};
	[_requestQueue addOperationWithBlock:block];
}

- (void)stopObservingContractPurchase:(NSString *) requestId withHandler:(void (^)(void)) handler {

	__weak __typeof (self) weakSelf = self;
	dispatch_block_t block = ^{
		[weakSelf.currentSocket emit:@"unsubscribe" with:@[@"contract_purchase", requestId]];
	};
	[_requestQueue addOperationWithBlock:block];
}


@end
