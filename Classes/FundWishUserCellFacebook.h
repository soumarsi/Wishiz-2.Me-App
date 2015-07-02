//
//  FundWishUserCellFacebook.h
//  WishizMe
//
//  Created by anirban on 15/06/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface FundWishUserCellFacebook : UITableViewCell

@property(nonatomic,strong)IBOutlet UILabel *userSaysTitle;
@property(nonatomic,strong)IBOutlet UITextView *userSaysDescription;
@property(nonatomic,strong)IBOutlet UIImageView *userImage;
@end
