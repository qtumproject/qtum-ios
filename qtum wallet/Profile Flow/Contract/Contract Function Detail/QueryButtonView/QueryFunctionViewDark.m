//
//  QueryFunctionViewDark.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.11.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QueryFunctionViewDark.h"

@interface QueryFunctionViewDark ()

@property (weak, nonatomic) IBOutlet UILabel *queryLabel;
@property (weak, nonatomic) IBOutlet UIView *queryTextBackView;

@end

@implementation QueryFunctionViewDark

-(void)setResult:(NSString*) queryResult {
    
    self.queryLabel.text = queryResult;
    [self changeStateToRepeating];
}

- (void)setNotmalState {
    
    [self fadeInView:self.queryButton];
    [self fadeOutView:self.repeateQueryButton];
    [self fadeOutView:self.queryTextBackView];
}

-(void)setReapeatingState {
    
    [self fadeOutView:self.queryButton];
    [self fadeInView:self.repeateQueryButton];
    [self fadeInView:self.queryTextBackView];
}

@end
