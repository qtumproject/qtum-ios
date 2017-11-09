//
//  RemoveContractTrainigView.m
//  qtum wallet
//
//  Created by Никита Федоренко on 09.11.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "RemoveContractTrainigView.h"

@implementation RemoveContractTrainigView

- (IBAction)didTapOnView:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didTapOnView)]) {
        
        [self.delegate didTapOnView];
    }
}

@end
