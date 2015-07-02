//
//  MenuViewController.m
//  Tinder
//
//  Created by Rahul Sharma on 29/11/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#import "MenuViewController.h"
#import "RoundedImageView.h"
#import "UploadImages.h"
#import "Helper.h"
#import "DataBase.h"
#import "ChatViewController.h"
#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "UIImageView+Download.h"
#import "QuestionVC.h"
#import "ProfileVC.h"

@interface MenuViewController ()
{
    UIActionSheet *actionSheet;
    RoundedImageView *profileImageView;
}
@end

@implementation MenuViewController

#pragma mark -
#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -
#pragma mark - ViewLife Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DebugLog(@"MENU VIEW CONTROLLER-------> %@",[[[UserDefaultHelper sharedObject] facebookUserDetail] objectForKey:FACEBOOK_NAME]);
    [[NSUserDefaults standardUserDefaults] setObject:[[[UserDefaultHelper sharedObject] facebookUserDetail] objectForKey:FACEBOOK_NAME] forKey:@"currentUser"];
    
    profileImageView = [[RoundedImageView alloc] initWithFrame:CGRectMake(0, 2, 50, 50)];
    NSString *FBId=[[[UserDefaultHelper sharedObject] facebookUserDetail] objectForKey:FACEBOOK_ID];
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"(fbId== %@)",
                              FBId];
    NSMutableArray *profileImage=[[DBHelper sharedObject]getObjectsforEntity:ENTITY_UPLOADIMAGES ShortBy:@"imageUrlLocal" isAscending:YES predicate:predicate];
    if (profileImage.count > 0) {
        profileImageView.image =[UIImage imageWithContentsOfFile:[(UploadImages*)[profileImage objectAtIndex:0] imageUrlLocal]];
    }
    else {
        profileImageView.image = [UIImage imageNamed:@"pfImage.png"];
    }
    
    if ([User currentUser].profile_pic!=nil) {
        [profileImageView downloadFromURL:[User currentUser].profile_pic withPlaceholder:[UIImage imageNamed:@"pfImage.png"]];
    }
    
    //Adding rounded image view to main view.
    [btnProfile addSubview:profileImageView];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    self.view.backgroundColor = [Helper getColorFromHexString:@"#002d34" :1.0];
    self.navigationController.navigationBarHidden = YES;
    
}

-(NSArray*)getProfileImages :(NSString*)FBId
{
    NSManagedObjectContext *context = [APPDELEGATE managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UploadImages" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSArray *result=nil;
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"(fbId== %@)",
                              FBId];
    [fetchRequest setPredicate:predicate];
    
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"imageUrlLocal" ascending:YES]];
    
    NSError *error = nil;
    result = [context executeFetchRequest:fetchRequest error:&error];
    return  result;
}

#pragma  mark -
#pragma  mark - Button Action Method

-(IBAction)btnAction:(id)sender
{
    UIButton * btn =(UIButton*)sender;
    switch (btn.tag)
    {
        case PROFILE:{
            
            ProfileVC *vc=[[ProfileVC alloc]initWithNibName:@"ProfileVC" bundle:nil];
            [[User currentUser] setUser];
            User*  profileUser = [User currentUser];
            vc.user = profileUser;
            
            UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.revealSideViewController popViewControllerWithNewCenterController:n
                                                                           animated:YES];
            [self.revealSideViewController setDelegate:vc];
            PP_RELEASE(vc);
            PP_RELEASE(n);
            break;
        }
        case HOME:{
            [[Helper sharedInstance] setIntLike:0];
            HomeViewController *c;
            if (IS_IPHONE_5) {
                c= [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
            }
            else{
                c = [[HomeViewController alloc] initWithNibName:@"HomeViewController_ip4" bundle:nil];
            }
            c.didUserLoggedIn = YES;
            c._loadViewOnce = NO;
            UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:c];
            [self.revealSideViewController popViewControllerWithNewCenterController:n
                                                                           animated:YES];
            PP_RELEASE(c);
            PP_RELEASE(n);
            break;
        }
        case MESSAGE:{
            [[Helper sharedInstance] setIntLike:1];
            ChatViewController *menu=[[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
            [self.revealSideViewController pushViewController:menu onDirection:PPRevealSideDirectionRight withOffset:62 animated:YES];
            PP_RELEASE(menu);
            break;
        }
        case SETTINGS:{
            SettingsViewController *c;
            if (IS_IPHONE_5) {
                c = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
            }
            else{
                c = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController_ip4" bundle:nil];
            }
            UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:c];
            [self.revealSideViewController popViewControllerWithNewCenterController:n
                                                                           animated:YES];
            [self.revealSideViewController setDelegate:c];
            
            PP_RELEASE(c);
            PP_RELEASE(n);
            break;
        }
        case INVITE:{
            [self showActionSheet];
            break;
        }
        case 15:{
            QuestionVC *vcQue=[[QuestionVC alloc]initWithNibName:@"QuestionVC" bundle:nil];
            [self presentViewController:vcQue animated:YES completion:^{
            }];
        }
        case 16:{
           
            FundingCampaignsTableViewController *c = [[FundingCampaignsTableViewController alloc] initWithNibName:@"FundingCampaignsTableViewController" bundle:nil];

            UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:c];
            [self.revealSideViewController popViewControllerWithNewCenterController:n
                                                                           animated:YES];
            PP_RELEASE(c);
            PP_RELEASE(n);
            break;
        }
            break;
        default:
            break;
    }
}

-(void)showActionSheet
{
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"Invite" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Mail ",@"Message",nil];
    actionSheet.tag = 200;
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

-(void) actionSheet:(UIActionSheet *)actSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actSheet.tag == 200) {
        if(buttonIndex == 0){
            [super sendMailSubject:@"Wishiz.me App!" toRecipents:[NSArray arrayWithObject:@""] withMessage:@"Hey, I'm using this cool new app called Wishiz.me! You can browse the wishiz of other members or even get your own wishiz funded! Download the app in iTunes: Wishiz.me App"];
        }
        else if(buttonIndex == 1){
            [super sendMessage:@"Hey, I'm using this cool new app called Wishiz.me! You can browse the wishiz of other members or even get your own wishiz funded! Download the app in iTunes: Wishiz.me App"];
        }
    }
}

#pragma mark -
#pragma mark - Memory Mgmt

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end;
