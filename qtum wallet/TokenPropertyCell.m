//
//  TokenPropertyCell.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 23.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TokenPropertyCell.h"
#import "ContractInterfaceManager.h"
#import "ContractArgumentsInterpretator.h"
#import "ServiceLocator.h"
#import "NSObject+Extension.h"

@interface TokenPropertyCell()

@property (strong, nonatomic) QTUMBigNumber* value;

@end

@implementation TokenPropertyCell

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGSize size = [self.propertyValue.text sizeWithAttributes:@{NSFontAttributeName : self.propertyValue.font}];
    if (size.width > self.propertyValue.bounds.size.width) {
        self.propertyValue.text = [self.value shortFormatOfNumber];
    }
}

-(void)setupWithObject:(AbiinterfaceItem*)object andToken:(Contract*) token {
    
    self.propertyValue.hidden = YES;
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    self.propertyName.text = object.name;
    
    NSString* hashFuction = [SLocator.contractInterfaceManager stringHashOfFunction:object];
    __weak __typeof(self)weakSelf = self;
    
    self.associatedObject = object.name;
    [[ApplicationCoordinator sharedInstance].requestManager callFunctionToContractAddress:token.contractAddress
                                                                             frommAddress:nil
                                                                               withHashes:@[hashFuction] withHandler:^(id responseObject) {
        
        if (![weakSelf.associatedObject isEqualToString:object.name]) {
           return;
        }
                                                                                   
        if (![responseObject isKindOfClass:[NSError class]]) {
            NSString* data = responseObject[@"items"][0][@"output"];
            
            NSArray* array = [SLocator.contractArgumentsInterpretator аrrayFromContractArguments:[NSString dataFromHexString:data] andInterface:object];
            
            NSMutableString* result = [NSMutableString new];
            for (id output in array) {
                if ([output isKindOfClass:[QTUMBigNumber class]]) {
                    self.value = output;
                }
                [result appendFormat:@"%@",output];
            }
            weakSelf.activityIndicator.hidden = YES;
            weakSelf.propertyValue.hidden = NO;
            weakSelf.propertyValue.text = result;
            [weakSelf setNeedsLayout];
            [weakSelf layoutIfNeeded];
        }

    }];
}

@end
