//
//  TokenPropertyCell.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 23.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "TokenPropertyCell.h"
#import "ContractManager.h"
#import "ContractArgumentsInterpretator.h"

@implementation TokenPropertyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupWithObject:(AbiinterfaceItem*)object andToken:(Token*) token {
    
    self.propertyValue.hidden = YES;
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    self.propertyName.text = object.name;
    
    NSString* hashFuction = [[ContractManager sharedInstance] getStringHashOfFunction:object andParam:nil];
    __weak __typeof(self)weakSelf = self;
    [[ApplicationCoordinator sharedInstance].requestManager callFunctionToContractAddress:token.contractAddress withHashes:@[hashFuction] withHandler:^(id responseObject) {
        
        if (![responseObject isKindOfClass:[NSError class]]) {
            NSString* data = responseObject[@"items"][0][@"output"];
            NSArray* array = [ContractArgumentsInterpretator аrrayFromContractArguments:[NSString dataFromHexString:data] andInterface:object];
            
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
