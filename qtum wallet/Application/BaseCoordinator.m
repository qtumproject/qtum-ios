//
//  BaseCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.03.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

@interface BaseCoordinator ()

@property (strong, nonatomic) NSMutableArray <Coordinatorable> *childCoordinators;

@end

@implementation BaseCoordinator

- (NSMutableArray *)childCoordinators {
	if (!_childCoordinators) {
		self.childCoordinators = @[].mutableCopy;
	}
	return _childCoordinators;
}

- (void)start {
	[NSException raise:NSInternalInconsistencyException
				format:@"You must override %@ in a subclass", NSStringFromSelector (_cmd)];
}

- (void)addDependency:(id <Coordinatorable>) coordinator {
	NSAssert(coordinator != nil, @"Coordinator cant be nil");

	for (id <Coordinatorable> element in self.childCoordinators) {
		if ([element isEqual:coordinator]) {
			return;
		}
	}
	[self.childCoordinators addObject:coordinator];
}

- (void)removeDependency:(id <Coordinatorable>) coordinator {
	NSAssert(coordinator != nil, @"Coordinator cant be nil");

	[self.childCoordinators removeObject:coordinator];
}

- (void)removeAllDependencys {

	self.childCoordinators = nil;
}


@end
