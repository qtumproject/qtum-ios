//
//  ServerAdapter.h
//  qtum wallet
//
//  Created by Никита Федоренко on 21.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerAdapter : NSObject <RequestManagerAdapter>

- (id)adaptiveDataForHistory:(id) data;
- (id)adaptiveDataForOutputs:(id) data;

@end
