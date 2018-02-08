//
//  RecieptLogDTO.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 08.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "RecieptLogDTO.h"
#import "EventLogHeader.h"

@implementation RecieptLogDTO

-(instancetype)initWithLog:(Log*) log {
    
    self = [super init];
    
    if (self) {
        [self setupWithReciept:log];
    }
    return self;
}

-(void)setupWithReciept:(Log*) log {
    
    self.contractAddress = log.address;
    NSMutableArray<ValueRepresentationEntity*>* topics = @[].mutableCopy;
    NSMutableArray<ValueRepresentationEntity*>* datas = @[].mutableCopy;

    for (NSString* topic in log.topics) {
        ValueRepresentationEntity* entity = [[ValueRepresentationEntity alloc] initWithHexString:topic];
        [topics addObject:entity];
    }
    
    NSMutableArray <NSString*>* dataStringsArray = @[].mutableCopy;
    NSString* dataString = [log.data copy];
    NSInteger size = 64;
    
    while (dataString.length > size) {
        
        [dataStringsArray addObject:[dataString substringToIndex:size]];
        dataString = [dataString substringFromIndex:size];
    }
    
    if (dataString.length > 0) {
        [dataStringsArray addObject:dataString];
    }
    
    for (NSString* data in dataStringsArray) {
        
        ValueRepresentationEntity* entity = [[ValueRepresentationEntity alloc] initWithHexString:data];
        [datas addObject:entity];
    }
    
    self.data = [datas copy];
    self.topics = [topics copy];
}


@end
