//
//  ProfileViewTableCell.h
//  WishizMe
//
//  Created by David Krasicki on 12/5/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+Download.h"

@interface ProfileViewTableCell : UITableViewCell <UIScrollViewDelegate>{
    NSMutableDictionary *arrImages;
    int currentPage;
}

@property(nonatomic,strong)IBOutlet UIScrollView *scrImage;
@property(nonatomic,strong)IBOutlet UIPageControl *pcImage;
@property(nonatomic,strong)IBOutlet UILabel *lblNameAndAge;
@property(nonatomic,strong)IBOutlet UILabel *lblCityAndState;
@property(nonatomic,strong)IBOutlet UITextView *txtAbout;
@property(nonatomic,strong)IBOutlet UILabel *fundWishizTitle;

-(void)getUserProfile:(NSString *)profile_id;
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size;
- (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height;



@end
