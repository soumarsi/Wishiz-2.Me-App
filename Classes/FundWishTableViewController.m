//
//  FundWishTableViewController.m
//  WishizMe
//
//  Created by David Krasicki on 12/15/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//

#import "FundWishTableViewController.h"
#import "ProfileVC.h"
#import "Report.h"
#import "Chat/JSDemoViewController.h"

@interface FundWishTableViewController ()<UITextFieldDelegate,Fundswishcell,UIAlertViewDelegate,UITextViewDelegate,Report>{
    
    UITextView *mess;
    UIButton *send;
    NSOperationQueue *queue;
}


@end

@implementation FundWishTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     viewRep = [[Report alloc]init];
    queue = [[NSOperationQueue alloc]init];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    //set back button arrow color
    self.view.backgroundColor = [UIColor clearColor];//------PK
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //[self addrightButton:self.navigationItem];
    [self addRightButton:self.navigationItem];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation_bar_logo"]];
    
    [self addLeftButton:self.navigationItem];
    [self getUserCreditBalance];
}

-(void) viewWillAppear:(BOOL)animated{
    [self getUserCreditBalance];
    [self.tableView reloadData];
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
-(void)submitRep:(UIButton *)sender
{
    if([viewRep.textView.text isEqualToString:@"What is your reason for reporting this user?"] || [viewRep.textView.text isEqualToString:@""]){
        
        blankCheck = [[UIAlertView alloc]initWithTitle:@"Wishiz" message:@"Please type your reason" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        blankCheck.tag = 10;
        [blankCheck show];
        
        
    }else{
        
        NSLog(@"report");
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@reportUser",API_URL]];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        
        // 2
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"POST";
        
        // 3
        NSDictionary *profiledict = @{@"user_profile_id": [User currentUser].profile_id,@"reported_profile_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"otherProfileId"],@"reason":viewRep.textView.text};
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:profiledict options:kNilOptions error:&error];
        
        if (!error) {
            // 4
            NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                                       fromData:data completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                                                                           // Handle response here
                                                                           
                                                                           DebugLog(@"RESPONSE-------> %@",response);
                                                                           DebugLog(@"DATA RETURN---->%@",data);
                                                                           
                                                                           NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                                           
                                                                           DebugLog(@"SUCCESS------- %@",[dict objectForKey:@"success"]);
                                                                           
//                                                                           [queue addOperationWithBlock:^{
                                                                           
                                                                               
                                                                               [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                                                                                   
                                                                                   
                                                                                   if ([[dict objectForKey:@"success"] isEqualToString:@"1"]) {
                                                                                       alertStatus = [[UIAlertView alloc]initWithTitle:@"Wishiz" message:@"Successfully submitted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                                                       
                                                                                       [alertStatus show];
                                                                                       
                                                                                   }else{
                                                                                       
                                                                                       alertStatus = [[UIAlertView alloc]initWithTitle:@"Wishiz" message:@"Operation failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                                                       [alertStatus show];
                                                                                       
                                                                                   }

                                                                                   
                                                                                   
                                                                               }];
                                                                               
//                                                                           }];
                                                                           
                                                                           
                                                                       }];
            
            // 5
            [uploadTask resume];
        }
        
    }
    
}
-(void)done:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)addRightButton:(UINavigationItem*)naviItem
{
    UIButton *rightbarbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbarbutton setFrame:CGRectMake(0, 0, 60, 42)];
    
