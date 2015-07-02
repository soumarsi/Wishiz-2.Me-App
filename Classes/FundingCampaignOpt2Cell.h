//
//  FundingCampaignOpt2Cell.h
//  WishizMe
//
//  Created by David Krasicki on 1/11/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchPopularProducts

-(void) showPopularProducts;

@end

@interface FundingCampaignOpt2Cell : UITableViewCell

@property(nonatomic,weak) id <SearchPopularProducts> delegate;
@property(nonatomic,strong)IBOutlet UIButton *browsePopularProducts;

@end
