//
//  SendCreditsIntrolViewCell.m
//  WishizMe
//
//  Created by David Krasicki on 1/17/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import "SendCreditsIntrolViewCell.h"

@implementation SendCreditsIntrolViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.wishImage.clipsToBounds = YES;
    self.userImage.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(IBAction)btnAction:(id)sender
{
    
    [self.delegate sendCredits:self.personalMessage.text creditAmount:self.creditAmount];
}

@end