//    =================PK===============//
    
    DebugLog(@"ASCHEEEE----->%@", self.comingFrom);
    
    if ([self.comingFrom isEqualToString:@"fundWish"]) {
        
        [rightbarbutton setTitle:@"Report" forState:UIControlStateNormal];
        [rightbarbutton addTarget:self action:@selector(reportPage:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        
        [rightbarbutton setTitle:@"Credits" forState:UIControlStateNormal];
        [rightbarbutton addTarget:self action:@selector(pushBuyCreditsPage:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self addLeftButton:self.navigationItem];
    
//    [rightbarbutton setTitle:@"Credits" forState:UIControlStateNormal];
    [rightbarbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightbarbutton.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:12];
//    [rightbarbutton addTarget:self action:@selector(pushBuyCreditsPage:) forControlEvents:UIControlEventTouchUpInside];
    naviItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbarbutton];
        
    
}

//===============REPORT HEADER BAR RIGHT BUTTON==============//
//-(void)addLeftButton:(UINavigationItem*)naviItem
//{
//    UIButton *leftbarbutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftbarbutton setFrame:CGRectMake(0, 0, 60, 42)];
//    [leftbarbutton setTitle:@"Credits" forState:UIControlStateNormal];
//    [leftbarbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    leftbarbutton.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:12];
//    
//    [leftbarbutton addTarget:self action:@selector(reportItem:) forControlEvents:UIControlEventTouchUpInside];
//    naviItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftbarbutton];
//}

-(IBAction)pushBuyCreditsPage:(id)sender
{
    BuyCreditsTableViewController *bc=[[BuyCreditsTableViewController alloc]initWithNibName:@"BuyCreditsTableViewController" bundle:nil];
    [self.navigationController pushViewController:bc animated:NO];
}
-(IBAction)reportPage:(id)sender{
    
//    ReportViewController *navTo = [[ReportViewController alloc]initWithNibName:@"ReportViewController" bundle:nil];
//    NSString *imageURL = [NSString stringWithFormat:@"%@%@%@%@",USER_FILES_URL,@"fundingCampaign_icon_", self.fundingCampaignId, @".jpg"];
//    navTo.profileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
//    [self.navigationController pushViewController:navTo animated:NO];
    UIAlertView *alertMe = [[UIAlertView alloc]initWithTitle:@"Wishiz!" message:@"Are you sure that you want to report this wish?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    
    [alertMe show];
    
}
- (void)alertView:(UIAlertView *)alertView  //=========PK
clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 10){
        
        DebugLog(@"BLANK TEXT VIEW");
        
    }else{
    
    if (buttonIndex == [alertView cancelButtonIndex]){
        //cancel clicked ...do your action
        DebugLog(@"NO PRESSED---------->");
        
        [viewRep removeFromSuperview];
        
    }else{
        //reset clicked
        DebugLog(@"YES PRESSED--------->");
        
       
        viewRep.frame = CGRectMake(10.0f, 230.0f, viewRep.frame.size.width, viewRep.frame.size.height);
        viewRep.textView.delegate = self;
        [self.view addSubview:viewRep];
        
//        if ([viewRep.status isEqualToString:@"yes"]) {
//            
//            UIAlertView *alertMe = [[UIAlertView alloc]initWithTitle:@"Wishiz" message:@"Successfuly submitted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alertMe show];
//            
//        }else{
//            
//            UIAlertView *alertMe = [[UIAlertView alloc]initWithTitle:@"Wishiz" message:@"Operation failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alertMe show];
//
//            
       }
        
    }
}
- (void)pushBuyCredits {
    BuyCreditsTableViewController *bc=[[BuyCreditsTableViewController alloc]initWithNibName:@"BuyCreditsTableViewController" bundle:nil];
    [self.navigationController pushViewController:bc animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0)
    {
        return 248;
    }
    else if(indexPath.row == 1)
    {
        return 370;
    }
//    else if(indexPath.row == 2)
//    {
//        return 179;
//    }
//    else if(indexPath.row == 3)
//    {
//        return 90;
//    }
//    else if(indexPath.row == 4)
//    {
//        return 90;
//    }
//    else if(indexPath.row == 5)
//    {
//        return 90;
//    }
    else{
        return 0;
    }
}

-(void) sendCredits: (NSString*)message creditAmount:(NSString*)credits{
    
    
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setObject:[User currentUser].profile_id forKey:@"user_profile_id"];
    [dictParam setObject:self.userProfileId forKey:@"receiving_user_profile_id"];
    [dictParam setObject:self.fundingCampaignId forKey:@"funding_campaign_id"];
    [dictParam setObject: credits forKey:@"credit_amount"];
    [dictParam setObject: message forKey:@"personal_message"];
    
    [[ProgressIndicator sharedInstance] showPIOnView:self.view withMessage:@"Sending..."];
    
    AFNHelper *afn=[[AFNHelper alloc]init];
    [afn getDataFromPath:@"sendCredits" withParamData:dictParam withBlock:^(id response, NSError *error)
     {
         if (response)
         {
             [[ProgressIndicator sharedInstance] hideProgressIndicator];
             
             if(response[@"success"] == 0){
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error has occurred. Please try again." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [alertView show];
             }
             else{
                 
                 NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
                 [dictParam setObject:[User currentUser].fbid forKey:PARAM_ENT_USER_FBID];
                 [dictParam setObject:@"1" forKey:PARAM_ENT_USER_ACTION];
                 [dictParam setObject:self.userProfileId forKey:PARAM_ENT_INVITEE_FBID];
                 
                 AFNHelper *afn=[[AFNHelper alloc]init];
                 [afn getDataFromPath: METHOD_INVITEACTION withParamData:dictParam withBlock:^(id response, NSError *error) {
                     
                     if (response) {
                         if ([[response objectForKey:@"errFlag"] intValue]==0) {
                             
                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Credits Sent!" message:[NSString stringWithFormat:@"You have sent %@ credits! The user must respond to your message within 48 hours or your credits will be refunded.", credits] delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                             [alertView show];
                             
                             [self.navigationController popViewControllerAnimated:YES];
                             
                         }else{
                             [[TinderAppDelegate sharedAppDelegate]showToastMessage:[response objectForKey:@"errMsg"]];
                         }
                         //[self settingResponse:response];
                     }
                     else{
                         [[TinderAppDelegate sharedAppDelegate]showToastMessage:@"Failed to send, try again."];
                     }
                 }];
             }
         }
         else{
             [[ProgressIndicator sharedInstance] hideProgressIndicator];
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error has occurred. Please try again." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alertView show];
         }
     }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog("%i", indexPath.row);
    switch(indexPath.row)
    {
        case 0:
        {
            FundWishIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FundWishIntroCell"];
            
            if(cell == nil){
                
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FundWishIntroCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                cell.wishTitle.text = self.fundingCampaignTitle;
                [[NSUserDefaults standardUserDefaults]setObject:self.fundingCampaignTitle forKey:@"itemName"];
                
                NSString *imageURL = [NSString stringWithFormat:@"%@%@%@%@",USER_FILES_URL,@"fundingCampaign_icon_", self.fundingCampaignId, @".jpg"];
                
                [cell.wishImage sd_setImageWithURL:[NSURL URLWithString:imageURL]
                                             placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                //[cell.wishImage setImage: [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]]];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        case 1:
        {
            FundWishUserCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FundWishUserCell"];
//            cell.frame = CGRectMake(0.0f, -100.0f, cell.frame.size.width, cell.frame.size.height);
            if(cell == nil){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FundWishUserCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                
                cell.userSaysDescription.text = self.fundingCampaignDescription; 
                cell.userSaysTitle.text = [NSString stringWithFormat:@"%@%@",self.user.real_name, @" Says:"];
                [cell.userImage sd_setImageWithURL:[NSURL URLWithString:self.user.profile_pic]
                                  placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                //[cell.userImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.user.profile_pic]]]];
                
                //-------For checking if sex is null value------
                
                DebugLog(@"USER SEX---->%@",self.user.sex);
                
                if ([self.user.sex isKindOfClass:NULL]) {
                    
                    cell.desc.text = [NSString stringWithFormat:@"Send a message to %@ about %@ wish! It's easy!",self.user.real_name,self.fundingCampaignTitle];
                }else{
                    
                    if ([self.user.sex isEqualToString:@"2"]) {
                        
                        cell.desc.text = [NSString stringWithFormat:@"Send a message to %@ about her %@ wish! It's easy!",self.user.real_name,self.fundingCampaignTitle];
                    }else{
                
                    cell.desc.text = [NSString stringWithFormat:@"Send a message to %@ about his %@ wish! It's easy!",self.user.real_name,self.fundingCampaignTitle];
                    }
                    
                }
                
                mess = [[UITextView alloc]initWithFrame:CGRectMake(0.0f, cell.frame.origin.y+cell.frame.size.height-62, cell.frame.size.width-70, 60.0f)];
                mess.backgroundColor = [UIColor colorWithRed:62.0f/255.0f green:153.0f/255.0f blue:114.0f/255.0f alpha:0.6f];
                mess.userInteractionEnabled = YES;
                mess.delegate = self;
//                [mess setTitle:@"    New Message" forState:UIControlStateNormal];
//                [mess addTarget:self action:@selector(chatView:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:mess];
                
                send = [[UIButton alloc]initWithFrame:CGRectMake(mess.frame.origin.x+mess.frame.size.width, cell.frame.origin.y+cell.frame.size.height-62, cell.frame.size.width-250, 60.0f)];
                send.backgroundColor = [UIColor colorWithRed:62.0f/255.0f green:153.0f/255.0f blue:114.0f/255.0f alpha:1.0f];
                [send setTitle:@"SEND" forState:UIControlStateNormal];
                send.showsTouchWhenHighlighted=YES;
                [send setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [send setUserInteractionEnabled:YES];
                [send addTarget:self action:@selector(chatView:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:send];
                
                
            
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        /*case 2:
        {
            FundWishGuaranteedResponseCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FundWishGuaranteedResponseCell"];
            
            if(cell == nil){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FundWishGuaranteedResponseCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                
                cell.guaranteeLabel.text = [NSString stringWithFormat: @"Wishiz.me offers a 100%% response guarantee. By funding %@'s Wishiz, you are guaranteed a response to your message within 48 hours!", self.user.real_name];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }*/
//        case 2:
//        {
//            FundCampaignCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FundCampaignCell"];
//            
//            if(cell == nil){
//                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FundCampaignCell" owner:self options:nil];
//                cell = [nib objectAtIndex:0];
//                
//                cell.howManyCreditsIntro.text = [NSString stringWithFormat: @"How many credits do you wish to send to %@ to help fund this wish?", self.user.real_name];
//            }            
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            
//            return cell;
//        }
//        case 3:
//        {
//            FundSend1CreditCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FundSend1CreditCell"];
//            
//            if(cell == nil){
//                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FundSend1CreditCell" owner:self options:nil];
//                cell = [nib objectAtIndex:0];
//            
//            }
//            
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            
//            return cell;
//        }
//        case 4:
//        {
//            FundSend5CreditCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FundSend5CreditCell"];
//            
//            if(cell == nil){
//                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FundSend5CreditCell" owner:self options:nil];
//                cell = [nib objectAtIndex:0];
//                
//            }
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            
//            return cell;
//        }
//        case 5:
//        {
//            FundSend10CreditCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FundSend10CreditCell"];
//            
//            if(cell == nil){
//                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FundSend10CreditCell" owner:self options:nil];
//                cell = [nib objectAtIndex:0];
//                
//            }
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            
//            return cell;
//        }
        default:
        {
            
        }

    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch(indexPath.row)
    {
        case 0:
        {
            //do nothing
            break;
        }
        case 1:
        {
            //do nothing
            break;
        }
//        case 2:
//        {
//            [self pushBuyCredits];
//            break;
//        }
//        case 3:
//        {
//            if(self.creditfloat > 0){
//                SendCreditsTableTableViewController *bc=[[SendCreditsTableTableViewController alloc]initWithNibName:@"SendCreditsTableTableViewController" bundle:nil];
//                
//                bc.fundingCampaignDescription = self.fundingCampaignDescription;
//                bc.fundingCampaignId = self.fundingCampaignId;
//                bc.fundingCampaignTitle = self.fundingCampaignTitle;
//                bc.user = self.user;
//                bc.sendCreditAmount = @"1";
//                bc.delegate = self;
//                
//                [self.navigationController pushViewController:bc animated:NO];
//            }
//            else
//            {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Credits" message:@"You do not have any credits. Please buy credits to continue." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alertView show];
//            }
//            
//            break;
//        }
//        case 4:
//        {
//            if(self.creditfloat > 4){
//                SendCreditsTableTableViewController *bc=[[SendCreditsTableTableViewController alloc]initWithNibName:@"SendCreditsTableTableViewController" bundle:nil];
//            
//                bc.fundingCampaignDescription = self.fundingCampaignDescription;
//                bc.fundingCampaignId = self.fundingCampaignId;
//                bc.fundingCampaignTitle = self.fundingCampaignTitle;
//                bc.user = self.user;
//                bc.sendCreditAmount = @"5";
//                bc.delegate = self;
//                [self.navigationController pushViewController:bc animated:NO];
//                
//            }
//            else{
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Not Enough Credits" message:@"You do not have enough credits. Please buy more credits to continue." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alertView show];
//            }
//            break;
//        }
//        case 5:
//        {
//            if(self.creditfloat > 9){
//                SendCreditsTableTableViewController *bc=[[SendCreditsTableTableViewController alloc]initWithNibName:@"SendCreditsTableTableViewController" bundle:nil];
//            
//                bc.fundingCampaignDescription = self.fundingCampaignDescription;
//                bc.fundingCampaignId = self.fundingCampaignId;
//                bc.fundingCampaignTitle = self.fundingCampaignTitle;
//                bc.user = self.user;
//                bc.sendCreditAmount = @"10";
//                bc.delegate = self;
//                [self.navigationController pushViewController:bc animated:NO];
//            }
//            else{
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Not Enough Credits" message:@"You do not have enough credits. Please buy more credits to continue." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alertView show];
//            }
//            break;
//        }
        default:
        {
            return;
        }
    }
    
    
}

-(void)chatView:(UIButton *)sender{
    
    
    [[NSUserDefaults standardUserDefaults]setObject:@"otherProfileChat" forKey:@"fromWhere"];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    
    User *user = [User alloc];
    
    JSDemoViewController *vc = [[JSDemoViewController alloc] init];
    vc.userFriend=user;//[[NSUserDefaults standardUserDefaults] objectForKey:@"otherProfileId"];//-------PK 0
    vc.friendProfileId = [User currentUser].profile_id;
    vc.status = @"";
    vc.ChatPersonNane =[[NSUserDefaults standardUserDefaults] objectForKey:@"otherRealName"];
    vc.siteconvid = [User currentUser].siteconvid;
    vc.matchid = [User currentUser].matchid;
    vc.matchedUserProfileImagePath = [[NSUserDefaults standardUserDefaults] objectForKey:@"otherProfilePic"];
    [dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"otherFBid"] forKey:@"fbId"];
    [dict setValue:@"" forKey:@"status"];
    [dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"otherUsername"] forKey:@"fName"];
    [dict setValue:[User currentUser].profile_pic forKey:@"proficePic"];
    
    vc.getMess = mess.text;
    vc.fromFundWishVC = @"yes";
    
    vc.dictUser = dict;
    
//    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController pushViewController:vc animated:NO];

}
//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    
//    DebugLog(@"TEXT FIELD SHOULD BEGIN EDITING");
//    
//    self.view.frame = CGRectMake(0.0f, -180.0f, self.view.frame.size.width, self.view.frame.size.height);
////    DebugLog(@"TEXTFIELD ======> %@",self.view.frame);
//    return YES;
//    
//}
//-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    
//    [textField resignFirstResponder];
//    self.view.frame = CGRectMake(0, self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height, [[UIScreen mainScreen] bounds].size.width, self.view.frame.size.height);
//    
//    return YES;
//    
//}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    self.view.frame = CGRectMake(0.0f, -180.0f, self.view.frame.size.width, self.view.frame.size.height);
    viewRep.textView.text = @"";
    return YES;
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
//    viewRep.textView.text = @"";
    
    
    if([text isEqualToString:@"\n"]) {
        
        self.view.frame = CGRectMake(0, self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height, [[UIScreen mainScreen] bounds].size.width, self.view.frame.size.height);
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
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
             
             self.creditfloat = creditFloat;
             
         }
     }];
}

@end
