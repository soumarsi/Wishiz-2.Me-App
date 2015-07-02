//
//  ProfileVC.m
//  Tinder
//
//  Created by Elluminati - macbook on 12/06/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//

#import "ProfileVC.h"
#import "UIImageView+Download.h"
#import "EditProfileVC.h"

@interface ProfileVC ()

@end

@implementation ProfileVC

@synthesize user;

#pragma mark -
#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -
#pragma mark - ViewLife Cycle

- (void)viewDidLoad
{
    DebugLog(@"ProfileViewController");
    
    [super viewDidLoad];
    
//    =======PK======
    
    viewRep = [[Report alloc]init];
    queue = [[NSOperationQueue alloc]init];
    
    arrImages=[[NSMutableArray alloc]init];
    currentPage=0;
    
    [self.navigationItem setTitle:@"Profile"];
    self.navigationController.navigationBarHidden = NO;
    
    if (user.profile_id == [User currentUser].profile_id) {
        [APPDELEGATE addBackButton:self.navigationItem];
    }else{
        [self addLeftButton:self.navigationItem];
        
        
        [self addRightButton:self.navigationItem];
    }
    
    [self.pcImage setNumberOfPages:[arrImages count]];
    [self.pcImage setCurrentPage:currentPage];
    [self getUserFundingCampaigns:user.profile_id];
}

-(void) getUserFundingCampaigns:(NSString *) profile_id
{
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setObject:profile_id forKey:PARAM_ENT_USER_PROFILE_ID];
    
    AFNHelper *afn=[[AFNHelper alloc]init];
    [afn getDataFromPath:METHOD_GET_FUNDING_CAMPAIGNS withParamData:dictParam withBlock:^(id response, NSError *error)
     {
         if (response)
         {
             self.fundingCampaigns = response;
             [self.profileTableView reloadData];
         }
     }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

#pragma mark -
#pragma mark - NavButton Methods

-(void)addrightButton:(UINavigationItem*)naviItem
{
	UIButton *rightbarbutton = [UIButton buttonWithType:UIButtonTypeCustom];
	[rightbarbutton setFrame:CGRectMake(0, 0,51, 25)];
    [rightbarbutton setImage:[UIImage imageNamed:@"btnEditProfile"] forState:UIControlStateNormal];
    [rightbarbutton addTarget:self action:@selector(editProfile) forControlEvents:UIControlEventTouchUpInside];
    naviItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbarbutton];
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

-(void)addLeftButton:(UINavigationItem*)naviItem
{
	UIButton *leftbarbutton = [UIButton buttonWithType:UIButtonTypeCustom];
	[leftbarbutton setFrame:CGRectMake(0, 0, 60, 42)];
    [leftbarbutton setTitle:@"Done" forState:UIControlStateNormal];
    [leftbarbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftbarbutton.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:15];
    
    [leftbarbutton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    naviItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftbarbutton];
}

-(void)addRightButton:(UINavigationItem*)naviItem
{
    UIButton *rightbarbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbarbutton setFrame:CGRectMake(0, 0, 60, 42)];
    [rightbarbutton setTitle:@"Report" forState:UIControlStateNormal];//--------------PK
    [rightbarbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightbarbutton.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:12];
    
    [rightbarbutton addTarget:self action:@selector(reportPage:) forControlEvents:UIControlEventTouchUpInside];
    naviItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbarbutton];
}
-(IBAction)reportPage:(id)sender{
    
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
            
            
            viewRep.frame = CGRectMake(10.0f, 150.0f, viewRep.frame.size.width, viewRep.frame.size.height);
            viewRep.textView.delegate = self;
            [self.view addSubview:viewRep];
            
        }
        
    }
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
                                                                           
                                                                           DebugLog(@"------- %@",[dict objectForKey:@"success"]);
                                                                           
                                                                           [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                                                                               
                                                                               if ([[dict objectForKey:@"success"] isEqualToString:@"1"]) {
                                                                                   alertStatus = [[UIAlertView alloc]initWithTitle:@"Wishiz" message:@"Successfully submitted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                                                   
                                                                                   [alertStatus show];
                                                                                   
                                                                               }else{
                                                                                   
                                                                                   alertStatus = [[UIAlertView alloc]initWithTitle:@"Wishiz" message:@"Operation failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                                                   
                                                                                   [alertStatus show];
                                                                                   
                                                                               }

                                                                               
                                                                           }];
                                                                           
                                                                       }];
            
            // 5
            [uploadTask resume];
        }
        
    }
    
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    viewRep.textView.text = @"";
    return YES;
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    //    viewRep.textView.text = @"";
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void)done:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

-(IBAction)pushBuyCreditsPage:(id)sender
{
    BuyCreditsTableViewController *bc=[[BuyCreditsTableViewController alloc]initWithNibName:@"BuyCreditsTableViewController" bundle:nil];
    [self.navigationController pushViewController:bc animated:NO];
}

#pragma mark -
#pragma mark - Methods


