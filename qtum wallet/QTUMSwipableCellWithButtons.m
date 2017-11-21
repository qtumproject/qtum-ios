//
//  QTUMSwipableCellWithButtons.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 01.11.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QTUMSwipableCellWithButtons.h"

@interface QTUMSwipableCellWithButtons ()

@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeRecognizer;
@property (nonatomic, assign) CGPoint panStartPoint;
@property (nonatomic, assign) CGFloat startingRightLayoutConstraintConstant;


@end

@implementation QTUMSwipableCellWithButtons

- (void)awakeFromNib {
	[super awakeFromNib];

	self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector (panThisCell:)];
	self.panRecognizer.delegate = self;
	[self.myContentView addGestureRecognizer:self.panRecognizer];
}

- (void)prepareForReuse {
	[super prepareForReuse];
	[self resetConstraintContstantsToZero:NO notifyDelegateDidClose:NO];
}

- (void)openCell {
	[self setConstraintsToShowAllButtons:NO notifyDelegateDidOpen:NO];
}

- (void)closeCell {
	[self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO];
}

- (IBAction)buttonClicked:(id) sender {

	if (sender == self.button1) {
		if ([self.delegate respondsToSelector:@selector (buttonOneActionForIndexPath:)]) {
			[self.delegate buttonOneActionForIndexPath:self.indexPath];
		}
	} else if (sender == self.button2) {
		if ([self.delegate respondsToSelector:@selector (buttonTwoActionForIndexPath:)]) {
			[self.delegate buttonTwoActionForIndexPath:self.indexPath];
		}
	}
}

- (void)setIndexPath:(NSIndexPath *) indexPath {
	//Update the instance variable
	_indexPath = indexPath;
}

- (CGFloat)buttonTotalWidth {
	if (self.button2) {
		return CGRectGetWidth (self.frame) - CGRectGetMinX (self.button2.frame);
	} else {
		return CGRectGetWidth (self.frame) - CGRectGetMinX (self.button1.frame);
	}
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *) gestureRecognizer {

	if (gestureRecognizer == self.panRecognizer) {

		if (self.isEditing) {
			return NO; //do not swipe while editing table
		}

		CGPoint translation = [_panRecognizer translationInView:self];
		if (fabs (translation.y) > fabs (translation.x)) {
			return NO; // user is scrolling vertically
		}
	}
	return YES;
}

- (void)panThisCell:(UIPanGestureRecognizer *) recognizer {

	if (![self.delegate shoudOpenCell:self]) {
		return;
	}

	switch (recognizer.state) {
		case UIGestureRecognizerStateBegan:
			self.panStartPoint = [recognizer translationInView:self.myContentView];
			self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;

			if ([self.delegate respondsToSelector:@selector (cellDidStartMoving:)]) {
				[self.delegate cellDidStartMoving:self];
			}
			break;

		case UIGestureRecognizerStateChanged: {
			CGPoint currentPoint = [recognizer translationInView:self.myContentView];
			CGFloat deltaX = currentPoint.x - self.panStartPoint.x;
			BOOL panningLeft = NO;
			if (currentPoint.x < self.panStartPoint.x) {  //1
				panningLeft = YES;
			}

			if (self.startingRightLayoutConstraintConstant == 0) { //2
				//The cell was closed and is now opening
				if (!panningLeft) {
					CGFloat constant = MAX(-deltaX, 0); //3
					if (constant == 0) { //4
						[self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO]; //5
					} else {
						self.contentViewRightConstraint.constant = constant; //6
					}
				} else {
					CGFloat constant = MIN(-deltaX, [self buttonTotalWidth]); //7
					if (constant == [self buttonTotalWidth]) { //8
						[self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO]; //9
					} else {
						self.contentViewRightConstraint.constant = constant; //10
					}
				}
			} else {
				//The cell was at least partially open.
				CGFloat adjustment = self.startingRightLayoutConstraintConstant - deltaX; //11
				if (!panningLeft) {
					CGFloat constant = MAX(adjustment, 0); //12
					if (constant == 0) { //13
						[self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO]; //14
					} else {
						self.contentViewRightConstraint.constant = constant; //15
					}
				} else {
					CGFloat constant = MIN(adjustment, [self buttonTotalWidth]); //16
					if (constant == [self buttonTotalWidth]) { //17
						[self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO]; //18
					} else {
						self.contentViewRightConstraint.constant = constant;//19
					}
				}
			}

			self.contentViewLeftConstraint.constant = -self.contentViewRightConstraint.constant; //20
		}
			break;

		case UIGestureRecognizerStateEnded:
			if (self.startingRightLayoutConstraintConstant == 0) { //1
				//We were opening
				CGFloat halfOfButtonOne = CGRectGetWidth (self.button1.frame) / 2; //2
				if (self.contentViewRightConstraint.constant >= halfOfButtonOne) { //3
					//Open all the way
					[self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
				} else {
					//Re-close
					[self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
				}

			} else {
				//We were closing
				CGFloat buttonOnePlusHalfOfButton2 = CGRectGetWidth (self.button1.frame) + (CGRectGetWidth (self.button2.frame) / 2); //4
				if (self.contentViewRightConstraint.constant >= buttonOnePlusHalfOfButton2) { //5
					//Re-open all the way
					[self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
				} else {
					//Close
					[self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
				}
			}

			if ([self.delegate respondsToSelector:@selector (cellEndMoving:)]) {
				[self.delegate cellEndMoving:self];
			}

			break;

		case UIGestureRecognizerStateCancelled:
			if (self.startingRightLayoutConstraintConstant == 0) {
				//We were closed - reset everything to 0
				[self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
			} else {
				//We were open - reset to the open state
				[self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
			}

			if ([self.delegate respondsToSelector:@selector (cellEndMoving:)]) {
				[self.delegate cellEndMoving:self];
			}

			break;

		default:
			break;
	}
}

- (void)updateConstraintsIfNeeded:(BOOL) animated completion:(void (^)(BOOL finished)) completion {
	float duration = 0;
	if (animated) {
		duration = 0.25;
	}

	[UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		[self layoutIfNeeded];
	}                completion:completion];
}


- (void)resetConstraintContstantsToZero:(BOOL) animated notifyDelegateDidClose:(BOOL) notifyDelegate {

	if (notifyDelegate) {
		if ([self.delegate respondsToSelector:@selector (cellDidClose:)]) {
			[self.delegate cellDidClose:self];
		}
	}

	if (self.startingRightLayoutConstraintConstant == 0 &&
			self.contentViewRightConstraint.constant == 0) {
		//Already all the way closed, no bounce necessary
		return;
	}

	[self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
		self.contentViewRightConstraint.constant = 0;
		self.contentViewLeftConstraint.constant = 0;

		[self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
			self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
		}];
	}];
}


- (void)setConstraintsToShowAllButtons:(BOOL) animated notifyDelegateDidOpen:(BOOL) notifyDelegate {

	if (notifyDelegate) {

		if ([self.delegate respondsToSelector:@selector (cellDidOpen:)]) {
			[self.delegate cellDidOpen:self];
		}
	}

	//1
	if (self.startingRightLayoutConstraintConstant == [self buttonTotalWidth] &&
			self.contentViewRightConstraint.constant == [self buttonTotalWidth]) {
		return;
	}
	//2

	[self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
		//3
		self.contentViewLeftConstraint.constant = -[self buttonTotalWidth];
		self.contentViewRightConstraint.constant = [self buttonTotalWidth];

		[self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
			//4
			self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
		}];
	}];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *) gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *) otherGestureRecognizer {
	return YES;
}

@end
