//
//  WithDrawCreditsViewController.h
//  WishizMe
//
//  Created by David Krasicki on 1/17/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickDialogController.h"


@interface WithDrawCreditsViewController: QuickDialogController <QuickDialogEntryElementDelegate>

@property(strong, nonatomic) QButtonElement *createFundingCampaign;
@property(strong, nonatomic) QEntryElement *creditsToWithdraw;
@property(strong, nonatomic) QEntryElement *paypalEmailAddress;
@property(strong, nonatomic) QEntryElement *wishCost;
@property(strong, nonatomic) QLabelElement *creditbal;

@property float creditfloat;
@property(strong, nonatomic) NSString *creditstr;
-(void) getUserCreditBalance;

@end
