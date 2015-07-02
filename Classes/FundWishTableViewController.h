//
//  FundWishTableViewController.h
//  WishizMe
//
//  Created by David Krasicki on 12/15/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FundWishIntroCell.h"
#import "FundWishUserCell.h"
#import "FundWishGuaranteedResponseCell.h"
#import "FundSend1CreditCell.h"
#import "FundSend5CreditCell.h"
#import "FundSend10CreditCell.h"
#import "FundCampaignCell.h"
#import "BuyCreditsTableViewController.h"
#import "UIImageView+WebCache.h"
#import "User.h"
#import "SendCreditsTableTableViewController.h"
#import "Report.h"
@interface FundWishTableViewController : UITableViewController <SubmitSendCreditsDelegate>
{
    Report *viewRep ;
    UIAlertView *alertStatus, *blankCheck;
}

@property(nonatomic,strong) NSString *fundingCampaignId;
@property(nonatomic,strong) NSString *fundingCampaignTitle;
@property(nonatomic,strong) NSString *fundingCampaignDescription;
@property(nonatomic,strong) NSString *userProfileId;
@property(nonatomic,strong) User *user;
@property(nonatomic,strong) NSString *comingFrom;
@property float creditfloat;

-(void)addRightButton:(UINavigationItem*)naviItem;
-(void) getUserCreditBalance;

@property(nonatomic,strong) UIImageView *fundingCampaignImage;

@end
