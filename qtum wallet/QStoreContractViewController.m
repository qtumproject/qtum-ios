//
//  QStoreContractViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 28.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QStoreContractViewController.h"
#import "ConfirmPurchasePopUpViewController.h"
#import "ErrorPopUpViewController.h"
#import "QStoreBuyRequest.h"
#import "QStoreContractElement.h"
#import "SourceCodePopUpViewController.h"

@interface QStoreContractViewController () <PopUpWithTwoButtonsViewControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *viewAbiButton;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *detailsButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITextView *tagsTextView;
@property (weak, nonatomic) IBOutlet UILabel *publishedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishedByLabel;
@property (weak, nonatomic) IBOutlet UILabel *downloadsLabel;
@property (weak, nonatomic) IBOutlet UILabel *compiledOnLabel;
@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;
@property (weak, nonatomic) IBOutlet UIButton *sourceCodeButton;

@property (nonatomic) QStoreContractElement *element;
@property (assign, nonatomic) BOOL isPopupWithAbiRequired;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintForTextView;
@end

@implementation QStoreContractViewController

@synthesize delegate, buyRequest;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.amountLabel.text = self.element.priceString;
    self.titleLabel.text = self.element.name;
    
    self.detailsButton.alpha =
    self.sourceCodeButton.alpha =
    self.scrollView.alpha = 0.0f;
    
    self.tagsTextView.delegate = self;
    self.tagsTextView.textContainerInset = UIEdgeInsetsZero;
    self.tagsTextView.textContainer.lineFragmentPadding = 0;
    
    [self.delegate didLoadViewWithFullContract:self.element];
}

#pragma mark - Protected Getters 

- (UIColor*)colorForTag {
    
    return customBlueColor();
}

#pragma mark - Actions

- (IBAction)actionDetails:(id)sender {
    
    if (!self.element.abiString || [self.element.abiString isEqualToString:@""]) {
        [self.delegate loadAbiWithElement:self.element];
    } else {
        [self.delegate didPressedTemplateDetailWithAbi:self.element.abiString];
    }
}

- (IBAction)actionAbi:(id)sender {
    
    if (!self.element.abiString || [self.element.abiString isEqualToString:@""]) {
        self.isPopupWithAbiRequired = YES;
        [self.delegate loadAbiWithElement:self.element];
    } else {
        [self showAbiPopUpWithString:self.element.abiString];
    }
}

- (IBAction)actionSourceCode:(id)sender {
    
    [self.delegate didSelectQStoreContractDetails:self.buyRequest];
}

- (void)showSourceCodePopUpWithString:(NSString *)string {
    
    PopUpContent *content = [PopUpContentGenerator contentForSourceCode];
    content.messageString = string;
    [SLocator.popUpsManager showSourceCodePopUp:self withContent:content presenter:nil completion:nil];
}

- (void)showAbiPopUpWithString:(NSString *)string {
    
    PopUpContent *content = [PopUpContentGenerator contentForQStoreAbi];
    content.messageString = string;
    [SLocator.popUpsManager showSourceCodePopUp:self withContent:content presenter:nil completion:nil];
}

- (IBAction)actionPurchase:(id)sender {
    
    ConfirmPurchasePopUpViewController *vc = [SLocator.popUpsManager showConfirmPurchasePopUp:self presenter:nil completion:nil];
    vc.contractNameLabel.text = self.element.name;
    vc.contractTypeLabel.text = [self.element.typeString capitalizedString];
    vc.amountLabel.text = [NSString stringWithFormat:@"%@ %@", self.element.priceString, NSLocalizedString(@"QTUM", nil)];
    vc.minterAddressLabel.text = self.element.publisherAddress;
    vc.feeLabel.text = [NSString stringWithFormat:@"%@ %@", @"0.1", NSLocalizedString(@"QTUM", nil)];
}

- (IBAction)actionBack:(id)sender {
    [self.delegate didPressedBack];
}

#pragma mark - PopUpWithTwoButtonsViewControllerDelegate

- (void)okButtonPressed:(PopUpViewController *)sender {
    
    [SLocator.popUpsManager hideCurrentPopUp:YES completion:nil];
    
    if ([sender isKindOfClass:[ConfirmPurchasePopUpViewController class]]) {
        [self.delegate didSelectPurchaseContract:self.element];
    }
    
    if ([sender isKindOfClass:[SourceCodePopUpViewController class]]) {
        SourceCodePopUpViewController* popup = (SourceCodePopUpViewController*)sender;
        [self.delegate didCopySourceOrAbi:popup.textView.text];
    }
}

