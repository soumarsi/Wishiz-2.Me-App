//
//  FundingCampaignCell.m
//  WishizMe
//
//  Created by David Krasicki on 12/5/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//

#import "FundingCampaignCell.h"

@implementation FundingCampaignCell

@synthesize fundingCampaignImage = _fundingCampaignImage;
@synthesize fundingCampaignTitle = _fundingCampaignTitle;


- (void)awakeFromNib {
    self.fundButton.layer.cornerRadius = 4;
    self.fundButton.layer.borderWidth = 1;
    self.fundButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    if (self.edit == 1) {
        [self.fundButton setTitle:@"View Wish" forState: UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
