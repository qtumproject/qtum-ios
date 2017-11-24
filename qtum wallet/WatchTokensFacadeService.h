//
//  WatchTokensFacadeService.h
//  qtum wallet
//
//  Created by Fedorenko Nikita on 24.11.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WatchTokenName)(NSString* name, NSError* error);

@interface WatchTokensFacadeService : NSObject

- (void)getTokenNameWithAddress:(NSString *) address withHandler:(WatchTokenName) handler;

- (BOOL)createTokenWithTokenName:(NSString*) name andAddress:(NSString*) address andErrorString:(NSString **) errorString;

@end
