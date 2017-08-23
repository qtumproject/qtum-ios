//
//  QStoreContractViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 28.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreContractViewController.h"
#import "ConfirmPurchasePopUpViewController.h"
#import "ErrorPopUpViewController.h"
#import "QStoreBuyRequest.h"
#import "QStoreContractElement.h"

@interface QStoreContractViewController () <PopUpWithTwoButtonsViewControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *sourceCodeButton;
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

@property (nonatomic) QStoreContractElement *element;

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
    
    [self.delegate didSelectQStoreContractDetails:self.element];
}

- (IBAction)actionSourceCode:(id)sender {
    
    if (!self.element.abiString || [self.element.abiString isEqualToString:@""]) {
        [self.delegate didLoadAbi:self.element];
    } else {
        [self showSourceCodePopUpWithString:self.element.abiString];
    }
}

- (void)showSourceCodePopUpWithString:(NSString *)string {
    
    PopUpContent *content = [PopUpContentGenerator contentForSourceCode];
    content.messageString = string;
    
    [[PopUpsManager sharedInstance] showSourceCodePopUp:self withContent:content presenter:nil completion:nil];
}

- (IBAction)actionPurchase:(id)sender {
    
    ConfirmPurchasePopUpViewController *vc = [[PopUpsManager sharedInstance] showConfirmPurchasePopUp:self presenter:nil completion:nil];
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
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
    
    if ([sender isKindOfClass:[ConfirmPurchasePopUpViewController class]]) {
        [self.delegate didSelectPurchaseContract:self.element];
    }
}

- (void)cancelButtonPressed:(PopUpViewController *)sender {
    
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
    
    if ([sender isKindOfClass:[ErrorPopUpViewController class]]) {
        [self actionPurchase:self];;
    }
}

#pragma mark - Methods

- (void)startLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[PopUpsManager sharedInstance] showLoaderPopUp];
    });
}

- (void)stopLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[PopUpsManager sharedInstance] dismissLoader];
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
    
    self.purchaseButton.enabled = (self.buyRequest == nil);
    self.purchaseButton.alpha = (self.buyRequest == nil) ? 1 : 0.5f;
    
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

- (void)showAbi {
    
    [self showSourceCodePopUpWithString:self.element.abiString];
}

- (void)showErrorPopUpWithMessage:(NSString *)message {
    PopUpContent *content = [PopUpContentGenerator contentForOupsPopUp];
    content.messageString = message;
    
    [[PopUpsManager sharedInstance] showErrorPopUp:self withContent:content presenter:nil completion:nil];
}

- (void)showContractBoughtPop {
    PopUpContent *content = [PopUpContentGenerator contentForContractBought];
    [[PopUpsManager sharedInstance] showInformationPopUp:self withContent:content presenter:nil completion:nil];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    NSString *tagString = [[textView.text substringWithRange:characterRange] substringWithRange:NSMakeRange(1, characterRange.length - 1)];
    [self.delegate didSelectTag:tagString];
    return NO;
}

@end
