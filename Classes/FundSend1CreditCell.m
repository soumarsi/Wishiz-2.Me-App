//
//  FundSend1CreditCell.m
//  WishizMe
//
//  Created by David Krasicki on 1/11/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import "FundSend1CreditCell.h"

@implementation FundSend1CreditCell

- (void)awakeFromNib {
    
    self.send1Credit.layer.borderColor = [UIColor whiteColor].CGColor;
    self.send1Credit.layer.borderWidth = .5;
    self.send1Credit.layer.cornerRadius = 5;
    
    self.creditAmountLabels1.layer.borderColor = [UIColor grayColor].CGColor;
    self.creditAmountLabels1.layer.borderWidth = 1;
    self.creditAmountLabels1.layer.cornerRadius = 22;
    self.creditAmountLabels1.layer.backgroundColor = [UIColor brownColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


@end