- (void)cancelButtonPressed:(PopUpViewController *)sender {
    
    [SLocator.popUpsManager hideCurrentPopUp:YES completion:nil];
    
    if ([sender isKindOfClass:[ErrorPopUpViewController class]]) {
        [self actionPurchase:self];;
    }
}

#pragma mark - Methods

- (void)startLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SLocator.popUpsManager showLoaderPopUp];
    });
}

- (void)stopLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SLocator.popUpsManager dismissLoader];
    });
}

- (void)updateWithFull {
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"dd-MMM-YYYY"];
    
    self.descriptionLabel.text = self.element.contractDescription;
    self.publishedDateLabel.text = [formatter stringFromDate:self.element.createdAt];
    self.sizeLabel.text = [NSString stringWithFormat:@"%@b", self.element.size];
    self.compiledOnLabel.text = self.element.completedOn;
    self.sourceCodeLabel.text = self.element.withSourseCode ? NSLocalizedString(@"YES", nil) : NSLocalizedString(@"NO", nil);
    self.publishedByLabel.text = self.element.publisherAddress;
    self.downloadsLabel.text = [self.element.countDownloads stringValue];
        
    if (self.buyRequest.state == QStoreBuyRequestStateIsPaid) {
        self.purchaseButton.hidden = YES;
        self.sourceCodeButton.hidden = NO;
    } else {
        self.purchaseButton.enabled = (self.buyRequest == nil);
        self.purchaseButton.alpha = (self.buyRequest == nil) ? 1 : 0.5f;
        self.sourceCodeButton.hidden = YES;
    }
    
    [self setupTagsTextView:self.element.tags];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.detailsButton.alpha =
        self.scrollView.alpha = 1.0f;
        self.sourceCodeButton.alpha = (self.buyRequest && self.buyRequest.state == QStoreBuyRequestStateIsPaid) ? 1.0f : 0.0f;
    }];
}

- (void)setupTagsTextView:(NSArray *)tags {
    self.tagsTextView.linkTextAttributes = @{NSForegroundColorAttributeName:[self colorForTag],
                                             NSFontAttributeName:self.tagsTextView.font};
    
    NSMutableString *mutString = [NSMutableString new];
    for (NSString *string in tags) {
        [mutString appendString:[NSString stringWithFormat:@"#%@", string]];
        [mutString appendString:@" "];
    }
    [mutString replaceCharactersInRange:NSMakeRange(mutString.length - 1, 1) withString:@""];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:mutString];
    for (NSString *string in tags) {
        NSDictionary *attr = @{NSLinkAttributeName : @"",
                               NSFontAttributeName: self.tagsTextView.font};
        [attrString addAttributes:attr range:[mutString rangeOfString:[NSString stringWithFormat:@"#%@", string]]];
    }
    
    self.tagsTextView.attributedText = attrString;
    
    CGFloat fixedWidth = self.tagsTextView.frame.size.width;
    CGSize newSize = [self.tagsTextView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    self.heightConstraintForTextView.constant = newSize.height;
}

- (void)setContract:(QStoreContractElement *)element {
    self.element = element;
}

- (void)didLoadAbi {
    
    if (self.isPopupWithAbiRequired ) {
        self.isPopupWithAbiRequired = NO;
        [self showAbiPopUpWithString:self.element.abiString];
    } else {
        [self.delegate didPressedTemplateDetailWithAbi:self.element.abiString];
    }
}

- (void)showSourceCode:(NSString*) source {
    
    [self showSourceCodePopUpWithString:source];
}


- (void)showErrorPopUpWithMessage:(NSString *)message {
    PopUpContent *content = [PopUpContentGenerator contentForOupsPopUp];
    content.messageString = message;
    
    [SLocator.popUpsManager showErrorPopUp:self withContent:content presenter:nil completion:nil];
}

- (void)showContractBoughtPop {
    PopUpContent *content = [PopUpContentGenerator contentForContractBought];
    [SLocator.popUpsManager showInformationPopUp:self withContent:content presenter:nil completion:nil];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    NSString *tagString = [[textView.text substringWithRange:characterRange] substringWithRange:NSMakeRange(1, characterRange.length - 1)];
    [self.delegate didSelectTag:tagString];
    return NO;
}

@end
