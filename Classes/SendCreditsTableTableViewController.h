//
//  SendCreditsTableTableViewController.h
//  WishizMe
//
//  Created by David Krasicki on 1/17/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendCreditsIntrolViewCell.h"

@interface SendCreditsTableTableViewController : UITableViewController

@property(nonatomic,strong) NSString *sendCreditAmount;
@property(nonatomic,strong) NSString *fundingCampaignId;
@property(nonatomic,strong) NSString *fundingCampaignTitle;
@property(nonatomic,strong) NSString *fundingCampaignDescription;
@property(nonatomic,strong) User *user;

@property(nonatomic,weak) id <SubmitSendCreditsDelegate> delegate;

@end
