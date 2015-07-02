//
//  CreateFundingCampaignViewController.m
//  WishizMe
//
//  Created by David Krasicki on 1/10/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import "CreateFundingCampaignViewController.h"

@interface CreateFundingCampaignViewController ()

@end

@implementation CreateFundingCampaignViewController
-(void) viewWillAppear:(BOOL)animated{
    
    self.resizeWhenKeyboardPresented = YES;
}

-(id) init: (NSInteger) wishType{
    
    [self.navigationController setNavigationBarHidden:NO];
    self.resizeWhenKeyboardPresented = YES;
    self.wishType = wishType;
    
    //if((self = [super initWithCoder:aDecoder])){
    QRootElement *root = [[QRootElement alloc] init];
    
    if(wishType != 3){
        root.title = @"You Selected";
    }
    else{
        root.title = @"Create Custom Wish";
    }
    
    root.grouped = YES;
    root.appearance = [QElement appearance];
    QAppearance *appearance2 = [QAppearance alloc];
    appearance2.backgroundColorEnabled = [UIColor colorWithRed:.28627 green:.396078 blue:.62352 alpha:1.0];
    
    if(wishType != 3){
        QSection *wishImageTop = [[QSection alloc] init];
        
        wishImageTop.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        self.wishTopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        self.wishTopImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [wishImageTop.headerView addSubview:self.wishTopImageView];
        
        [root addSection:wishImageTop];
    }
    else{
        QSection *wishImage = [[QSection alloc] initWithTitle: @"Image"];
        self.wishImage = [[QImageElement alloc] init];
        self.wishImage.title = @"Image of Wish";
        [wishImage addElement:self.wishImage];
        [root addSection:wishImage];
    }
    
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
     
    
    QSection *wishFinish = [[QSection alloc] initWithTitle: @"That's it! Click below to finish."];
    
    self.createFundingCampaign = [[QButtonElement alloc] initWithTitle:@"Create Funding Campaign" Value:nil];
    QAppearance *appearance3 = [QAppearance alloc];
    appearance3.backgroundColorEnabled = [UIColor colorWithRed:0 green:.5608 blue:.0392 alpha:1.0];
    appearance3.backgroundColorDisabled = [UIColor greenColor];
    self.createFundingCampaign.appearance = appearance3;
    self.createFundingCampaign.appearance.buttonAlignment = NSTextAlignmentCenter;
    self.createFundingCampaign.appearance.actionColorDisabled =[UIColor whiteColor];
    self.createFundingCampaign.appearance.actionColorEnabled =[UIColor whiteColor];
    self.createFundingCampaign.controllerAction = @"createFundingCampaignButtonClicked";

    [wishFinish addElement:self.createFundingCampaign];
    [root addSection:wishFinish];

    
    self.root = root;
    
    self.navigationController.navigationBarHidden = NO;
    [self addBack:self.navigationItem];
    
    return self;
}

-(void)createFundingCampaignButtonClicked
{
    
    NSString *wishTitle = self.wishTitle.textValue;
    NSString *wishDescription = self.wishDescription.textValue;
    NSString *wishPrice = self.wishCost.textValue;
    NSString *wishImage = self.selectedWish[@"img"];
    
    
    if(self.wishImage.imageValue == nil && self.wishType == 3){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Select Image" message:@"An image of your wish is required" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else if ([wishTitle length] == 0){
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
        
        if(self.wishType != 3){
            [dictParam setObject:wishImage forKey:@"image"];
            [dictParam setObject:self.selectedWish[@"brand"] forKey:@"brand"];
            [dictParam setObject:self.selectedWish[@"category"] forKey:@"category"];
            [dictParam setObject:self.selectedWish[@"department"] forKey:@"department"];
            [dictParam setObject:self.selectedWish[@"partner_url"] forKey:@"partner_url"];
            [dictParam setObject:self.selectedWish[@"img"] forKey:@"sm_image"];
            [dictParam setObject:self.selectedWish[@"lg_image"] forKey:@"lg_image"];
            [dictParam setObject:self.selectedWish[@"hash"] forKey:@"hash"];
        }
        
        
        
        
        if(self.wishType == 1){
            
            [[ProgressIndicator sharedInstance] showPIOnView:self.view withMessage:@"Saving..."];
            
            AFNHelper *afn=[[AFNHelper alloc]init];
            [afn getDataFromPath:@"createAmazonFundingCampaign" withParamData:dictParam withBlock:^(id response, NSError *error)
             {
                 if (response)
                 {
                     [[ProgressIndicator sharedInstance] hideProgressIndicator];
                     
                     if(response[@"success"] == 0){
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error has occurred. Please try again." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                         [alertView show];
                     }
                     else{
//                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Success! Your funding campaign has been created!" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                         [alertView show];
                         
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
        else if(self.wishType == 2){
            
            [dictParam setObject:self.selectedWish[@"product_id"] forKey:@"product_id"];
            
            [[ProgressIndicator sharedInstance] showPIOnView:self.view withMessage:@"Saving..."];
            
            AFNHelper *afn=[[AFNHelper alloc]init];
            [afn getDataFromPath:@"createPopularProductFundingCampaign" withParamData:dictParam withBlock:^(id response, NSError *error)
             {
                 if (response)
                 {
                     [[ProgressIndicator sharedInstance] hideProgressIndicator];
                     
                     if(response[@"success"] == 0){
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error has occurred. Please try again." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                         [alertView show];
                     }
                     else{
//                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Success! Your funding campaign has been created!" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                         [alertView show];
                         
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
                 }
                 
             }];
            
        }
        else{
            
            [[ProgressIndicator sharedInstance] showPIOnView:self.view withMessage:@"Saving..."];
            
            UIImage *img=[[UtilityClass sharedObject] scaleAndRotateImage: self.wishImage.imageValue];
            NSData *imageToUpload = UIImageJPEGRepresentation(img, 1.0);
            
            if (imageToUpload) {
                NSString *strImage=[Base64 encode:imageToUpload];
                if (strImage) {
                    [dictParam setObject:strImage forKey:@"imagedata"];
                }
            }

            
            AFNHelper *afn=[[AFNHelper alloc]init];
            [afn getDataFromPath:@"createCustomFundingCampaign" withParamData:dictParam withBlock:^(id response, NSError *error)
             {
                 if (response)
                 {
                     [[ProgressIndicator sharedInstance] hideProgressIndicator];
                     
                     if(response[@"success"] == 0){
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error has occurred. Please try again." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                         [alertView show];
                     }
                     else{
//                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Success! Your funding campaign has been created!" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                         [alertView show];
                         
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
