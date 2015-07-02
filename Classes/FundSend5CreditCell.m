//
//  FundSend5CreditCell.m
//  WishizMe
//
//  Created by David Krasicki on 1/11/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import "FundSend5CreditCell.h"

@implementation FundSend5CreditCell

- (void)awakeFromNib {

    self.send5Credit.layer.borderColor = [UIColor whiteColor].CGColor;
    self.send5Credit.layer.borderWidth = .5;
    self.send5Credit.layer.cornerRadius = 5;
    
    self.creditAmountLabels5.layer.borderColor = [UIColor grayColor].CGColor;
    self.creditAmountLabels5.layer.borderWidth = 1;
    self.creditAmountLabels5.layer.cornerRadius = 22;
    self.creditAmountLabels5.layer.backgroundColor = [UIColor grayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