-(NSInteger) numberOfSectionsInTableView: (UITableView *) tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.fundingCampaigns.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0)
    {
        return 529;
    }
    else{
        return 135;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.row)
    {
        case 0:
        {
            return;
            //do nothing
        }
        default:
        {
            if (user.profile_id == [User currentUser].profile_id)
            {
                FundingCampaignReviewTableViewController *bc=[[FundingCampaignReviewTableViewController alloc]initWithNibName:@"FundingCampaignReviewTableViewController" bundle:nil];
                
                NSMutableDictionary *fundingCampaign = [self.fundingCampaigns objectAtIndex: indexPath.row - 1];
                
                bc.fundingCampaignTitle = fundingCampaign[@"title"];
                bc.fundingCampaignDescription = fundingCampaign[@"description"];
                bc.fundingCampaignId = fundingCampaign[@"id"];
                bc.fundingCampaignPrice = fundingCampaign[@"retail_amount"];
                
                [self.navigationController pushViewController:bc animated:NO];
            }
            else
            {
                FundWishTableViewController *viewCampaign = [[FundWishTableViewController alloc] initWithNibName:@"FundWishTableViewController" bundle:nil];
                
                NSMutableDictionary *fundingCampaign = [self.fundingCampaigns objectAtIndex: indexPath.row - 1];
                
                viewCampaign.fundingCampaignTitle = fundingCampaign[@"title"];
                viewCampaign.fundingCampaignDescription = fundingCampaign[@"description"];
                viewCampaign.fundingCampaignId =fundingCampaign[@"id"];
                viewCampaign.user = self.user;
                viewCampaign.userProfileId = self.user_profile_id;
                viewCampaign.comingFrom = @"fundWish";
                [self.navigationController pushViewController:viewCampaign animated:NO];
            }
        }
    }
    
    
}


-(UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch(indexPath.row)
    {
        case 0:
        {
            ProfileViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileViewTableCell"];
            
            if(cell == nil){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProfileViewTableCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                
                if (user==nil) {
                    [cell getUserProfile:[User currentUser].profile_id];
                }else{
                    [cell getUserProfile:user.profile_id];
                }
            }
            
            
            
            if(self.fundingCampaigns.count > 0)
            {
                if (user.profile_id == [User currentUser].profile_id)
                {
                    cell.fundWishizTitle.text = @"My Wishiz";
                }
                else
                {
                    cell.fundWishizTitle.text = [NSString stringWithFormat:@"%@'s WISHIZ",self.user.real_name];//@"Please help fund my Wishiz!";
                }
            }
            else
            {
                cell.fundWishizTitle.text = @"No Wishiz Yet.";
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        default:
        {
            FundingCampaignCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FundingCampaignCell"];
                
            if(cell == nil){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FundingCampaignCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
                
            NSMutableDictionary *fundingCampaign = [self.fundingCampaigns objectAtIndex: indexPath.row - 1];
            cell.fundingCampaignTitle.text = fundingCampaign[@"title"];
            cell.fundingCampaignDescription.text = fundingCampaign[@"description"];
            cell.fundingCampaignId = fundingCampaign[@"id"];
            cell.fundingCampaignPrice = fundingCampaign[@"price"];
            
            if (user.profile_id == [User currentUser].profile_id)
            {
                [cell.fundButton setTitle:@"Manage" forState:UIControlStateNormal];
            }
            else{
                [cell.fundButton setTitle:@"Break The Ice" forState:UIControlStateNormal];//-----PK
            }
            
                
            NSString *imageURL = [NSString stringWithFormat:@"%@%@%@%@",USER_FILES_URL,@"fundingCampaign_icon_", fundingCampaign[@"id"], @".jpg"];
            [cell.fundingCampaignImage sd_setImageWithURL:[NSURL URLWithString:imageURL]
                                             placeholderImage:nil];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            return cell;
        }
    }
}

-(void)setScroll
{
    int x=0;
    int i = 0;
    for (id key in arrImages)
    {
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(x, 0, self.scrImage.frame.size.width, self.scrImage.frame.size.height)];
        
        NSString *url = [arrImages objectForKey:key];
        
        [img downloadFromURL:url withPlaceholder:nil];
        img.tag=1000+i;
        [self.scrImage addSubview:img];
        x+=self.scrImage.frame.size.width;
        i++;
    }
    [self.scrImage setContentSize:CGSizeMake(x, self.scrImage.frame.size.height)];
    [self.pcImage setNumberOfPages:[arrImages count]];
    [self.pcImage setCurrentPage:currentPage];
}

-(void)editProfile
{
    EditProfileVC *editPC=[[EditProfileVC alloc]initWithNibName:@"EditProfileVC" bundle:nil];
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:editPC];
    [self presentViewController:navC animated:NO completion:nil];
}

#pragma mark -
#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = self.scrImage.frame.size.width;
    currentPage = floor((self.scrImage.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pcImage.currentPage = currentPage  ;
}

- (IBAction)changePage
{
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrImage.frame.size.width * self.pcImage.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrImage.frame.size;
    [self.scrImage scrollRectToVisible:frame animated:YES];
}

#pragma mark -
#pragma mark - PPRevealSideViewController Delegate

- (BOOL) pprevealSideViewController:(PPRevealSideViewController *)controller shouldDeactivateGesture:(UIGestureRecognizer*)gesture forView:(UIView*)view
{
    if ([view isEqual:self.scrImage] || [view isKindOfClass:[UITableViewCell class]] || [NSStringFromClass([view class]) hasPrefix:@"UITableView"])
    {
        return YES;
    }
    return NO;
}

#pragma mark -
#pragma mark - Memory Mgmt

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
