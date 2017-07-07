//
//  PageControl.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 06.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "PageControl.h"
#import "PageControlItem.h"

@interface PageControl()

@property (nonatomic) NSMutableArray<UIView<PageControlItem> *> *pagesItems;
@property (nonatomic) NSMutableArray *withConstraints;

@end

@implementation PageControl

#pragma mark - Init

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    _pagesItems = [NSMutableArray new];
    _withConstraints = [NSMutableArray new];
    
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - Setters

- (void)setPagesCount:(NSInteger)pagesCount {
    
    [self clearItems];
    _pagesCount = pagesCount;
    [self createPagesViews];
}

- (void)setSelectedPage:(NSInteger)selectedPage {
    
    _selectedPage = selectedPage;
    
    [self updateItems];
    [self updateWidthConstraints];
}

#pragma mark - Private methods

- (void)clearItems {
    
    for (UIView<PageControlItem> *item in self.pagesItems) {
        [item removeFromSuperview];
    }
    
    [self.pagesItems removeAllObjects];
    [self.withConstraints removeAllObjects];
    _selectedPage = 0;
    _pagesCount = 0;
}

- (void)createPagesViews {
    
    for (NSInteger i = 0; i < self.pagesCount; i++) {
        UIView<PageControlItem> *item = [self createViewItem];
        
        if (item) {
            item.translatesAutoresizingMaskIntoConstraints = NO;
            
            [self addSubview:item];
            [self.pagesItems addObject:item];
        }
    }
    
    [self createConstraints];
    
    self.selectedPage = 0;
}

- (void)createConstraints {
    
    if (self.pagesItems.count == 0) {
        return;
    }
    
    NSArray *spaces;
    NSMutableArray *widths = [NSMutableArray new];
    NSMutableArray *centerY = [NSMutableArray new];
    
    
    NSMutableString *widthConstraintString = [NSMutableString new];
    NSMutableDictionary *views = [NSMutableDictionary new];
    NSDictionary *metrics = @{@"space" : @([self spaceBetweenItems])};
    
    for (NSInteger i = 0; i < self.pagesItems.count; i++) {
        
        UIView<PageControlItem> *view = [self.pagesItems objectAtIndex:i];
        if (i == 0) {
            NSString *first = [NSString stringWithFormat:@"current%ld", (long)i];
            NSString *second = [NSString stringWithFormat:@"current%ld", (long)i + 1];
            
            [views setObject:view forKey:first];
            [views setObject:[self.pagesItems objectAtIndex:i + 1] forKey:second];
            [widthConstraintString appendString:[NSString stringWithFormat:@"H:|-0-[%@]-space-[%@]", first, second]];
        } else if (i == self.pagesItems.count - 1) {
            [widthConstraintString appendString:[NSString stringWithFormat:@"-0-|"]];
        } else {
            NSString *next = [NSString stringWithFormat:@"current%ld", (long)i + 1];
            [views setObject:[self.pagesItems objectAtIndex:i + 1] forKey:next];
            
            [widthConstraintString appendString:[NSString stringWithFormat:@"-space-[%@]", next]];
        }
        
        CGFloat width = (i == self.selectedPage) ? [view getSelectedWidth] : [view getNotSelectedWidth];
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:width];
        
        NSLayoutConstraint *aspectConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0];
        
        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
        
        [view addConstraint:widthConstraint];
        [view addConstraint:aspectConstraint];
        
        [widths addObject:widthConstraint];
        [centerY addObject:centerYConstraint];
    }
    
    spaces = [NSLayoutConstraint constraintsWithVisualFormat:widthConstraintString options:0 metrics:metrics views:views];
    
    [self addConstraints:spaces];
    [self addConstraints:centerY];
    
    self.withConstraints = widths;
}

- (void)updateItems {
    
    for (NSInteger i = 0; i < self.pagesItems.count; i++) {
        UIView<PageControlItem> *item = [self.pagesItems objectAtIndex:i];
        
        [item setSelectedState:i == self.selectedPage];
    }
}

- (void)updateWidthConstraints {
 
    for (NSInteger i = 0; i < self.withConstraints.count; i++) {
        NSLayoutConstraint *constraint = [self.withConstraints objectAtIndex:i];
        UIView<PageControlItem> *item = [self.pagesItems objectAtIndex:i];
        
        constraint.constant = (i == self.selectedPage) ? [item getSelectedWidth] : [item getNotSelectedWidth];
    }
}

#pragma mark - PublicMethods

- (UIView<PageControlItem> *)createViewItem {
    return nil;
}

- (CGFloat)spaceBetweenItems {
    return 10.0f;
}

@end
