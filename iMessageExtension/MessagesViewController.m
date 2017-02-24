 //
//  MessagesViewController.m
//  iMessageExtension
//
//  Created by Никита Федоренко on 23.02.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "MessagesViewController.h"
#import "GradientView.h"

@interface MessagesViewController ()

@property (weak, nonatomic) IBOutlet UIButton *goToHostButton;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageWithAdress;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) NSString *adress;
@property (strong, nonatomic) NSString *amount;
@property (assign, nonatomic) BOOL isHasWallet;

@property (weak, nonatomic) IBOutlet UIButton *requestExpandButton;

@property (weak, nonatomic) IBOutlet UIButton *mainActionButton;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UIView *textFieldUnderline;
@property (weak, nonatomic) IBOutlet UILabel *amountValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;

@property (weak, nonatomic) IBOutlet UIView *compactPresentationView;
@property (weak, nonatomic) IBOutlet UIView *expandedPresentationVIew;
@property (weak, nonatomic) IBOutlet UIView *sendMessageExpandView;
@property (weak, nonatomic) IBOutlet UIView *createWalletExpandView;

@end

static NSString* isHasWalletKey = @"isHasWallet";
static NSString* adressKey = @"adress";
static NSString* registerText = @"You have no wallets yet. Tap to create one.";
static NSString* sendAdressText = @"Send your adress";
static NSString* createWalletButtonText = @"Create wallet";
static NSString* sendAdressButtonText = @"Send adress";

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc]
                                  initWithSuiteName:@"group.com.pixelplex.qtum-wallet"];
    NSString* boolAsString = [myDefaults valueForKey:isHasWalletKey];
    self.isHasWallet = [boolAsString isEqualToString:@"YES"] ? YES : NO;
    self.adress = [myDefaults valueForKey:adressKey];
    self.sendMessageWithAdress.hidden = !self.isHasWallet;
    self.goToHostButton.hidden = self.isHasWallet;
    self.textLabel.text = self.isHasWallet ? sendAdressText : registerText;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)GoToHost:(id)sender {
    [self.extensionContext openURL:[NSURL URLWithString:@"host://"] completionHandler:^(BOOL success) {
        NSLog(@"Opened HostApp - %@", success ? @"Yes" : @"NO");
    }];
}

- (IBAction)actionSendMessage:(id)sender {

    MSConversation* conversation = self.activeConversation;
    MSSession* session;
    MSMessage* message;

    if ([self.activeConversation.localParticipantIdentifier isEqual:self.activeConversation.selectedMessage.senderParticipantIdentifier]) {
        session = self.activeConversation.selectedMessage.session;
        message = self.activeConversation.selectedMessage;
    } else {
        session = [[MSSession alloc] init];
        message = [[MSMessage alloc] initWithSession:session];
    }
    MSMessageTemplateLayout* layout = [MSMessageTemplateLayout new];
    layout.image = [self imageForMessage];
    message.layout = layout;
    message.shouldExpire = YES;
    message.URL = [self createUrlForMessage];
    [conversation insertMessage:message completionHandler:nil];
    [self requestPresentationStyle:MSMessagesAppPresentationStyleCompact];
}

-(void)gotoHostFromMessage:(MSMessage*)message {
    NSString* adress = [self getAdressFromMessage:message];
    NSString* amount = [self getAmountFromMessage:message];
    [self openHostWithAdress:adress andAmount:amount];
}

-(NSURL*)createUrlForMessage{
    NSURLComponents* components = [NSURLComponents new];
    NSURLQueryItem* adress = [[NSURLQueryItem alloc] initWithName:@"adress" value:self.adress];
    NSURLQueryItem* amount = [[NSURLQueryItem alloc] initWithName:@"amount" value:self.amountTextField.text];
    components.queryItems = @[adress,amount];
    return components.URL;
}
- (IBAction)actionCreateWallet:(id)sender {
    [self.extensionContext openURL:[NSURL URLWithString:@"host://"] completionHandler:^(BOOL success) {
        NSLog(@"Opened HostApp - %@", success ? @"Yes" : @"NO");
    }];
}

- (IBAction)actionVoidTap:(id)sender {
    [self.view endEditing:YES];
}

-(void)openHostWithAdress:(NSString*)adress andAmount:(NSString*)amount{
    NSString* stringUrl = [NSString stringWithFormat:@"%@adressAndAmount/?adress=%@&amount=%@",@"host://",adress,amount];
    [self.extensionContext openURL:[NSURL URLWithString:stringUrl] completionHandler:^(BOOL success) {
        NSLog(@"Opened HostApp - %@", success ? @"Yes" : @"NO");
    }];
}

