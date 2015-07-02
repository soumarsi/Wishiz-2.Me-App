//
//  WithDrawCreditsViewController.m
//  WishizMe
//
//  Created by David Krasicki on 1/17/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import "WithDrawCreditsViewController.h"

@interface WithDrawCreditsViewController ()

@end

@implementation WithDrawCreditsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.resizeWhenKeyboardPresented = YES;
}

-(void) viewWillAppear:(BOOL)animated{
    [self getUserCreditBalance];
}


-(id) init{
    
    [self.navigationController setNavigationBarHidden:NO];
    self.resizeWhenKeyboardPresented = YES;

    
    //if((self = [super initWithCoder:aDecoder])){
    QRootElement *root = [[QRootElement alloc] init];
    

    root.title = @"Withdraw Credits";

    root.grouped = YES;
    root.appearance = [QElement appearance];
    QAppearance *appearance2 = [QAppearance alloc];
    appearance2.backgroundColorEnabled = [UIColor colorWithRed:.28627 green:.396078 blue:.62352 alpha:1.0];

    
    QSection *creditbalSection = [[QSection alloc] initWithTitle: @"Your Current Balance"];
    
    self.creditbal = [[QLabelElement alloc] init];
    self.creditbal.title = @"Balance ";
    self.creditbal.value = self.creditstr;
    
    [creditbalSection addElement:self.creditbal];
    [root addSection:creditbalSection];

    
    
    QSection *creditSection = [[QSection alloc] initWithTitle: @"Credit Amount"];
    
    self.creditsToWithdraw = [[QEntryElement alloc] init];
    self.creditsToWithdraw.placeholder = @"How many credits do you want to Withdraw?";
    self.creditsToWithdraw.title = @"Credits to Withdraw ";
    self.creditsToWithdraw.keyboardType = UIKeyboardTypeNumberPad;

    [creditSection addElement:self.creditsToWithdraw];
    [root addSection:creditSection];
    
    
    QSection *paypalEmailSec = [[QSection alloc] initWithTitle: @"Paypal Account"];
    
    self.paypalEmailAddress = [[QEntryElement alloc] init];
    self.paypalEmailAddress.placeholder = @"Enter your paypal email address";
    self.paypalEmailAddress.title = @"Paypal Email ";
    self.paypalEmailAddress.keyboardType = UITextAutocapitalizationTypeSentences;
    self.paypalEmailAddress.keyboardType = UIKeyboardTypeEmailAddress;
    
    [paypalEmailSec addElement:self.paypalEmailAddress];
    [root addSection:paypalEmailSec];
    
    
    QSection *wishFinish = [[QSection alloc] initWithTitle: @"That's it! Click below to finish."];
    
    self.createFundingCampaign = [[QButtonElement alloc] initWithTitle:@"Submit Withdraw Request" Value:nil];
    QAppearance *appearance3 = [QAppearance alloc];
    appearance3.backgroundColorEnabled = [UIColor colorWithRed:0 green:.5608 blue:.0392 alpha:1.0];
    appearance3.backgroundColorDisabled = [UIColor greenColor];
    self.createFundingCampaign.appearance = appearance3;
    self.createFundingCampaign.appearance.buttonAlignment = NSTextAlignmentCenter;
    self.createFundingCampaign.appearance.actionColorDisabled =[UIColor whiteColor];
    self.createFundingCampaign.appearance.actionColorEnabled =[UIColor whiteColor];
    self.createFundingCampaign.controllerAction = @"submitWithdrawButtonClicked";
    
    [wishFinish addElement:self.createFundingCampaign];
    [root addSection:wishFinish];
    
    self.root = root;
    
    self.navigationController.navigationBarHidden = NO;
    [self addBack:self.navigationItem];
    
    return self;
}


-(void)submitWithdrawButtonClicked
{
    
    if(self.creditfloat >19){
        NSString *creditsToWithdraw = self.creditsToWithdraw.textValue;
        NSString *paypalEmailAddress = self.paypalEmailAddress.textValue;
        
        
        if ([creditsToWithdraw length] == 0){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter Credit Amount" message:@"Please enter how many credits you wish to withdraw." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
        else if ([paypalEmailAddress length] == 0){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter Paypal Email" message:@"Please enter your Paypal email address." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
        else{
            
            NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
            [dictParam setObject:[User currentUser].profile_id forKey:@"profile_id"];
            [dictParam setObject:creditsToWithdraw forKey:@"withdrawcredits"];
            [dictParam setObject:paypalEmailAddress forKey:@"paypalemailaddress"];
            
            
            [[ProgressIndicator sharedInstance] showPIOnView:self.view withMessage:@"Processing..."];
            
            AFNHelper *afn=[[AFNHelper alloc]init];
            [afn getDataFromPath:@"withdrawCredits" withParamData:dictParam withBlock:^(id response, NSError *error)
             {
                 if (response)
                 {
                     [[ProgressIndicator sharedInstance] hideProgressIndicator];
                     
                     if(response[@"success"] == 0){
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error has occurred. Please try again." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                         [alertView show];
                     }
                     else{
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Your withdraw request has been successfully submitted. Please allow 5 to 10 days for processing." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                         [alertView show];
                         
                         [self.navigationController popViewControllerAnimated:YES];                     }
                 }
                 else{
                     [[ProgressIndicator sharedInstance] hideProgressIndicator];
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error has occurred. Please try again." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alertView show];
                 }
                 
             }];
            
        }
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Not Enough Credits" message:@"You need at least 20 credits to withdraw." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    
}

-(void) getUserCreditBalance
{
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    User *curUser = [User currentUser];
    [dictParam setObject:curUser.fbid forKey:PARAM_ENT_FBID];
    
    AFNHelper *afn=[[AFNHelper alloc]init];
    [afn getDataFromPath:METHOD_GET_USER_CREDIT_BALANCE withParamData:dictParam withBlock:^(id response, NSError *error)
     {
         if (response)
         {
             NSNumber *credits = response[@"credits"];
             self.creditfloat = [credits floatValue];
             self.creditstr = [credits stringValue];
             self.creditbal.value = self.creditstr;
             [self.quickDialogTableView reloadData];
         }
     }];
}

-(void)addBack:(UINavigationItem*)naviItem
{
    UIImage *imgButton = [UIImage imageNamed:@"chat_icon_off_line.png"];
    UIButton *rightbarbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbarbutton setFrame:CGRectMake(0, 0, imgButton.size.width+20, imgButton.size.height)];
    [rightbarbutton setTitle:@"Back" forState:UIControlStateNormal];
    [rightbarbutton addTarget:self action:@selector(buttonBackPressed:) forControlEvents:UIControlEventTouchUpInside];
    naviItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbarbutton];
}

- (void)buttonBackPressed:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
