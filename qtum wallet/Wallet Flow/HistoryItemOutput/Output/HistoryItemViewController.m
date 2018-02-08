//
//  HistoryItemViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.04.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "HistoryItemViewController.h"
#import "HistoryItemDelegateDataSource.h"
#import "HistoryItemEventLogSource.h"
#import "HistoryItemOverviewSource.h"
#import "PageControl.h"
#import "TransactionReceipt+Extension.h"
#import "HistoryOverviewTableCell.h"
#import "HistoryEventLogAddressCell.h"
#import "HistoryEventLogsConvertableDataCell.h"
#import "ChooseConverterView.h"

@interface HistoryItemViewController () <UIScrollViewDelegate, HistoryItemOverviewSourceDelegate, HistoryItemEventLogSourceDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cointType;
@property (weak, nonatomic) IBOutlet UILabel *receivedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;

@property (weak, nonatomic) IBOutlet UITableView *addressesTableView;

@property (weak, nonatomic) IBOutlet UIButton *addressesButton;
@property (weak, nonatomic) IBOutlet UIButton *owerviewButton;
@property (weak, nonatomic) IBOutlet UIButton *eventLogButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerButtonsWidth;
@property (assign, nonatomic) CGFloat scrollingWidth;


@property (strong, nonatomic) HistoryItemOverviewSource *overviewSource;
@property (strong, nonatomic) HistoryItemDelegateDataSource *addressesSource;
@property (strong, nonatomic) HistoryItemEventLogSource *eventLogSource;

@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;

@property (copy, nonatomic) ConversionResultHendler cellConvertHandler;


@end

static CGFloat buttonAlpha = 0.6;
static CGFloat buttonAlphaSelected = 1;

@implementation HistoryItemViewController

@synthesize delegate, receipt, item, logs;

- (void)viewDidLoad {

	[super viewDidLoad];

	[self configWithItem];
	[self configTables];
    [self configLocalization];
    [self configTabs];
    [self configCellRegistration];
    [self changeCurrentIndex:0];
	self.scrollView.delegate = self;
}

#pragma mark - Private Methods

- (void)configLocalization {
    
    self.titleTextLabel.text = NSLocalizedString(@"Transaction", @"Controllers Title");
    [self.addressesButton setTitle:NSLocalizedString(@"Addresses", @"Transaction detail button") forState:UIControlStateNormal];
    [self.owerviewButton setTitle:NSLocalizedString(@"Overview", @"Transaction detail button") forState:UIControlStateNormal];
    [self.eventLogButton setTitle:NSLocalizedString(@"Event Logs", @"Transaction detail button") forState:UIControlStateNormal];
}

- (void)configCellRegistration {
    
    [self.owerviewTableView registerNib:[UINib nibWithNibName:@"HistoryOverviewTableCell" bundle:nil] forCellReuseIdentifier:historyOverviewTableCellIdentifier];
    
    [self.eventLogTableView registerNib:[UINib nibWithNibName:@"HistoryEventLogAddressCell" bundle:nil] forCellReuseIdentifier:historyEventLogAddressCellIdentifier];
    
    [self.eventLogTableView registerNib:[UINib nibWithNibName:@"HistoryEventLogsConvertableDataCell" bundle:nil] forCellReuseIdentifier:historyEventLogsConvertableDataCellIdentifier];
}

- (void)configTabs {
    
    if (self.logs.count > 0) {
        self.scrollingWidth = [UIScreen mainScreen].bounds.size.width * 2;
        self.containerButtonsWidth.constant = [UIScreen mainScreen].bounds.size.width * 1;
    } else {
        self.scrollingWidth = [UIScreen mainScreen].bounds.size.width * 1;
        self.containerButtonsWidth.constant = [UIScreen mainScreen].bounds.size.width * 1.5;
    }
}

- (void)configTables {

	self.addressesSource = [HistoryItemDelegateDataSource new];
	self.addressesSource.item = self.item;

	self.overviewSource = [HistoryItemOverviewSource new];
    self.overviewSource.item = self.item;
    self.overviewSource.reciept = self.receipt;
    self.overviewSource.delegate = self;

    self.eventLogSource = [HistoryItemEventLogSource new];
    self.eventLogSource.delegate = self;
    self.eventLogSource.logs = self.logs;
    self.eventLogSource.tableView = self.eventLogTableView;

	self.addressesTableView.delegate = self.addressesSource;
	self.addressesTableView.dataSource = self.addressesSource;

	self.owerviewTableView.delegate = self.overviewSource;
	self.owerviewTableView.dataSource = self.overviewSource;
    self.owerviewTableView.estimatedRowHeight = 100;
    self.owerviewTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.eventLogTableView.delegate = self.eventLogSource;
    self.eventLogTableView.dataSource = self.eventLogSource;
    self.eventLogTableView.estimatedRowHeight = 100;
    self.eventLogTableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)configWithItem {

	self.balanceLabel.text = [self.item.amount roundedNumberWithScale:6].stringValue;
	self.receivedTimeLabel.text = self.item.fullDateString ? : NSLocalizedString(@"Unconfirmed", nil);
    self.cointType.text = self.item.currency;
    
    if ([self.item respondsToSelector:@selector(fee)]) {
        NSString* feeText = NSLocalizedString(@"Fee", "Fee text");
        NSString* feeString = self.item.fee.stringValue;
        NSString* curencyString = self.item.currency;
        NSString* resultString = [NSString stringWithFormat:@"%@: %@ %@", feeText, feeString, curencyString];
        self.feeLabel.text = resultString;
    } else {
        self.feeLabel.hidden = YES;
    }
}

