//
//  FundCampaignCell.m
//  WishizMe
//
//  Created by David Krasicki on 12/15/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//

#import "FundCampaignCell.h"

@implementation FundCampaignCell

- (void)awakeFromNib {
    // Initialization code
    
    self.buyCreditsButton.layer.borderColor = [UIColor blueColor].CGColor;
    self.buyCreditsButton.layer.borderWidth = .5;
    self.buyCreditsButton.layer.cornerRadius = 5;
    
    [self getUserCreditBalance];
}

-(void) getUserCreditBalance
{
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    User *curUser = [User currentUser];
    [dictParam setObject:curUser.fbid forKey:PARAM_ENT_FBID];
    
    AFNHelper *afn=[[AFNHelper alloc]init];
    [afn getDataFromPath:METHOD_GET_USER_CREDIT_BALANCE withParamData:dictParam withBlock:^(id response, NSError *error)
     {
         if (response)
         {
             NSNumber *credits = response[@"credits"];
             float creditFloat = [credits floatValue];
             //NSString *priceString = [NSString stringWithFormat:@"%f", price];
             self.userCreditBalance.text = [NSString stringWithFormat:@"%@%@", @"Your Credit Balance: ", [NSString stringWithFormat:@"%.0f", creditFloat]];
             
             self.usercreditfloat = creditFloat;

         }
     }];
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
