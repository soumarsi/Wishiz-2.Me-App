//
//  SendCreditsTableTableViewController.m
//  WishizMe
//
//  Created by David Krasicki on 1/17/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import "SendCreditsTableTableViewController.h"

@interface SendCreditsTableTableViewController ()

@end

@implementation SendCreditsTableTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation_bar_logo"]];    
    [self addLeftButton:self.navigationItem];
}

-(void)addLeftButton:(UINavigationItem*)naviItem
{
    UIButton *leftbarbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbarbutton setFrame:CGRectMake(0, 0, 60, 42)];
    [leftbarbutton setTitle:@"Back" forState:UIControlStateNormal];
    [leftbarbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftbarbutton.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:15];
    
    [leftbarbutton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    naviItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftbarbutton];
}

-(void)done:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0)
    {
        return 540;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch(indexPath.row)
    {
        default:
        {
            SendCreditsIntrolViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SendCreditsIntrolViewCell"];
            
            if(cell == nil){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SendCreditsIntrolViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                
               
                NSString *imageURL = [NSString stringWithFormat:@"%@%@%@%@",USER_FILES_URL,@"fundingCampaign_icon_", self.fundingCampaignId, @".jpg"];
                
                [cell.wishImage sd_setImageWithURL:[NSURL URLWithString:imageURL]
                                  placeholderImage:nil];
                
                [cell.userImage sd_setImageWithURL:[NSURL URLWithString:self.user.profile_pic]
                                  placeholderImage:nil];
                
                cell.delegate = self.delegate;
                
                if([self.sendCreditAmount isEqualToString:@"1"]){
                    cell.sendCreditLabel.text = [NSString stringWithFormat:@"%@ Credit",self.sendCreditAmount];
                }else{
                    cell.sendCreditLabel.text = [NSString stringWithFormat:@"%@ Credits",self.sendCreditAmount];
                }
                cell.creditAmount = self.sendCreditAmount;
                cell.receiving_profile_id = self.user.profile_id;
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        
    }
    
}

@end
