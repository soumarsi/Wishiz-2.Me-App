//
//  FundingCampaignsTableViewController.m
//  WishizMe
//
//  Created by David Krasicki on 1/4/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import "FundingCampaignsTableViewController.h"

@interface FundingCampaignsTableViewController ()

@end

@implementation FundingCampaignsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [APPDELEGATE addBackButton:self.navigationItem];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];

    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation_bar_logo"]];
    
    //[self getUserFundingCampaigns:[User currentUser].profile_id];
    [self addRightButton:self.navigationItem];
}

-(void)addRightButton:(UINavigationItem*)naviItem
{
    UIButton *rightbarbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbarbutton setFrame:CGRectMake(0, 0, 60, 42)];
    [rightbarbutton setTitle:@"View All" forState:UIControlStateNormal];
    [rightbarbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightbarbutton.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:12];
    
    [rightbarbutton addTarget:self action:@selector(pushViewProfile) forControlEvents:UIControlEventTouchUpInside];
    naviItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbarbutton];
}

- (void)pushViewProfile {
    ProfileVC *vc=[[ProfileVC alloc]initWithNibName:@"ProfileVC" bundle:nil];
    [[User currentUser] setUser];
    User*  profileUser = [User currentUser];
    vc.user = profileUser;
    
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.revealSideViewController popViewControllerWithNewCenterController:n
                                                                   animated:YES];
    [self.revealSideViewController setDelegate:vc];
    PP_RELEASE(vc);
    PP_RELEASE(n);
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
             [self.tableView reloadData];
         }
     }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return self.fundingCampaigns.count + 4;
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0)
    {
        return 438;
    }
    else if(indexPath.row == 1)
    {
        return 248;
    }
    else if(indexPath.row == 2)
    {
        return 248;
    }
    /*else if(indexPath.row == 3)
    {
        return 47;
    }
    else
    {
        return 135;
    }*/
    
}

-(void) showCustomProduct
{

    CreateFundingCampaignViewController *createCampaign = [[CreateFundingCampaignViewController alloc] init:3];
    
    createCampaign.wishType = 3;
    
    [self.navigationController pushViewController:createCampaign animated:NO];
}


-(void) showProductSearch: (NSString *) searchTerm
{
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setObject:searchTerm forKey:@"searchterm"];
    
    [self.view endEditing:YES];
    [[ProgressIndicator sharedInstance] showPIOnView:self.view withMessage:@"Searching..."];
    
    AFNHelper *afn=[[AFNHelper alloc]init];
    [afn getDataFromPath:@"searchAmazonProducts" withParamData:dictParam withBlock:^(id response, NSError *error)
     {
         if (response)
         {
             
             BrowseWishizTableViewController *bc=[[BrowseWishizTableViewController alloc]initWithNibName:@"BrowseWishizTableViewController" bundle:nil];
             
             bc.wishiz = response;
             bc.wishType = 1;
             
             [self.navigationController pushViewController:bc animated:NO];
             
             [[ProgressIndicator sharedInstance] hideProgressIndicator];
         }
     }];

}

-(void) showPopularProducts
{
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    
    [self.view endEditing:YES];
    [[ProgressIndicator sharedInstance] showPIOnView:self.view withMessage:@"Searching..."];
    
    AFNHelper *afn=[[AFNHelper alloc]init];
    [afn getDataFromPath:@"getFeaturedProducts" withParamData:dictParam withBlock:^(id response, NSError *error)
     {
         if (response)
         {
             
             BrowseWishizTableViewController *bc=[[BrowseWishizTableViewController alloc]initWithNibName:@"BrowseWishizTableViewController" bundle:nil];
             
             bc.wishiz = response;
             bc.wishType = 2;
             
             [self.navigationController pushViewController:bc animated:NO];
             
             [[ProgressIndicator sharedInstance] hideProgressIndicator];
         }
     }];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch(indexPath.row)
    {
        case 0:
        {
            FundingCampaignOpt1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"FundingCampaignOpt1Cell"];
            
            if(cell == nil){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FundingCampaignOpt1Cell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.delegate = self;
            
            //cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        case 1:
        {
            FundingCampaignOpt2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"FundingCampaignOpt2Cell"];
            
            if(cell == nil){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FundingCampaignOpt2Cell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.delegate = self;
            
            //cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        case 2:
        {
            FundingCampaignOpt3Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"FundingCampaignOpt3Cell"];
            
            if(cell == nil){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FundingCampaignOpt3Cell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.delegate = self;
            //cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        case 3:
        {
            FundingCampaignsCountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FundingCampaignsCountCell"];
            
            if(cell == nil){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FundingCampaignsCountCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.fundCampCount.text = [NSString stringWithFormat:@"%@%i%@",@"You have ",self.fundingCampaigns.count, @" campaigns"];
            
            //cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        default:
        {
            FundingCampaignCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FundingCampaignCell"];
            
            if(cell == nil){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FundingCampaignCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            NSMutableDictionary *fundingCampaign = [self.fundingCampaigns objectAtIndex: indexPath.row - 4];
            cell.fundingCampaignTitle.text = fundingCampaign[@"title"];
            cell.fundingCampaignDescription.text = fundingCampaign[@"description"];
            cell.fundingCampaignId = fundingCampaign[@"id"];
            cell.fundingCampaignPrice = fundingCampaign[@"retail_amount"];
            
            [cell.fundButton setTitle:@"Manage" forState:UIControlStateNormal];
            
            NSString *imageURL = [NSString stringWithFormat:@"%@%@%@%@",USER_FILES_URL,@"fundingCampaign_icon_", fundingCampaign[@"id"], @".jpg"];
            [cell.fundingCampaignImage sd_setImageWithURL:[NSURL URLWithString:imageURL]
                                         placeholderImage:nil];
            
            //cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }
    
}

@end
