//
//  RecieptDTO.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 08.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Log+CoreDataProperties.h"
#import "ValueRepresentationEntity.h"

@interface RecieptLogDTO : NSObject

@property (strong, nonatomic) NSString* contractAddress;
@property (strong, nonatomic) NSArray<ValueRepresentationEntity*>* data;
@property (strong, nonatomic) NSArray<ValueRepresentationEntity*>* topics;

-(instancetype)initWithLog:(Log*) log;

@end
