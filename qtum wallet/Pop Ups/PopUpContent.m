//
//  PopUpContent.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 03.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

@implementation PopUpContent

- (instancetype)initWithTitle:(NSString *) title message:(NSString *) message okTitle:(NSString *) okTitle cancelTitle:(NSString *) cancelTitle {

	self = [super init];
	if (self) {
		_titleString = title;
		_messageString = message;
		_okButtonTitle = okTitle;
		_cancelButtonTitle = cancelTitle;
	}
	return self;
}

- (BOOL)isEqualContent:(PopUpContent *) object {

	BOOL title = self.titleString ? [self.titleString isEqualToString:object.titleString] : YES;
	BOOL message = self.messageString ? [self.messageString isEqualToString:object.messageString] : YES;
	BOOL okTitle = self.okButtonTitle ? [self.okButtonTitle isEqualToString:object.okButtonTitle] : YES;
	BOOL cancelTitle = self.cancelButtonTitle ? [self.cancelButtonTitle isEqualToString:object.cancelButtonTitle] : YES;

	return title && message && okTitle && cancelTitle;
}

@end
