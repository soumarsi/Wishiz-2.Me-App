//
//  FundingCampaignCell.h
//  WishizMe
//
//  Created by David Krasicki on 12/5/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FundWishTableViewController.h"
#import "UIImageView+WebCache.h"

@interface FundingCampaignCell : UITableViewCell


@property(nonatomic,strong)IBOutlet UITextView *fundingCampaignTitle;
@property(nonatomic,strong)IBOutlet UITextView *fundingCampaignPrice;
@property(nonatomic,strong)IBOutlet UITextView *fundingCampaignDescription;
@property(nonatomic,strong)IBOutlet UIImageView *fundingCampaignImage;
@property(nonatomic,strong)IBOutlet UIButton *fundButton;

@property(strong ,nonatomic) NSString *fundingCampaignId;

@property int edit;  //1-Yes, 0-No

- (void) setImage;



@end
