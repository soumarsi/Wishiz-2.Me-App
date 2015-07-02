//
//  BuyCreditIntroCell.m
//  WishizMe
//
//  Created by David Krasicki on 12/14/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//

#import "BuyCreditIntroCell.h"

@implementation BuyCreditIntroCell

- (void)awakeFromNib {
    
    self.withdrawCreditsButton.layer.borderColor = [UIColor blueColor].CGColor;
    self.withdrawCreditsButton.layer.borderWidth = .5;
    self.withdrawCreditsButton.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)btnAction:(id)sender
{
    [self.delegate withdrawCredits];
}


@end
