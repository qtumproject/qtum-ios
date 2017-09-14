//
//  NewsOutputDelegate.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 21.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

@protocol NewsOutputDelegate <NSObject>

@required
-(void)refreshTableViewData;
-(void)openNewsLink;


@end
