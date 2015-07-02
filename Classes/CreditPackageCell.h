//
//  CreditPackageCell.h
//  WishizMe
//
//  Created by David Krasicki on 12/14/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BuyCreditPackageDelegate

-(void) buyPackage: (NSString*)packageTitle creditamount:(NSString*)credits packageCost:(NSString*)packageprice packageId:(NSString*)packageid;

@end

@interface CreditPackageCell : UITableViewCell

@property(nonatomic,weak) id <BuyCreditPackageDelegate> delegate;

@property(nonatomic,strong)IBOutlet UILabel *creditAmount;
@property(nonatomic,strong)IBOutlet UILabel *creditPackageTitle;
@property(nonatomic,strong)IBOutlet UITextView *creditPackageDescription;
@property(nonatomic,strong)IBOutlet UILabel *creditPackagePrice;

@property(nonatomic,strong) NSString *creditPackageId;
@property(nonatomic,strong) NSString *creditPackageDollarAmount;
@property(nonatomic,strong)IBOutlet UIButton *fundButton;

@end
