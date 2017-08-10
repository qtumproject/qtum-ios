//
//  QStoreContractViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 28.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreContractViewController.h"
#import "ContractFileManager.h"

#import "QStoreFullContractElement.h"
#import "QStoreShortContractElement.h"

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

@property (nonatomic) QStoreFullContractElement *fullElement;
@property (nonatomic) QStoreShortContractElement *shortElement;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintForTextView;
@end

@implementation QStoreContractViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.amountLabel.text = self.shortElement.priceString;
    self.titleLabel.text = self.shortElement.name;
    
    self.detailsButton.alpha =
    self.sourceCodeButton.alpha =
    self.scrollView.alpha = 0.0f;
    
    self.tagsTextView.delegate = self;
    self.tagsTextView.textContainerInset = UIEdgeInsetsZero;
    self.tagsTextView.textContainer.lineFragmentPadding = 0;
    
    [self.delegate didLoadFullContract:self.shortElement];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)actionDetails:(id)sender {
    [self.delegate didSelectQStoreContractDetails:self.fullElement];
}

- (IBAction)actionSourceCode:(id)sender {
    if (!self.fullElement.abiString || [self.fullElement.abiString isEqualToString:@""]) {
        [self.delegate didLoadAbi:self.fullElement];
    } else {
        [self showSourceCodePopUpWithString:self.fullElement.abiString];
    }
}

- (void)showSourceCodePopUpWithString:(NSString *)string {
    PopUpContent *content = [PopUpContentGenerator contentForSourceCode];
    content.messageString = string;
    
    [[PopUpsManager sharedInstance] showSourceCodePopUp:self withContent:content presenter:nil completion:nil];
}

- (IBAction)actionPurchase:(id)sender {
    [[PopUpsManager sharedInstance] showConfirmPurchasePopUp:self presenter:nil completion:nil];
}

- (IBAction)actionBack:(id)sender {
    [self.delegate didPressedBack];
}

#pragma mark - PopUpWithTwoButtonsViewControllerDelegate

- (void)okButtonPressed:(PopUpViewController *)sender {
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
}

- (void)cancelButtonPressed:(PopUpViewController *)sender {
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
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

- (void)setFullContract:(QStoreFullContractElement *)element {
    self.fullElement = element;
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"dd-MMM-YYYY"];
    
    self.descriptionLabel.text = element.contractDescription;
    self.publishedDateLabel.text = [formatter stringFromDate:element.createdAt];
    self.sizeLabel.text = [NSString stringWithFormat:@"%@b", element.size];
    self.compiledOnLabel.text = element.completedOn;
    self.sourceCodeLabel.text = element.withSourseCode ? NSLocalizedString(@"YES", nil) : NSLocalizedString(@"NO", nil);
    self.publishedByLabel.text = element.publisherAddress;
    self.downloadsLabel.text = [element.countDownloads stringValue];
    
    [self setupTagsTextView:element.tags];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.detailsButton.alpha =
        self.scrollView.alpha = 1.0f;
        self.sourceCodeButton.alpha = element.withSourseCode ? 1.0f : 0.0f;
    }];
}

- (void)setupTagsTextView:(NSArray *)tags {
    
    self.tagsTextView.linkTextAttributes = @{NSForegroundColorAttributeName:self.tagsTextView.textColor,
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

- (void)setShortContract:(QStoreShortContractElement *)element {
    self.shortElement = element;
}

- (void)showAbi {
    [self showSourceCodePopUpWithString:self.fullElement.abiString];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    NSString *tagString = [[textView.text substringWithRange:characterRange] substringWithRange:NSMakeRange(1, characterRange.length - 1)];
    [self.delegate didSelectTag:tagString];
    return NO;
}

@end
