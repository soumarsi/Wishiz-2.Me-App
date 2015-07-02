//
//  FundWishUserCell.m
//  WishizMe
//
//  Created by David Krasicki on 12/15/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//

#import "FundWishUserCell.h"

@implementation FundWishUserCell

- (void)awakeFromNib {
    
    self.message.delegate = _funddelegate;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//- (IBAction)shareonfacebook:(id)sender {
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"postFacebook" object:self];
//    
//}
//- (IBAction)cancelshare:(id)sender {
//    
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelshare" object:self];
//}

@end
