//
//  FavouriteTemplatesCollectionSource.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 17.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FavouriteTemplatesCollectionSourceOutput.h"

@interface FavouriteTemplatesCollectionSource : NSObject <FavouriteTemplatesCollectionSourceOutput>

@property (nonatomic) NSArray<TemplateModel *> *templateModels;
@property (nonatomic, weak) id<FavouriteTemplatesCollectionSourceOutputDelegate> delegate;

@end
