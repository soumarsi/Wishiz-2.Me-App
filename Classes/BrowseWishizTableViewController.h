//
//  BrowseWishizTableViewController.h
//  WishizMe
//
//  Created by David Krasicki on 1/5/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WishTableViewCell.h"
#import "CreateFundingCampaignViewController.h"

@interface BrowseWishizTableViewController : UITableViewController

@property(nonatomic,strong)IBOutlet NSArray* wishiz;
@property int wishType;  //1-Amazon, 2-Popular, 3-Custom


@end
