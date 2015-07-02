//
//  FundingCampaignOpt3Cell.m
//  WishizMe
//
//  Created by David Krasicki on 1/11/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import "FundingCampaignOpt3Cell.h"

@implementation FundingCampaignOpt3Cell
{
    IBOutlet UIImageView *option3Images;
}

- (void)awakeFromNib {

    self.createCustomCampaign.layer.borderColor = [UIColor whiteColor].CGColor;
    self.createCustomCampaign.layer.borderWidth = .5;
    self.createCustomCampaign.layer.cornerRadius = 5;
    
    option3Images.layer.borderColor = [UIColor grayColor].CGColor;
    option3Images.layer.borderWidth = .5;
    option3Images.layer.cornerRadius = 5;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(IBAction)btnAction:(id)sender
{
    
    [self.delegate showCustomProduct];
}

@end
