//
//  iMessageDataOperation.h
//  qtum wallet
//
//  Created by Никита Федоренко on 14.09.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iMessageDataOperation : NSObject

+ (NSDictionary *)getDictFormGroupFileWithName:(NSString *)fileName;
+ (NSString*)saveGroupFileWithName:(NSString *)fileName dataSource:(NSDictionary *)dataSource;

@end
