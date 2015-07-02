//
//  WishTableViewCell.h
//  WishizMe
//
//  Created by David Krasicki on 1/5/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WishTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UIButton *selectButton;
@property(nonatomic,strong)IBOutlet UIImageView *wishImage;
@property(nonatomic,strong)IBOutlet UITextView *wishTitle;
@property(nonatomic,strong)IBOutlet UILabel *wishPrice;

@end
