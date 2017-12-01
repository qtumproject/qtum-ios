//
//  QueryFunctionView.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.11.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QueryFunctionView.h"
#import "TextFieldWithLineLightSend.h"

@interface QueryFunctionView ()

@property (weak, nonatomic) TextFieldWithLineLightSend *queryResultTextView;
@property (assign, nonatomic) BOOL isRepeatingState;

@end

@implementation QueryFunctionView

-(void)setResult:(NSString*) queryResult {

    [self changeStateToRepeating];
    self.queryResultTextView.text = queryResult;
}

- (IBAction)queryButtonDidPressed:(id)sender {
    
    [self.delegate didQueryButtonPressed];
}

- (IBAction)queryRepeateButtonDidPressed:(id)sender {
    
    [self.delegate didQueryButtonPressed];
}

-(void)changeStateToRepeating {
    
    if (self.isRepeatingState) {
        return;
    }
    
    self.isRepeatingState = YES;
    [self setReapeatingState];
}

- (void)setNotmalState {
    [self fadeInView:self.queryButton];
    [self fadeOutView:self.repeateQueryButton];
    [self fadeOutView:self.queryResultTextView];
}

-(void)setReapeatingState {
    
    [self fadeOutView:self.queryButton];
    [self fadeInView:self.repeateQueryButton];
    [self fadeInView:self.queryResultTextView];
}

-(void)changeStateToNormal {
    
    if (!self.isRepeatingState) {
        return;
    }
    self.isRepeatingState = NO;

    [self setNotmalState];
}

-(void)fadeOutView:(UIView *) view {
    
    [UIView animateWithDuration:0.2 animations:^{
        view.alpha = 0;
    } completion:^(BOOL finished) {
        view.hidden = YES;
    }];
}

-(void)fadeInView:(UIView *) view {
    
    view.hidden = NO;

    [UIView animateWithDuration:0.2 animations:^{
        view.alpha = 1;
    }];
}

@end
