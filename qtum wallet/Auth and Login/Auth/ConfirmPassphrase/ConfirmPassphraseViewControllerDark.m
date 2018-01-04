//
//  ConfirmPassphraseViewControllerDark.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.01.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "ConfirmPassphraseViewControllerDark.h"

@interface ConfirmPassphraseViewControllerDark ()

@end

@implementation ConfirmPassphraseViewControllerDark

-(void)configCellsFromNibs {
    
    [self.choosenCollectionView registerNib:[UINib nibWithNibName:@"ConfirmWordCollectionViewCellDark" bundle:nil] forCellWithReuseIdentifier:confirmWordCollectionViewCellIdentifire];
    [self.exampleCollectionView registerNib:[UINib nibWithNibName:@"ExampleWordCollectionViewCellDark" bundle:nil] forCellWithReuseIdentifier:exampleWordCollectionViewCellIdentifire];
    
    self.sizingCellForChoose = [[UINib nibWithNibName:@"ConfirmWordCollectionViewCellDark" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    self.sizingCellForExample = [[UINib nibWithNibName:@"ExampleWordCollectionViewCellDark" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
}

@end
