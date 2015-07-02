//
//  FundCampaignCell.h
//  WishizMe
//
//  Created by David Krasicki on 12/15/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FundCampaignCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UITextView *howManyCreditsIntro;
@property(nonatomic,strong)IBOutlet UILabel *userCreditBalance;
@property(nonatomic,strong)IBOutlet UIButton *buyCreditsButton;

@property float usercreditfloat;

@end
