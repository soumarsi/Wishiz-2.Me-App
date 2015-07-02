//
//  FundingCampaignsTableViewController.h
//  WishizMe
//
//  Created by David Krasicki on 1/4/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FundingCampaignCell.h"
#import "FundingCampaignOpt1Cell.h"
#import "FundingCampaignOpt2Cell.h"
#import "FundingCampaignOpt3Cell.h"
#import "FundingCampaignsCountCell.h"
#import "BrowseWishizTableViewController.h"
#import "ProfileVC.h"

@interface FundingCampaignsTableViewController : UITableViewController<SearchProductDelegate, SearchPopularProducts, ShowCustomProduct>


@property(nonatomic,strong)IBOutlet NSArray* fundingCampaigns;


@end
