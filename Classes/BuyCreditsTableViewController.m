//
//  BuyCreditsTableViewController.m
//  WishizMe
//
//  Created by David Krasicki on 12/14/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//

#import "BuyCreditsTableViewController.h"

@interface BuyCreditsTableViewController ()
@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;

@end

@implementation BuyCreditsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation_bar_logo"]];
    
    [self getUserCreditBalance];
    [self getCreditPackages];
    
    [self addLeftButton:self.navigationItem];
    
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentProduction];
    _payPalConfiguration = [[PayPalConfiguration alloc] init];
    
    // See PayPalConfiguration.h for details and default values.
    // Should you wish to change any of the values, you can do so here.
    // For example, if you wish to accept PayPal but not payment card payments, then add:
    _payPalConfiguration.acceptCreditCards = YES;
    // Or if you wish to have the user choose a Shipping Address from those already
    // associated with the user's PayPal account, then add:
    _payPalConfiguration.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _payPalConfiguration = [[PayPalConfiguration alloc] init];
        
        // See PayPalConfiguration.h for details and default values.
        // Should you wish to change any of the values, you can do so here.
        // For example, if you wish to accept PayPal but not payment card payments, then add:
        _payPalConfiguration.acceptCreditCards = YES;
        // Or if you wish to have the user choose a Shipping Address from those already
        // associated with the user's PayPal account, then add:
        _payPalConfiguration.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    }
    return self;
}

-(void)addLeftButton:(UINavigationItem*)naviItem
{
    UIButton *leftbarbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbarbutton setFrame:CGRectMake(0, 0, 60, 42)];
    [leftbarbutton setTitle:@"Back" forState:UIControlStateNormal];
    [leftbarbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftbarbutton.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:15];
    
    [leftbarbutton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    naviItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftbarbutton];
}

-(void)done:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)addBackToMessage:(UINavigationItem*)naviItem
{
    UIImage *imgButton = [UIImage imageNamed:@"chat_icon_off_line.png"];
    UIButton *rightbarbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbarbutton setFrame:CGRectMake(0, 0, imgButton.size.width+20, imgButton.size.height)];
    [rightbarbutton setTitle:@"Done" forState:UIControlStateNormal];
    [rightbarbutton addTarget:self action:@selector(BackToMassageController:) forControlEvents:UIControlEventTouchUpInside];
    naviItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbarbutton];
}
-(void)BackToMassageController:(UIButton*)sender
{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
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
             float creditFloat = [credits floatValue];
             //NSString *priceString = [NSString stringWithFormat:@"%f", price];
             self.userCreditBalance = [NSString stringWithFormat:@"%@%@", @"Your Credit Balance: ", [NSString stringWithFormat:@"%.0f", creditFloat]];
             //self.userCreditBalance =
             [self.tableView reloadData];
         }
     }];
}

-(void) getCreditPackages
{
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    //[dictParam setObject:profile_id forKey:PARAM_ENT_USER_PROFILE_ID];
    
    AFNHelper *afn=[[AFNHelper alloc]init];
    [afn getDataFromPath:METHOD_GET_CREDIT_PACKAGES withParamData:dictParam withBlock:^(id response, NSError *error)
     {
         if (response)
         {
             self.creditPackages = response;
             [self.tableView reloadData];
         }
     }];
}

-(void) buyPackage: (NSString*)packageTitle creditamount:(NSString*)credits packageCost:(NSString*)packageprice packageId:(NSString*)packageid{
    
    // Create a PayPalPayment
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    
    // Amount, currency, and description
    //NSString *dollaramount = [packageprice stringByReplacingOccurrencesOfString:@"$" withString:@""];
    payment.amount = [[NSDecimalNumber alloc] initWithString:packageprice];
    payment.currencyCode = @"USD";
    payment.shortDescription = packageTitle;
    
    self.selectedCreditPackageId = packageid;
    // Use the intent property to indicate that this is a "sale" payment,
    // meaning combined Authorization + Capture.
    // To perform Authorization only, and defer Capture to your server,
    // use PayPalPaymentIntentAuthorize.
    // To place an Order, and defer both Authorization and Capture to
    // your server, use PayPalPaymentIntentOrder.
    // (PayPalPaymentIntentOrder is valid only for PayPal payments, not credit card payments.)
    payment.intent = PayPalPaymentIntentSale;
    
    // If your app collects Shipping Address information from the customer,
    // or already stores that information on your server, you may provide it here.
    //payment.shippingAddress = address; // a previously-created PayPalShippingAddress object
    
    // Several other optional fields that you can set here are documented in PayPalPayment.h,
    // including paymentDetails, items, invoiceNumber, custom, softDescriptor, etc.
    payment.custom = packageid;
    
    // Check whether payment is processable.
    if (!payment.processable) {
        // If, for example, the amount was negative or the shortDescription was empty, then
        // this payment would not be processable. You would want to handle that here.
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"This payment is not processable. Please try again." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else{
        // Create a PayPalPaymentViewController.
        PayPalPaymentViewController *paymentViewController;
        paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                       configuration:self.payPalConfiguration
                                                                            delegate:self];
        
        // Present the PayPalPaymentViewController.
        [self presentViewController:paymentViewController animated:YES completion:nil];
    }   
    
}

