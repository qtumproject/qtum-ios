//
//  TabbarOutput.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 05.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TabbarOutputDelegate;

@protocol TabbarOutput <NSObject>

@property (weak,nonatomic) id <TabbarOutputDelegate> outputDelegate;
@property (assign,nonatomic) BOOL isReload;

-(void)selectSendControllerWithAdress:(NSString*)adress andValue:(NSString*)amount;
-(void)setControllerForNews:(UIViewController*)newsController
                    forSend:(UIViewController*)sendController
                  forWallet:(UIViewController*)walletController
                 forProfile:(UIViewController*)profileController;


@end
