//
//  QueryFunctionView.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.11.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextFieldWithLineLightSend;

@protocol QueryFunctionViewDelegate <NSObject>

- (void)didQueryButtonPressed;

@end

@interface QueryFunctionView : UIView

@property (weak, nonatomic) IBOutlet UIButton *queryButton;
@property (weak, nonatomic) IBOutlet UIButton *repeateQueryButton;

-(void)fadeOutView:(UIView *) view;
-(void)fadeInView:(UIView *) view;

///
-(void)setResult:(NSString*) queryResult;
-(void)changeStateToRepeating;
-(void)changeStateToNormal;

@property (weak, nonatomic) id <QueryFunctionViewDelegate> delegate;

@end
