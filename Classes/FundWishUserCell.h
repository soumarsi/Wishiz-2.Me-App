//
//  FundWishUserCell.h
//  WishizMe
//
//  Created by David Krasicki on 12/15/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//

@protocol Fundswishcell <UITextFieldDelegate>

@optional


@end

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@interface FundWishUserCell : UITableViewCell<UITextFieldDelegate>



@property(nonatomic,strong)IBOutlet UILabel *userSaysTitle;
@property(nonatomic,strong)IBOutlet UITextView *userSaysDescription;
@property(nonatomic,strong)IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UITextField *message;

@property (strong , nonatomic) id <Fundswishcell>funddelegate;
@property (strong, nonatomic) IBOutlet UILabel *desc;

@end
