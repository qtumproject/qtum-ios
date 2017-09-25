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

@implementation TokenPropertyCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

-(void)setupWithObject:(AbiinterfaceItem*)object andToken:(Contract*) token {
    
    self.propertyValue.hidden = YES;
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    self.propertyName.text = object.name;
    
    NSString* hashFuction = [[ContractInterfaceManager sharedInstance] stringHashOfFunction:object];
    __weak __typeof(self)weakSelf = self;
    [[ApplicationCoordinator sharedInstance].requestManager callFunctionToContractAddress:token.contractAddress withHashes:@[hashFuction] withHandler:^(id responseObject) {
        
        if (![responseObject isKindOfClass:[NSError class]]) {
            NSString* data = responseObject[@"items"][0][@"output"];
            
            NSArray* array = [[ContractArgumentsInterpretator sharedInstance] аrrayFromContractArguments:[NSString dataFromHexString:data] andInterface:object];
            
            NSMutableString* result = [NSMutableString new];
            for (id output in array) {
                [result appendFormat:@"%@",output];
            }
            weakSelf.activityIndicator.hidden = YES;
            weakSelf.propertyValue.hidden = NO;
            weakSelf.propertyValue.text = result;
        }

    }];
}

@end
