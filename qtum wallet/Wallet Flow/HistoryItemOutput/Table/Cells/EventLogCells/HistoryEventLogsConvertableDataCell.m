//
//  HistoryEventLogsConvertableDataCell.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 07.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "HistoryEventLogsConvertableDataCell.h"

@interface HistoryEventLogsConvertableDataCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelHeight;
@property (weak, nonatomic) IBOutlet UIView *underline;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTextLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTextTrailing;

@end

@implementation HistoryEventLogsConvertableDataCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self configViews];
}

#pragma mark - Configuration

-(void)configViews {
    
    self.buttonContainer.layer.borderWidth = 1;
    self.buttonContainer.layer.borderColor = customBlueColor().CGColor;
}

-(void)setValuesModel:(ValueRepresentationEntity *)valuesModel {
    _valuesModel = valuesModel;
    [self updateWithValuesModel];
}

-(void)setIsLast:(BOOL)isLast {
    
    _isLast = isLast;
    
    if (isLast) {
        self.underline.hidden = NO;
    } else {
        self.underline.hidden = YES;
    }
    
    if (!_isFirst) {
        self.titleLabelHeight.constant = 0;
    }
}

-(void)setIsMiddle:(BOOL)isMiddle {
    
    _isMiddle = isMiddle;
    
    if (isMiddle) {
        self.titleLabelHeight.constant = 0;
        self.underline.hidden = YES;
    }
}

-(void)setIsFirst:(BOOL)isFirst {
    
    _isFirst = isFirst;
    
    if (isFirst) {
        self.underline.hidden = YES;
    } else {
        self.titleLabelHeight.constant = 0;
    }
}

-(void)setButtonText:(NSString*) buttonTitle {
    
    [self.convertButton setTitle:buttonTitle forState:UIControlStateNormal];
}

-(void)updateWithValuesModel {
    [self setButtonText:self.valuesModel.nameDependsOnType];
    self.valueTextLabel.text = self.valuesModel.valueDependsOnType;
}

#pragma mark - Actions

- (IBAction)actionConvert:(id)sender {
    
    UIView *window = [UIApplication sharedApplication].keyWindow;

    CGRect rect = [self convertRect:self.buttonContainer.frame toView:window];
    
    [self.delegate convertValue:self.valueTextLabel.text frame:rect withHandler:^(NSString *resultValue, ConvertionAddressType type ) {
        
        switch (type) {
            case HexType:
                [self setButtonText:@"HexType"];
                break;
            case NumberType:
                [self setButtonText:@"NumberType"];
                break;
            case TextType:
                [self setButtonText:@"TextType"];
                break;
            case AddressType:
                [self setButtonText:@"AddressType"];
                break;
                
            default:
                break;
        }
        
        self.valuesModel.type = type;
        [self updateWithValuesModel];
        [self.delegate tableViewCellChanged];
    }];
}

@end
