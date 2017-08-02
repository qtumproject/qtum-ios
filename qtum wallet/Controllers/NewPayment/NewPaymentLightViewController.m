//
//  NewPaymentLightViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 04.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "NewPaymentLightViewController.h"

@interface NewPaymentLightViewController ()

@end

@implementation NewPaymentLightViewController

//- (void)viewDidLoad {
//    
//    [super viewDidLoad];
//
//    self.sendButtomBottomOffset = 27;
//}
//
//#pragma mark - Keyboard
//
//-(void)keyboardWillShow:(NSNotification *)sender {
//    
//    NSDictionary *info = [sender userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//    
//    self.sendButtonTopConstraint.constant = 40.0f;
//    self.sendButtonBottomConstraint.constant = kbSize.height - 30.0f;
//    [self.view layoutIfNeeded];
//}
//
//-(void)keyboardDidShow:(NSNotification *)sender {
//    
//    if ([self.amountTextField isFirstResponder]) {
//        NSDictionary *info = [sender userInfo];
//        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//        CGFloat kbHeight = kbSize.height - 50.0f;
//        CGFloat topOfKeyboard = self.scrollView.frame.size.height - kbHeight;
//        
//        CGFloat bottomSend = self.sendButton.frame.size.height + self.sendButton.frame.origin.y;
//        
//        CGFloat forTopOffset = bottomSend - topOfKeyboard;
//        if (forTopOffset > 0) {
//            
//            CGPoint bottomOffset = CGPointMake(0, forTopOffset + 20);
//            [self.scrollView setContentOffset:bottomOffset animated:YES];
//        }
//    }
//}

@end
