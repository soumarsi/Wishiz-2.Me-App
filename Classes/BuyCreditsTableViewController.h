//
//  BuyCreditsTableViewController.h
//  WishizMe
//
//  Created by David Krasicki on 12/14/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuyCreditIntroCell.h"
#import "CreditPackageCell.h"
#import "PayPalMobile.h"
#import "WithDrawCreditsViewController.h"

@interface BuyCreditsTableViewController : UITableViewController<BuyCreditPackageDelegate, PayPalPaymentDelegate, WithdrawCreditPackageDelegate>

@property(nonatomic,strong)IBOutlet NSArray* creditPackages;
@property(nonatomic,strong)IBOutlet NSString* userCreditBalance;

@property(nonatomic,strong) NSString *selectedCreditPackageId;

-(void) withdrawCredits;

@end
