//
//  FundingCampaignOpt2Cell.m
//  WishizMe
//
//  Created by David Krasicki on 1/11/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import "FundingCampaignOpt2Cell.h"

@implementation FundingCampaignOpt2Cell
{
    IBOutlet UIImageView *option2Images;
}

- (void)awakeFromNib {
    
    self.browsePopularProducts.layer.borderColor = [UIColor whiteColor].CGColor;
    self.browsePopularProducts.layer.borderWidth = .5;
    self.browsePopularProducts.layer.cornerRadius = 5;
        
    option2Images.layer.borderColor = [UIColor grayColor].CGColor;
    option2Images.layer.borderWidth = .5;
    option2Images.layer.cornerRadius = 5;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)btnAction:(id)sender
{
    
    [self.delegate showPopularProducts];
    
}

@end
