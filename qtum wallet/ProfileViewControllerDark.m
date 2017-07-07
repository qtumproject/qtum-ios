//
//  ProfileViewControllerDark.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 07.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "ProfileViewControllerDark.h"
#import "ProfileTableViewCell.h"

@interface ProfileViewControllerDark ()

@end

@implementation ProfileViewControllerDark

#pragma mark - Setters/Getters

-(UIView *)getFooterView {
    UIView* footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 13)];
    footer.backgroundColor = [UIColor colorWithRed:36/255. green:41/255. blue:49/255. alpha:1];
    return footer;
}

-(UIView *)getHighlightedView {
    UIView * selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor:customRedColor()];
    return selectedBackgroundView;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProfileTableViewCell* cell = (ProfileTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (![cell.reuseIdentifier isEqualToString:switchCellReuseIdentifire]) {
        cell.profileCellImage.tintColor = customBlackColor();
        cell.profileCellTextLabel.textColor = customBlackColor();
        cell.diclousereImageView.tintColor = customBlackColor();
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProfileTableViewCell* cell = (ProfileTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (![cell.reuseIdentifier isEqualToString:switchCellReuseIdentifire]) {
        cell.profileCellImage.tintColor = customBlueColor();
        cell.profileCellTextLabel.textColor = customBlueColor();
        cell.diclousereImageView.tintColor = customBlueColor();
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfileTableViewCell *cell = (ProfileTableViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    cell.diclousereImageView.tintColor = customBlueColor();
    
    return cell;
}

@end