-(void) withdrawCredits
{
    WithDrawCreditsViewController *bc=[[WithDrawCreditsViewController alloc]init];
    [self.navigationController pushViewController:bc animated:NO];
}

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(PayPalPayment *)completedPayment {
    // Payment was processed successfully; send to server for verification and fulfillment.
    [self verifyCompletedPayment:completedPayment];
    
    // Dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    // The payment was canceled; dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)verifyCompletedPayment:(PayPalPayment *)completedPayment {
    // Send the entire confirmation dictionary
    NSData *confirmation = [NSJSONSerialization dataWithJSONObject:completedPayment.confirmation
                                                           options:0
        
                                                             error:nil];
    
    NSDictionary *confirmationDetails =  completedPayment.confirmation;
    // Send confirmation to your server; your server should verify the proof of payment
    // and give the user their goods or services. If the server is not reachable, save
    // the confirmation and try again later.
    NSDictionary * response = confirmationDetails[@"response"];
    NSDictionary * client = confirmationDetails[@"client"];
    NSString *response_type = confirmationDetails[@"response_type"];
    
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    User *curUser = [User currentUser];

    [dictParam setObject:curUser.profile_id forKey:@"user_profile_id"];
    [dictParam setObject:response[@"create_time"] forKey:@"create_time"];
    [dictParam setObject:response[@"id"] forKey:@"id"];
    [dictParam setObject:response[@"state"] forKey:@"state"];
    [dictParam setObject:response[@"intent"] forKey:@"intent"];
    [dictParam setObject:response_type forKey:@"response_type"];
    [dictParam setObject:self.selectedCreditPackageId forKey:@"creditpackageid"];
    
    [[ProgressIndicator sharedInstance] showPIOnView:self.view withMessage:@"Processing..."];
    
    AFNHelper *afn=[[AFNHelper alloc]init];
    [afn getDataFromPath:@"buyCreditPackage" withParamData:dictParam withBlock:^(id response, NSError *error)
     {
         if (response)
         {
             [[ProgressIndicator sharedInstance] hideProgressIndicator];
             
             if([response[@"success"] isEqualToString:@"0"]){
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error has occurred. Please try again." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [alertView show];
             }
             else{
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Success! Your order is complete!" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [alertView show];
                 
                 [self getUserCreditBalance];
                 //FundingCampaignReviewTableViewController *bc=[[FundingCampaignReviewTableViewController alloc]initWithNibName:@"FundingCampaignReviewTableViewController" bundle:nil];
                 
                 //[self.navigationController pushViewController:bc animated:NO];
             }
         }
         else{
             [[ProgressIndicator sharedInstance] hideProgressIndicator];
         }
         
     }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    return self.creditPackages.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0)
    {
        return 380;
    }
    else{
        return 158;
    }
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.row)
    {
        case 0:
        {
            //do nothing
        }
        case 1:
        {
            NSLog(@"one");
        }
        case 2:
        {
            NSLog(@"two");
        }
        case 3:
        {
            NSLog(@"three");
        }
        default:
        {
            NSLog(@"else");
        }
    }
    
    
}*/



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch(indexPath.row)
    {
        case 0:
        {
            BuyCreditIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuyCreditIntroCell"];
            
            if(cell == nil){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BuyCreditIntroCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                cell.delegate = self;
                cell.userCreditBalance.text = self.userCreditBalance;
            }
            
            return cell;
        }
        default:
        {
            CreditPackageCell *cell =[tableView dequeueReusableCellWithIdentifier:@"CreditPackageCell"];

            if(cell == nil){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CreditPackageCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                
                NSMutableDictionary *creditPackage = [self.creditPackages objectAtIndex: indexPath.row - 1];
                NSString *packageTitle = @"";
                
                if([creditPackage[@"package_id"] isEqualToString:@"1"]){
                    packageTitle = @"Value Package";
                }else if([creditPackage[@"package_id"] isEqualToString:@"2"]){
                    packageTitle = @"Popular Package";
                }else if([creditPackage[@"package_id"] isEqualToString:@"10"]){
                    packageTitle = @"Elite Package";
                }else{
                    packageTitle = @"Credit Package";
                }
                cell.delegate = self;
                cell.creditAmount.text = creditPackage[@"points"];
                cell.creditPackageTitle.text = packageTitle;
                cell.creditPackageDescription.text = creditPackage[@"description"];
                cell.creditPackageId = creditPackage[@"package_id"];
                
                
                NSNumber *price =  [creditPackage objectForKey:@"price"];
                float priceFloat = [price floatValue];
                //NSString *priceString = [NSString stringWithFormat:@"%f", price];
                cell.creditPackageDollarAmount = [NSString stringWithFormat:@"%.02f", priceFloat];
                cell.creditPackagePrice.text = [NSString stringWithFormat:@"%@%@", @"Only $", [NSString stringWithFormat:@"%.02f", priceFloat]];
                
            }else{
                NSMutableDictionary *creditPackage = [self.creditPackages objectAtIndex: indexPath.row - 1];
                NSString *packageTitle = @"";
                
                if([creditPackage[@"package_id"] isEqualToString:@"1"]){
                    packageTitle = @"Value Package";
                }else if([creditPackage[@"package_id"] isEqualToString:@"2"]){
                    packageTitle = @"Popular Package";
                }else if([creditPackage[@"package_id"] isEqualToString:@"10"]){
                    packageTitle = @"Elite Package";
                }else{
                    packageTitle = @"Credit Package";
                }
                
                cell.creditAmount.text = creditPackage[@"points"];
                cell.creditPackageTitle.text = packageTitle;
                cell.creditPackageDescription.text = creditPackage[@"description"];
                cell.creditPackageId = creditPackage[@"package_id"];

                
                NSNumber *price =  [creditPackage objectForKey:@"price"];
                float priceFloat = [price floatValue];
                cell.creditPackageDollarAmount = [NSString stringWithFormat:@"%.02f", priceFloat];
                //NSString *priceString = [NSString stringWithFormat:@"%f", price];
                cell.creditPackagePrice.text = [NSString stringWithFormat:@"%@%@", @"Only $", [NSString stringWithFormat:@"%.02f", priceFloat]];
            }
            
            return cell;
        }
    }
    
    
    //return cell;
}



@end
