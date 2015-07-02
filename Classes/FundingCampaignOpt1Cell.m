//
//  FundingCampaignOpt1Cell.m
//  WishizMe
//
//  Created by David Krasicki on 1/11/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import "FundingCampaignOpt1Cell.h"

@implementation FundingCampaignOpt1Cell
{
    IBOutlet UIImageView *option1Images;
}

- (void)awakeFromNib {
    
    
    self.searchProducts.layer.borderColor = [UIColor whiteColor].CGColor;
    self.searchProducts.layer.borderWidth = .5;
    self.searchProducts.layer.cornerRadius = 5;
    
    option1Images.layer.borderColor = [UIColor grayColor].CGColor;
    option1Images.layer.borderWidth = .5;
    option1Images.layer.cornerRadius = 5;
    
    self.productSearchTerm.autocorrectionType = UITextAutocorrectionTypeYes;
    self.productSearchTerm.keyboardType = UIKeyboardTypeDefault;
    self.productSearchTerm.clearButtonMode = UITextFieldViewModeWhileEditing;
    
}


-(IBAction)btnAction:(id)sender
{
    if([self.productSearchTerm.text isEqualToString:@""])
    {
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Enter Product"
                                  message:@"Please enter a product to search for."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];}
    else
    {
        [self.delegate showProductSearch: self.productSearchTerm.text];
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
