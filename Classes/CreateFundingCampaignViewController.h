//
//  CreateFundingCampaignViewController.h
//  WishizMe
//
//  Created by David Krasicki on 1/10/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickDialogController.h"
#import "FundingCampaignReviewTableViewController.h"
#import "Base64.h"   

@interface CreateFundingCampaignViewController : QuickDialogController <QuickDialogEntryElementDelegate>


@property(strong, nonatomic) QButtonElement *createFundingCampaign;
@property(strong, nonatomic) QEntryElement *wishTitle;
@property(strong, nonatomic) QEntryElement *wishDescription;
@property(strong, nonatomic) QEntryElement *wishCost;
@property(strong, nonatomic) QImageElement *wishImage;

@property(strong, nonatomic) NSMutableDictionary *selectedWish;
@property(strong, nonatomic) UIImage *wishTopImage;
@property(strong, nonatomic) UIImageView *wishTopImageView;

@property int wishType;  //1-Amazon, 2-Popular, 3-Custom

-(id) init: (NSInteger) wishType;
@end
