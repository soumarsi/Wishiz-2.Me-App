//
//  FundWishUserCellFacebook.m
//  WishizMe
//
//  Created by anirban on 15/06/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import "FundWishUserCellFacebook.h"

@implementation FundWishUserCellFacebook

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)shareonfacebook:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postFacebook" object:self];
    
}
- (IBAction)cancelshare:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelshare" object:self];
}

@end
