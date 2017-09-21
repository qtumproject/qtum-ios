//
//  SliderFeeView.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.09.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "SliderFeeView.h"

@implementation SliderFeeView

- (IBAction)didSliderAction:(id)sender {
    [self.delegate didChangeFeeSlider:sender];
}

@end
