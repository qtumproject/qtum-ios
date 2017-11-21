//
//  RemoveContractTrainigView.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 09.11.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RemoveContractTrainigViewDelegate <NSObject>

- (void)didTapOnView;

@end

@interface RemoveContractTrainigView : UIView

@property (weak, nonatomic) id <RemoveContractTrainigViewDelegate> delegate;

@end
