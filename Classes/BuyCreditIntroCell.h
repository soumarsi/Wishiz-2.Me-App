//
//  BuyCreditIntroCell.h
//  WishizMe
//
//  Created by David Krasicki on 12/14/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WithdrawCreditPackageDelegate

-(void) withdrawCredits;

@end

@interface BuyCreditIntroCell : UITableViewCell

@property(nonatomic,weak) id <WithdrawCreditPackageDelegate> delegate;

@property(nonatomic,strong)IBOutlet UILabel *userCreditBalance;
@property(nonatomic,strong)IBOutlet UIButton *withdrawCreditsButton;


@end
