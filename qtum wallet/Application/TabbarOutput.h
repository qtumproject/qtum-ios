//
//  TabbarOutput.h
//  qtum wallet
//
//  Created by Никита Федоренко on 05.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TabbarOutputDelegate;

@protocol TabbarOutput <NSObject>

@property (weak,nonatomic) id <TabbarOutputDelegate> outputDelegate;
@property (assign,nonatomic) BOOL isReload;

-(void)selectSendControllerWithAdress:(NSString*)adress andValue:(NSString*)amount;

@end