-(UIImage*)imageForMessage{
    GradientView* backView = [[GradientView alloc] initWithFrame:CGRectMake(self.view.frame.size.width,  self.view.frame.size.height, 300, 300)];
    backView.backgroundColor = [UIColor blackColor];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(75, 75, 150, 150)];
    label.text = [NSString stringWithFormat:@"I need %@ qtum",self.amountTextField.text.length > 0 ? self.amountTextField.text : @"some"];
    [label sizeToFit];
    label.textColor = [UIColor whiteColor];
    [backView addSubview:label];
    [self.view addSubview:backView];
    UIGraphicsBeginImageContextWithOptions(backView.frame.size, NO, [UIScreen mainScreen].scale);
    [backView drawViewHierarchyInRect:backView.bounds afterScreenUpdates:YES];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [backView removeFromSuperview];
    return image;
}

-(void)updateControlsWithSyle:(MSMessagesAppPresentationStyle) style{
    BOOL isExpand = (self.presentationStyle == MSMessagesAppPresentationStyleExpanded);
    BOOL isMineMessage = ([self.activeConversation.localParticipantIdentifier isEqual:self.activeConversation.selectedMessage.senderParticipantIdentifier] || !self.activeConversation.selectedMessage);
    if (isExpand) {
        if (isMineMessage) {
            if (self.isHasWallet) {
                [self prepareSendingAdressWithControll];
            } else {
                [self prepareCreateWallet];
            }
        } else {
            if (self.isHasWallet) {
                [self gotoHostFromMessage:self.activeConversation.selectedMessage];
            }else {
                [self prepareCreateWallet];
            }
        }
    } else {
        self.compactPresentationView.hidden = NO;
        self.expandedPresentationVIew.hidden = YES;
    }
}

-(void)prepareSendingAdressWithControll{
    self.sendMessageExpandView.hidden = NO;
    self.createWalletExpandView.hidden = YES;
    self.compactPresentationView.hidden = YES;
    self.expandedPresentationVIew.hidden = NO;
    self.adressLabel.text = [self getAdressFromMessage:self.activeConversation.selectedMessage];
    self.amountValueLabel.text = [self getAmountFromMessage:self.activeConversation.selectedMessage];
}

-(void)prepareSendingAdressWithoutControll{
    self.compactPresentationView.hidden = YES;
    self.expandedPresentationVIew.hidden = NO;
    self.textLabel.text = [self getAdressFromMessage:self.activeConversation.selectedMessage];;
    self.textLabel.hidden = NO;
    self.amountTextField.hidden = YES;
    self.textFieldUnderline.hidden = YES;
    self.mainActionButton.hidden = YES;
    self.amountValueLabel.hidden = NO;
    self.amountValueLabel.text = [self getAmountFromMessage:self.activeConversation.selectedMessage];
}

-(void)prepareCreateWallet{
    self.sendMessageExpandView.hidden = YES;
    self.createWalletExpandView.hidden = NO;
    self.expandedPresentationVIew.hidden = NO;
    self.compactPresentationView.hidden = YES;
}


-(NSString*)getAdressFromMessage:(MSMessage*)message{
    if (!message) {
        return self.adress;
    }
    NSURLComponents* components = [[NSURLComponents alloc] initWithURL:message.URL resolvingAgainstBaseURL:NO];
    NSString* adress;
    for (NSURLQueryItem* item in components.queryItems) {
        if ([item.name isEqualToString:@"adress"]) {
            adress = item.value;
        }
    }
    return adress;
}

-(NSString*)getAmountFromMessage:(MSMessage*)message{
    if (!message) {
        return nil;
    }
    NSURLComponents* components = [[NSURLComponents alloc] initWithURL:message.URL resolvingAgainstBaseURL:NO];
    NSString* amount;
    for (NSURLQueryItem* item in components.queryItems) {
        if ([item.name isEqualToString:@"amount"]) {
            amount = item.value;
        }
    }
    return amount;
}
#pragma mark - Conversation Handling

-(void)didBecomeActiveWithConversation:(MSConversation *)conversation {
    [self updateControlsWithSyle:self.presentationStyle];
}

-(void)willResignActiveWithConversation:(MSConversation *)conversation {
  
}

-(void)willBecomeActiveWithConversation:(MSConversation *)conversation{
}
- (IBAction)actionReauestExpand:(id)sender {
    [self requestPresentationStyle:MSMessagesAppPresentationStyleExpanded];
}

-(void)didReceiveMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when a message arrives that was generated by another instance of this
    // extension on a remote device.
    
    // Use this method to trigger UI updates in response to the message.
}

-(void)didStartSendingMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when the user taps the send button.
}

-(void)didCancelSendingMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when the user deletes the message without sending it.
    
    // Use this to clean up state related to the deleted message.
}

-(void)willTransitionToPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle {

}

-(void)didTransitionToPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle {
    [self updateControlsWithSyle:presentationStyle];
}

@end
