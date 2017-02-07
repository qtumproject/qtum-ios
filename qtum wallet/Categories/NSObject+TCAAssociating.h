//
//  NSObject+TCAAssociating.h
//  TCA2016
//
//  Created by Nikita on 20.08.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (TCAAssociating)

-(BOOL)isNull;

@property (nonatomic, retain) id associatedObject;

@end
