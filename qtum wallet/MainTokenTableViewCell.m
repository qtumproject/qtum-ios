//
//  MainTokenTableViewCell.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 29.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "MainTokenTableViewCell.h"

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
    [self.contentView bringSubviewToFront:view];
    
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
    NSLog(@"%f", position);
    
    for (NSInteger i = 0; i < self.views.count; i++) {
        
        CGFloat previousHeight = [self getHeightOfPreviousViewByIndex:i];
        UIView *view = self.views[i];
        NSLayoutConstraint *top = self.topConstraints[i];
        
        CGFloat newConstant = top.constant - diff;
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

@end
