//
//  FundWishIntroCell.m
//  WishizMe
//
//  Created by David Krasicki on 12/15/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//

#import "FundWishIntroCell.h"

@implementation FundWishIntroCell

- (void)awakeFromNib {
    // Initialization code
    self.wishImage.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
