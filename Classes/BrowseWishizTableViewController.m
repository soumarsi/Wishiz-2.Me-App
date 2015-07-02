//
//  BrowseWishizTableViewController.m
//  WishizMe
//
//  Created by David Krasicki on 1/5/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import "BrowseWishizTableViewController.h"

@interface BrowseWishizTableViewController ()

@end

@implementation BrowseWishizTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"Select Wish"];
    self.navigationController.navigationBarHidden = NO;
    [self addBack:self.navigationItem];
}

-(void)addBack:(UINavigationItem*)naviItem
{
    UIImage *imgButton = [UIImage imageNamed:@"chat_icon_off_line.png"];
    UIButton *rightbarbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbarbutton setFrame:CGRectMake(0, 0, imgButton.size.width+20, imgButton.size.height)];
    [rightbarbutton setTitle:@"Back" forState:UIControlStateNormal];
    [rightbarbutton addTarget:self action:@selector(buttonBackPressed:) forControlEvents:UIControlEventTouchUpInside];
    naviItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbarbutton];
}

- (void)buttonBackPressed:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
    
-(void) viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.wishiz.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 138;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.row)
    {
        default:
        {
            
            CreateFundingCampaignViewController *createCampaign = [[CreateFundingCampaignViewController alloc] init:self.wishType ];
            
            NSMutableDictionary *selectedWish = [self.wishiz objectAtIndex: indexPath.row];
            
            createCampaign.selectedWish = selectedWish;
            createCampaign.wishTitle.textValue = selectedWish[@"Title"];
            
            if(self.wishType == 2){
                createCampaign.wishDescription.textValue = selectedWish[@"description"];
            }

            
            createCampaign.wishCost.textValue = [selectedWish[@"price"] stringByReplacingOccurrencesOfString:@"$" withString:@""];
            [createCampaign.wishTopImageView sd_setImageWithURL:[NSURL URLWithString:selectedWish[@"lg_image"]] placeholderImage:nil];
            
            createCampaign.wishType = self.wishType;
            
            [self.navigationController pushViewController:createCampaign animated:NO];
        }
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    WishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WishTableViewCell"];
    
    if(cell == nil){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WishTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    NSMutableDictionary *wish = [self.wishiz objectAtIndex: indexPath.row];
    

    @try{
        if(self.wishType == 2){
            cell.wishTitle.text = [NSString stringWithFormat:@"%@%@%@",wish[@"Title"],@" - ", wish[@"description"]];
        }
        else{
            cell.wishTitle.text = wish[@"Title"];
        }
        
    }
    @catch (NSException *ex){
        cell.wishTitle.text = @"";
    }
    
    
    @try{
        cell.wishPrice.text = wish[@"price"];
    }
    @catch (NSException *ex){
        cell.wishPrice.text = @"0";
    }
    
    
    @try{
        [cell.wishImage sd_setImageWithURL:[NSURL URLWithString:wish[@"img"]]
                          placeholderImage:nil];
        //cell.wishImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    @catch (NSException *ex){
        
    }
    
   
    return cell;

}


@end
