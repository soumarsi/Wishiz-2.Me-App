//
//  FundingCampaignReviewTableViewController.h
//  WishizMe
//
//  Created by David Krasicki on 1/11/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditFundingCampaignViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface FundingCampaignReviewTableViewController : UITableViewController{

    UIImage *demoImg;

}




@property(nonatomic,strong) NSString *fundingCampaignId;
@property(nonatomic,strong) NSString *fundingCampaignTitle;
@property(nonatomic,strong) NSString *fundingCampaignPrice;
@property(nonatomic,strong) NSString *fundingCampaignDescription;
@property (nonatomic, strong) IBOutlet FBSDKLikeControl *pageLikeControl;
@property (nonatomic, strong) IBOutlet FBSDKLoginButton *loginButton;

@end
