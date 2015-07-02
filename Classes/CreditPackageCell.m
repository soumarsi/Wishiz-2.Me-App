//
//  CreditPackageCell.m
//  WishizMe
//
//  Created by David Krasicki on 12/14/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//

#import "CreditPackageCell.h"

@implementation CreditPackageCell

- (void)awakeFromNib {
    // Initialization code
    self.fundButton.layer.cornerRadius = 4;
    self.fundButton.layer.borderWidth = 1;
    self.fundButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)btnAction:(id)sender
{
    
    [self.delegate buyPackage:self.creditPackageTitle.text creditamount:self.creditAmount.text packageCost:self.creditPackageDollarAmount packageId:self.creditPackageId];
}

@end