-(ChooseConverterView*)dropListView {
    
    ChooseConverterView* view = [[[NSBundle mainBundle] loadNibNamed:@"ChooseConverterView" owner:self options:nil] objectAtIndex:0];
    return view;
}

- (void)changeCurrentIndex:(NSInteger) index {

    switch (index) {
        case 0:
            self.addressesButton.alpha = buttonAlphaSelected;
            self.owerviewButton.alpha = buttonAlpha;
            self.eventLogButton.alpha = buttonAlpha;
            break;
        case 1:
            self.addressesButton.alpha = buttonAlpha;
            self.owerviewButton.alpha = buttonAlphaSelected;
            self.eventLogButton.alpha = buttonAlpha;
            break;
        case 2:
            self.addressesButton.alpha = buttonAlpha;
            self.owerviewButton.alpha = buttonAlpha;
            self.eventLogButton.alpha = buttonAlphaSelected;
            break;
        default:
            break;
    }
}

-(void)scrollToIndex:(NSInteger) index {
    
    switch (index) {
        case 0:
            [self.scrollView scrollRectToVisible:CGRectMake(index * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
            break;
        case 1:
            [self.scrollView scrollRectToVisible:CGRectMake(index * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
            break;
        case 2:
            [self.scrollView scrollRectToVisible:CGRectMake(index * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
            break;
            
        default:
            break;
    }
}

#pragma mark - HistoryItemEventLogSourceDelegate

- (void)didChoseChangeValue {
    self.view.userInteractionEnabled = NO;
}

- (void)valueDidChange {
    self.view.userInteractionEnabled = YES;
}

- (void)didChoseChangeValue:(NSString *)value {
    
}

#pragma mark - HistoryEventLogsConvertableDataCellDelegate

- (void)convertValue:(NSString*) value frame:(CGRect)position withHandler:(ConversionResultHendler) handler {
    
    self.cellConvertHandler = handler;
    ChooseConverterView* view = [self dropListView];
    view.delegate = self;
    [view setOffset:position];
    UIView *window = [UIApplication sharedApplication].keyWindow;
    view.frame = window.bounds;
    [window addSubview:view];
    [view setNeedsLayout];
    
    view.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        view.alpha = 1;
    }];
}

#pragma mark - ChooseConverterViewDelegate

- (void)didChoseType:(ConvertionAddressType) type {
    
    self.cellConvertHandler(@"NEW RESULT", type);
}

#pragma mark - HistoryItemOverviewSourceDelegate

- (void)didPressedCopyWithValue:(NSString*) value {
    [self.delegate didPressedCopyWithValue:value];
}

#pragma mark - Actions

- (IBAction)actionBack:(id) sender {
    [self.delegate didBackPressed];
}

- (IBAction)actionAddresses:(id)sender {
    [self scrollToIndex:0];
}

- (IBAction)actionOwerview:(id)sender {
    [self scrollToIndex:1];
}

- (IBAction)actionEventLog:(id)sender {
    [self scrollToIndex:2];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *) scrollView {
    
    if (scrollView.contentOffset.x <= 0) {
        scrollView.contentOffset = CGPointMake (0, 0);
    } else if (scrollView.contentOffset.x >= self.scrollingWidth) {
        scrollView.contentOffset = CGPointMake (self.scrollingWidth, 0);
    }
    
    if ((NSInteger)scrollView.contentOffset.x % (NSInteger)scrollView.bounds.size.width == 0) {
        
        NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
        [self changeCurrentIndex:index];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *) scrollView withVelocity:(CGPoint) velocity targetContentOffset:(inout CGPoint *) targetContentOffset {
    
    if (scrollView.contentOffset.x <= 0) {
        scrollView.contentOffset = CGPointMake (0, 0);
    } else if (scrollView.contentOffset.x >= self.scrollingWidth) {
        scrollView.contentOffset = CGPointMake (self.scrollingWidth, 0);
    }
}



@end
