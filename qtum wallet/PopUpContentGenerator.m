//
//  PopUpContentGenerator.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 03.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "PopUpContentGenerator.h"
#import "PopUpContent.h"

@implementation PopUpContentGenerator

+ (PopUpContent *)getContentForOupsPopUp{
    PopUpContent *content = [[PopUpContent alloc] initWithTitle:@"Oops" message:@"Something went wrong" okTitle:@"OK" cancelTitle:@"TRY AGAIN"];
    return content;
}

+ (PopUpContent *)getContentForPhotoLibrary{
    PopUpContent *content = [[PopUpContent alloc] initWithTitle:@"QTUM App would like to access your photos" message:nil okTitle:@"OK" cancelTitle:@"DON'T ALLOW"];
    return content;
}

+ (PopUpContent *)getContentForUpdateBalance{
    PopUpContent *content = [[PopUpContent alloc] initWithTitle:@"Your balance was updated" message:nil okTitle:@"OK" cancelTitle:nil];
    return content;
}

+ (PopUpContent *)getContentForCreateContract{
    PopUpContent *content = [[PopUpContent alloc] initWithTitle:@"Conrtact was created successfully" message:nil okTitle:@"OK" cancelTitle:nil];
    return content;
}

@end
