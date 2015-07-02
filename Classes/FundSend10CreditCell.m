//
//  FundSend10CreditCell.m
//  WishizMe
//
//  Created by David Krasicki on 1/11/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import "FundSend10CreditCell.h"

@implementation FundSend10CreditCell

- (void)awakeFromNib {
   
    self.send10Credit.layer.borderColor = [UIColor whiteColor].CGColor;
    self.send10Credit.layer.borderWidth = .5;
    self.send10Credit.layer.cornerRadius = 5;
    
    self.creditAmountLabels10.layer.borderColor = [UIColor grayColor].CGColor;
    self.creditAmountLabels10.layer.borderWidth = 1;
    self.creditAmountLabels10.layer.cornerRadius = 22;
    self.creditAmountLabels10.layer.backgroundColor = [UIColor yellowColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
