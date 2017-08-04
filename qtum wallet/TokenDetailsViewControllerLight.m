//
//  TokenDetailsViewControllerLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 24.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "TokenDetailsViewControllerLight.h"
#import "HistoryHeaderVIew.h"

@interface TokenDetailsViewControllerLight () <TokenDetailDisplayDataManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *shortInfoHeader;
@property (weak, nonatomic) IBOutlet UILabel *availibleBalanceShortInfoLabel;
@property (weak, nonatomic) IBOutlet UIView *navigationBarView;

@end

@implementation TokenDetailsViewControllerLight

@synthesize delegate, token, source;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configTableView];
    
    self.titleLabel.text = (self.token.name && self.token.name.length > 0) ? self.token.name : NSLocalizedString(@"Token Details", nil);
    
    [self updateControls];
}

#pragma mark - Configuration

-(void)configTableView {
    
    self.source.delegate = self;
    self.tableView.dataSource = self.source;
    self.tableView.delegate = self.source;
    [self.tableView reloadData];
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"HistoryTableHeaderViewLight" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    
    //REFRESH CONTROLL BACKGROUND
    CGRect frame = self.tableView.bounds;
    frame.origin.y = - frame.size.height;
    UIView *refreshBackgroundView = [[UIView alloc] initWithFrame:frame];
    refreshBackgroundView.backgroundColor = lightDarkBlueColorForGradient();
    [self.tableView insertSubview:refreshBackgroundView atIndex:0];
}

#pragma mark - Update

-(void)updateControls {
    self.availibleBalanceShortInfoLabel.text = [NSString stringWithFormat:@"%f",token.balance];
}

#pragma mark - Actions

- (IBAction)actionShare:(id)sender {
    [self.delegate didShareTokenButtonPressed];
}

- (IBAction)actionBack:(id)sender {
    [self.delegate didBackPressed];
}

- (IBAction)actionPlus:(id)sender {
    [self.delegate showAddressInfoWithSpendable:self.token];
}

- (IBAction)didPressTokenAddressControl:(id)sender {
    [self.delegate didShowTokenAddressControlWith:self.token];
}

#pragma mark - TokenDetailDisplayDataManagerDelegate

- (void)updateWithYOffset:(CGFloat) offset {
    
    [self updateWithOffsetNavBarView:offset];
    [self updateWithOffsetShortInfoView:offset];
}

#pragma mark - Updating depend on scroll

- (void)updateWithOffsetShortInfoView:(CGFloat) offset {
    
    CGFloat startFadingPoint = offset - 200;  //DETERMINE POINT WHEN SHOUD START FAIDING WITHOFFSET
    
    CGFloat fullAlphaLastPoin; //DETERMINE POINT WHEN OFFSET SHOUD START FAIDING TO 0
    CGFloat emptyAlphaFirstPoiny;//DETERMINE POINT WHEN OFFSET SHOUD BE 0
    
    fullAlphaLastPoin = self.shortInfoHeader.frame.origin.y;
    emptyAlphaFirstPoiny = self.shortInfoHeader.frame.origin.y + self.shortInfoHeader.frame.size.height;
    
    self.shortInfoHeader.alpha = 1 - (fullAlphaLastPoin - startFadingPoint) / (emptyAlphaFirstPoiny - fullAlphaLastPoin);
}

- (void)updateWithOffsetNavBarView:(CGFloat) offset {
    
    CGFloat startFadingPoint = offset - 100;  //DETERMINE POINT WHEN SHOUD START FAIDING WITHOFFSET
    
    CGFloat fullAlphaLastPoin; //DETERMINE POINT WHEN OFFSET SHOUD START FAIDING TO 0
    CGFloat emptyAlphaFirstPoiny;//DETERMINE POINT WHEN OFFSET SHOUD BE 0
    
    fullAlphaLastPoin = self.navigationBarView.frame.origin.y;
    emptyAlphaFirstPoiny = self.navigationBarView.frame.origin.y + self.navigationBarView.frame.size.height;
    
    self.navigationBarView.alpha = (fullAlphaLastPoin - startFadingPoint) / (emptyAlphaFirstPoiny - fullAlphaLastPoin);
}



@end
