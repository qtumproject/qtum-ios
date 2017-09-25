//
//  ProfileViewControllerLight.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 07.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ProfileViewControllerLight.h"
#import "ProfileTableViewCell.h"

@interface ProfileViewControllerLight ()

@end

@implementation ProfileViewControllerLight

#pragma mark - Setters/Getters

-(UIView *)getFooterView {
    UIView* footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 13)];
    footer.backgroundColor = lightBlueColor();
    return footer;
}

-(UIView *)getHighlightedView {
    UIView * selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor:lightBlueColor()];
    return selectedBackgroundView;
}

@end
