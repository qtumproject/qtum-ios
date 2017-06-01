//
//  MainTokenTableViewCell.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 29.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "MainTokenTableViewCell.h"
#import "BalanceTokenView.h"

@interface MainTokenTableViewCell()

@property (nonatomic) NSMutableArray *views;
@property (nonatomic) NSMutableArray *topConstraints;
@property (nonatomic) NSMutableArray *heights;

@end

@implementation MainTokenTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.topConstraints = [NSMutableArray new];
        self.views = [NSMutableArray new];
        self.heights = [NSMutableArray new];
    }
    return self;
}

- (UIView *)addViewOrReturnContainViewForUpdate:(UIView *)view withHeight:(CGFloat)height{
    for (UIView *containView in self.views) {
        if ([view isKindOfClass:[containView class]]) {
            return containView;
        }
    }
    
    [self.contentView addSubview:view];
    [self.contentView sendSubviewToBack:view];
    
    [self.views addObject:view];
    [self.heights addObject:@(height)];
    
    [self setupConstraintForIndex:self.views.count - 1];
    
    return nil;
}

- (void)setupConstraints{
    for (NSInteger i = 0; i < self.views.count; i++) {
        [self setupConstraintForIndex:i];
    }
}

- (void)setupConstraintForIndex:(NSInteger)index{
    CGFloat height = [self.heights[index] floatValue];
    CGFloat previousHeight = [self getHeightOfPreviousViewByIndex:index];
    UIView *view = self.views[index];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:views];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:view
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:view.superview
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.0f
                                                            constant:previousHeight];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f
                                                                         constant:height];
    
    [self.contentView addConstraints:horizontalConstraints];
    [self.contentView addConstraints:@[top, heightConstraint]];
    
    [self.topConstraints addObject:top];

}

- (void)changeTopConstaintsByPosition:(CGFloat)position diff:(CGFloat)diff{
    
    BalanceTokenView *firstView = (BalanceTokenView *)[self.views firstObject];
    CGFloat maxYPosition = firstView.frame.size.height - [MainTokenTableViewCell getHeaderHeight];
    
    CGFloat percentForChangeLabel = (firstView.frame.size.height - (position + self.contentView.frame.size.height)) / maxYPosition;;
    
    // formats
    // minTop, maxTop, minFont, maxFont
    // top, center
    NSArray *value1 = @[@(15), @(maxYPosition + 15.0f), @(14), @(28)];
    NSArray *constraints1 = @[firstView.topConstraintBalanceValue, firstView.centerConstraintBalanceValue];
    
    NSArray *value2 = @[@(45), @(maxYPosition + 17.0f), @(11), @(12)];
    NSArray *constraints2 = @[firstView.topConstraintBalanceText, firstView.centerConstraintBalanceText];
    
    [self changePositionForLabel:firstView.balanceValueLabel andPercent:percentForChangeLabel values:value1 constraints:constraints1 isLeft:NO];
    [self changePositionForLabel:firstView.balanceTextLabel andPercent:percentForChangeLabel values:value2 constraints:constraints2 isLeft:YES];
    
    for (NSInteger i = 0; i < self.views.count; i++) {
        
        CGFloat previousHeight = [self getHeightOfPreviousViewByIndex:i];
        UIView *view = self.views[i];
        NSLayoutConstraint *top = self.topConstraints[i];
        
        CGFloat newConstant = top.constant - diff;
        
        if (diff > 0 && position <= 0 && self.contentView.frame.size.height + position <= previousHeight + view.frame.size.height) {
            newConstant = top.constant;
        }

        if (newConstant <= previousHeight) {
            newConstant = previousHeight;
        }
        
        if (newConstant >= self.contentView.frame.size.height - view.frame.size.height) {
            newConstant = self.contentView.frame.size.height - view.frame.size.height;
        }
        
        if (position >= 0) {
            newConstant = previousHeight;
        }
        
        top.constant = newConstant;
    }
}

- (CGFloat)getHeightOfPreviousViewByIndex:(NSInteger)index{
    CGFloat previousHeight = 0.0f;
    
    for (NSInteger i = 0; i < index; i++) {
        NSNumber *height = self.heights[i];
        previousHeight += height.floatValue;
    }
    
    return previousHeight;
}

- (CGFloat)getHeightForNextByIndex:(NSInteger)index{
    CGFloat nextHeight = 0.0f;
    
    for (NSInteger i = index; i < self.heights.count; i++) {
        NSNumber *height = self.heights[i];
        nextHeight += height.floatValue;
    }
    
    return nextHeight;
}

+ (CGFloat)getHeaderHeight{
    return 50.0f;
}

- (BOOL)needShowHeader:(CGFloat)yPosition diff:(CGFloat)diff{
    UIView *firstView = [self.views firstObject];
    NSLayoutConstraint *constr = [self.constraints firstObject];
    CGFloat maxYPosition = firstView.frame.size.height - [MainTokenTableViewCell getHeaderHeight];
    
    CGFloat percentOfPosition;
    if (diff <= 0.0f) {
        percentOfPosition = 1.0f - (yPosition + constr.constant + self.frame.size.height) / [MainTokenTableViewCell getHeaderHeight];
        return percentOfPosition > 0;
    }else{
        percentOfPosition = (firstView.frame.size.height - (yPosition + self.contentView.frame.size.height)) / maxYPosition;
        return percentOfPosition >= 1;
    }
}

- (CGFloat)lastRect:(CGFloat)position{
    
    UIView *moredownView = [self.views firstObject];
    CGFloat maxY = moredownView.frame.origin.y + moredownView.frame.size.height;
    
    for (NSInteger i = 1; i < self.views.count; i++) {
        UIView *view = self.views[i];
        
        if (view.frame.origin.y + view.frame.size.height >= maxY) {
            moredownView = view;
            maxY = view.frame.origin.y + view.frame.size.height;
        }
    }
    
    NSMutableArray *array = [self.views mutableCopy];
    [array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        CGFloat first = ((UIView *)obj1).frame.size.height + ((UIView *)obj1).frame.origin.y;
        CGFloat second = ((UIView *)obj2).frame.size.height + ((UIView *)obj2).frame.origin.y;
        
        if (first >= second) {
            return NSOrderedDescending;
        }else{
            return NSOrderedAscending;
        }
    }];
    
    UIView *last = [array lastObject];
    UIView *underLast;
    for (NSInteger i = array.count - 2; i >= 0; i--) {
        underLast = [array objectAtIndex:i];
        
        if (underLast.frame.origin.y + underLast.frame.size.height != last.frame.origin.y + last.frame.size.height) {
            break;
        }
    }
    
    CGFloat moveDiff;
    if ([last isEqual:[self.views firstObject]]) {
        CGFloat moveDistanсe = last.frame.size.height - [MainTokenTableViewCell getHeaderHeight];
        CGFloat value = last.frame.origin.y + last.frame.size.height - position - [MainTokenTableViewCell getHeaderHeight];
        
        if (value > 0 && value < moveDistanсe) {
            if (value < moveDistanсe / 2.0f) {
                moveDiff = value - moveDistanсe;
            }else{
                moveDiff = moveDistanсe - value;
            }
        }else{
            moveDiff = 0.0f;
        }
    }else{
        if (underLast.frame.origin.y + underLast.frame.size.height > last.frame.origin.y + last.frame.size.height / 2.0f) {
            moveDiff = - (last.frame.origin.y + last.frame.size.height - underLast.frame.origin.y - underLast.frame.size.height);
        }else{
            moveDiff = underLast.frame.origin.y + underLast.frame.size.height - last.frame.origin.y;
        }
    }
    
    return moveDiff;
}

@end
