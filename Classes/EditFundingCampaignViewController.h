//
//  EditFundingCampaignViewController.h
//  WishizMe
//
//  Created by David Krasicki on 1/11/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditFundingCampaignViewController : QuickDialogController <QuickDialogEntryElementDelegate, UIAlertViewDelegate>


@property(strong, nonatomic) QButtonElement *createFundingCampaign;
@property(strong, nonatomic) QEntryElement *wishTitle;
@property(strong, nonatomic) QEntryElement *wishDescription;
@property(strong, nonatomic) QEntryElement *wishCost;
@property(strong, nonatomic) QImageElement *wishImage;

@property(strong, nonatomic) NSMutableDictionary *selectedWish;
@property(strong, nonatomic) UIImage *wishTopImage;
@property(strong, nonatomic) UIImageView *wishTopImageView;
@property(strong, nonatomic) NSString *wishId;


@end
