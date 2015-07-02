//
//  FundingCampaignOpt1Cell.h
//  WishizMe
//
//  Created by David Krasicki on 1/11/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SearchProductDelegate

-(void) showProductSearch: (NSString*) searchTerm;

@end

@interface FundingCampaignOpt1Cell : UITableViewCell

@property(nonatomic,weak) id <SearchProductDelegate> delegate;
@property(nonatomic,strong)IBOutlet UIButton *searchProducts;
@property(nonatomic,strong)IBOutlet UITextField *productSearchTerm;

@end
