//
//  SendCreditsIntrolViewCell.h
//  WishizMe
//
//  Created by David Krasicki on 1/17/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SubmitSendCreditsDelegate

-(void) sendCredits: (NSString*)message creditAmount:(NSString*)credits;

@end


@interface SendCreditsIntrolViewCell : UITableViewCell

@property(nonatomic,weak) id <SubmitSendCreditsDelegate> delegate;

@property(nonatomic,strong)IBOutlet UIImageView *wishImage;
@property(nonatomic,strong)IBOutlet UIImageView *userImage;

@property(nonatomic,strong)IBOutlet UITextField *personalMessage;
@property(nonatomic,strong)IBOutlet UIButton *submitButton;
@property(nonatomic,strong)IBOutlet UILabel *sendCreditLabel;

@property(nonatomic,strong) NSString *creditAmount;
@property(nonatomic,strong) NSString *receiving_profile_id;

@end
