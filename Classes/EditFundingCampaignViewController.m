//
//  EditFundingCampaignViewController.m
//  WishizMe
//
//  Created by David Krasicki on 1/11/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import "EditFundingCampaignViewController.h"

@interface EditFundingCampaignViewController ()

@end

@implementation EditFundingCampaignViewController

-(id) init{
    
    [self.navigationController setNavigationBarHidden:NO];
    self.resizeWhenKeyboardPresented = YES;
    

    QRootElement *root = [[QRootElement alloc] init];
    
    root.title = @"Edit";
    
    root.grouped = YES;
    root.appearance = [QElement appearance];
    QAppearance *appearance2 = [QAppearance alloc];
    appearance2.backgroundColorEnabled = [UIColor colorWithRed:.28627 green:.396078 blue:.62352 alpha:1.0];
    
    
    QSection *wishImageTop = [[QSection alloc] init];
        
    wishImageTop.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    self.wishTopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    self.wishTopImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [wishImageTop.headerView addSubview:self.wishTopImageView];
    
    [root addSection:wishImageTop];

    QSection *wishSection = [[QSection alloc] initWithTitle: @"Title"];
    
    self.wishTitle = [[QEntryElement alloc] init];
    self.wishTitle.placeholder = @"Enter the title of your wish";
    self.wishTitle.title = @"Wish Title ";
    self.wishTitle.keyboardType = UIKeyboardTypeDefault;
    self.wishTitle.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    
    [wishSection addElement:self.wishTitle];
    [root addSection:wishSection];
    
    QSection *wishCost = [[QSection alloc] initWithTitle: @"Cost"];
    
    self.wishCost = [[QEntryElement alloc] init];
    self.wishCost.placeholder = @"How much does it cost?";
    self.wishCost.title = @"Wish Cost $";
    self.wishCost.keyboardType = UIKeyboardTypeDecimalPad;
    
    [wishCost addElement:self.wishCost];
    [root addSection:wishCost];
    
    
    QSection *wishDescription = [[QSection alloc] initWithTitle: @"Describe why you desire this wish"];
    
    self.wishDescription = [[QEntryElement alloc] init];
    self.wishDescription.placeholder = @"Why do you want it?";
    self.wishDescription.title = @"Description ";
    self.wishDescription.keyboardType = UITextAutocapitalizationTypeSentences;
    self.wishDescription.keyboardType = UIKeyboardTypeDefault;
    
    [wishDescription addElement:self.wishDescription];
    [root addSection:wishDescription];
    
    
    QSection *wishFinish = [[QSection alloc] initWithTitle: @"Click below to save your edits."];
    
    self.createFundingCampaign = [[QButtonElement alloc] initWithTitle:@"Edit Funding Campaign" Value:nil];
    QAppearance *appearance3 = [QAppearance alloc];
    appearance3.backgroundColorEnabled = [UIColor colorWithRed:0 green:.5608 blue:.0392 alpha:1.0];
    appearance3.backgroundColorDisabled = [UIColor greenColor];
    self.createFundingCampaign.appearance = appearance3;
    self.createFundingCampaign.appearance.buttonAlignment = NSTextAlignmentCenter;
    self.createFundingCampaign.appearance.actionColorDisabled =[UIColor whiteColor];
    self.createFundingCampaign.appearance.actionColorEnabled =[UIColor whiteColor];
    self.createFundingCampaign.controllerAction = @"editFundingCampaignButtonClicked";
    
    [wishFinish addElement:self.createFundingCampaign];
    [root addSection:wishFinish];
    
    self.root = root;
    
    self.navigationController.navigationBarHidden = NO;
    [self addBack:self.navigationItem];
    [self addDeleteButton:self.navigationItem];
    
    return self;
}

-(void)editFundingCampaignButtonClicked
{
    
    NSString *wishTitle = self.wishTitle.textValue;
    NSString *wishDescription = self.wishDescription.textValue;
    NSString *wishPrice = self.wishCost.textValue;
  
    if ([wishTitle length] == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter Title" message:@"Please enter a title for your wish." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else if ([wishDescription length] == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter Description" message:@"Please enter a description for your wish. Why do you want it?" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else if ([wishPrice length] == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter Cost" message:@"Please enter the approximate cost of your wish." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else{
        
        NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
        [dictParam setObject:[User currentUser].fbid forKey:PARAM_ENT_USER_FBID];
        [dictParam setObject:wishTitle forKey:@"title"];
        [dictParam setObject:wishDescription forKey:@"description"];
        [dictParam setObject:wishPrice forKey:@"price"];
        [dictParam setObject:self.wishId forKey:@"fundingCampaign_Id"];
        
        
            [[ProgressIndicator sharedInstance] showPIOnView:self.view withMessage:@"Saving..."];
            
            AFNHelper *afn=[[AFNHelper alloc]init];
            [afn getDataFromPath:@"editFundingCampaign" withParamData:dictParam withBlock:^(id response, NSError *error)
             {
                 if (response)
                 {
                     [[ProgressIndicator sharedInstance] hideProgressIndicator];
                     
                     if(response[@"success"] == 0){
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error has occurred. Please try again." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                         [alertView show];
                     }
                     else{
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Success! Your funding campaign has been created!" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                         [alertView show];
                         
                         FundingCampaignReviewTableViewController *bc=[[FundingCampaignReviewTableViewController alloc]initWithNibName:@"FundingCampaignReviewTableViewController" bundle:nil];
                         
                         bc.fundingCampaignTitle = wishTitle;
                         bc.fundingCampaignDescription = wishDescription;
                         bc.fundingCampaignId = response[@"fundingCampaignId"];
                         bc.fundingCampaignPrice = wishPrice;
                         
                         [self.navigationController pushViewController:bc animated:NO];
                     }
                 }
                 else{
                     [[ProgressIndicator sharedInstance] hideProgressIndicator];
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error has occurred. Please try again." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alertView show];
                 }
                 
             }];
        }

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

-(void)addDeleteButton:(UINavigationItem*)naviItem
{
    UIImage *imgButton = [UIImage imageNamed:@"chat_icon_off_line.png"];
    UIButton *rightbarbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbarbutton setFrame:CGRectMake(0, 0, imgButton.size.width+20, imgButton.size.height)];
    [rightbarbutton setTitle:@"Del" forState:UIControlStateNormal];
    [rightbarbutton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    naviItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbarbutton];
}

- (void)deleteButtonPressed:(UIBarButtonItem *)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to delete this campaign?" delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Cancel", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        //delete campaign
        
        NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
        [dictParam setObject:[User currentUser].fbid forKey:PARAM_ENT_USER_FBID];
        [dictParam setObject:self.wishId forKey:@"fundingCampaign_Id"];

        [[ProgressIndicator sharedInstance] showPIOnView:self.view withMessage:@"Deleting..."];
        
        AFNHelper *afn=[[AFNHelper alloc]init];
        [afn getDataFromPath:@"deleteFundingCampaign" withParamData:dictParam withBlock:^(id response, NSError *error)
         {
             if (response)
             {
                 [[ProgressIndicator sharedInstance] hideProgressIndicator];
                 
                 if(response[@"success"] == 0){
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error has occurred. Please try again." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alertView show];
                 }
                 else{
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Success! Your funding campaign has been deleted." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alertView show];
                     
                     
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
             }
             else{
                 [[ProgressIndicator sharedInstance] hideProgressIndicator];
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error has occurred. Please try again." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [alertView show];
             }
             
         }];
        
    }
    else{
        //cancel
    }
}

@end
