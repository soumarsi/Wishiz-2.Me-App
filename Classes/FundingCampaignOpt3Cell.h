//
//  FundingCampaignOpt3Cell.h
//  WishizMe
//
//  Created by David Krasicki on 1/11/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ShowCustomProduct

-(void) showCustomProduct;

@end

@interface FundingCampaignOpt3Cell : UITableViewCell

@property(nonatomic,weak) id <ShowCustomProduct> delegate;
@property(nonatomic,strong)IBOutlet UIButton *createCustomCampaign;

@end
