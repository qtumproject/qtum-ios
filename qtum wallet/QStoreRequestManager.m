//
//  QStoreRequestManager.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 22.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreRequestManager.h"

NSString *const kQStoreBuyRequests = @"kQStoreBuyRequests";
NSString *const kQStoreConfirmedBuyRequests = @"kQStoreConfirmedBuyRequests";
NSString *const kQStoreFinishedBuyRequests = @"kQStoreFinishedBuyRequests";

@interface QStoreRequestManager ()

@property (strong, nonatomic) NSMutableArray<QStoreBuyRequest *> *buyRequests;
@property (strong, nonatomic) NSMutableArray<QStoreBuyRequest *> *confirmedBuyRequests;
@property (strong, nonatomic) NSMutableArray<QStoreBuyRequest *> *finishedBuyRequests;
@property (strong, nonatomic) dispatch_queue_t writingQueue;

@end

@implementation QStoreRequestManager

#pragma mark - Init

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _buyRequests = @[].mutableCopy;
        _confirmedBuyRequests = @[].mutableCopy;
        _finishedBuyRequests = @[].mutableCopy;
        _writingQueue = dispatch_queue_create("com.example.pixelplex.qstore.requests", NULL);
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    NSMutableArray<QStoreBuyRequest *> *buyRequests = [aDecoder decodeObjectForKey:kQStoreBuyRequests];
    NSMutableArray<QStoreBuyRequest *> *confirmedBuyRequests = [aDecoder decodeObjectForKey:kQStoreConfirmedBuyRequests];
    NSMutableArray<QStoreBuyRequest *> *finishedBuyRequests = [aDecoder decodeObjectForKey:kQStoreFinishedBuyRequests];
    
    self = [super init];
    
    if (self) {
        
        _buyRequests = buyRequests ?: @[].mutableCopy;
        _confirmedBuyRequests = confirmedBuyRequests ?: @[].mutableCopy;
        _finishedBuyRequests = finishedBuyRequests ?: @[].mutableCopy;
        _writingQueue = dispatch_queue_create("com.example.pixelplex.qstore.requests", NULL);
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.buyRequests forKey:kQStoreBuyRequests];
    [aCoder encodeObject:self.confirmedBuyRequests forKey:kQStoreConfirmedBuyRequests];
    [aCoder encodeObject:self.finishedBuyRequests forKey:kQStoreFinishedBuyRequests];
}

#pragma mark - Requests Managing

-(void)addBuyRequest:(QStoreBuyRequest*) buyRequests completion:(void(^)()) completion {
    
    void(^completionCopy)() = [completion copy];

    dispatch_async(self.writingQueue, ^{
        
        [self.buyRequests addObject:buyRequests];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionCopy();
        });
    });
}

-(void)confirmBuyRequest:(QStoreBuyRequest*) buyRequests completion:(void(^)()) completion {
    
    void(^completionCopy)() = [completion copy];

    dispatch_async(self.writingQueue, ^{
        
        [self.confirmedBuyRequests addObject:buyRequests];
        [self.buyRequests removeObject:buyRequests];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionCopy();
        });
    });
}

-(void)finishBuyRequest:(QStoreBuyRequest*) buyRequests completion:(void(^)()) completion {
    
    void(^completionCopy)() = [completion copy];
    
    dispatch_async(self.writingQueue, ^{
        
        [self.finishedBuyRequests addObject:buyRequests];
        [self.confirmedBuyRequests removeObject:buyRequests];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionCopy();
        });
    });
}

- (QStoreBuyRequest*)requestWithContractId:(NSString*) contractId {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contractId == %@",contractId];
    NSArray <QStoreBuyRequest*> *requests  = [self.buyRequests filteredArrayUsingPredicate:predicate];
    
    if (requests.count > 0) {
        return requests[0];
    }
    
    requests  = [self.confirmedBuyRequests filteredArrayUsingPredicate:predicate];

    if (requests.count > 0) {
        return requests[0];
    }
    
    requests  = [self.finishedBuyRequests filteredArrayUsingPredicate:predicate];
    
    if (requests.count > 0) {
        return requests[0];
    }
    
    return nil;
}

- (QStoreBuyRequest *)requestByElement:(QStoreContractElement *)element {
    
    for (QStoreBuyRequest *request in self.buyRequests) {
        if ([request.contractId isEqualToString:element.idString]) {
            return request;
        }
    }
    return nil;
}

@end
