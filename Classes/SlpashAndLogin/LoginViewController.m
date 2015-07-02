//
//  LoginViewController.m
//  Tinder
//
//  Created by Rahul Sharma on 24/11/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#import "LoginViewController.h"
#import "TinderAppDelegate.h"
#import "Helper.h"
#import "ProgressIndicator.h"
#import "Service.h"
#import "LocationHelper.h"
#import "LoginInfoVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginViewController ()

@property (nonatomic ,strong) NSMutableDictionary *paramDict;
@end

@implementation LoginViewController

@synthesize paramDict;


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
    self.navigationController.navigationBarHidden = YES;
    
    [self getLocation];
    
    arrImages=[[NSMutableArray alloc]init];
    
    self.scrImages.delegate = self;
    [self.scrImages setPagingEnabled:YES];
    [self.scrImages setScrollEnabled:YES];
    
    /* Configure Help screens */
    [self setHelpScreens];
    
    /*Make custom Info and Facebook Buttons*/
    [Helper setButton:self.btnInfo Text:@"We'll never post anything to facebook without your permission." WithFont:SEGOUE_UI FSize:10 TitleColor:[UIColor darkGrayColor] ShadowColor:nil];

    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    
//----------facebook login----------
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    PPRevealSideInteractions interContent = PPRevealSideInteractionNone;
    self.revealSideViewController.panInteractionsWhenClosed = interContent;
    self.revealSideViewController.panInteractionsWhenOpened = interContent;
}

#pragma mark -
#pragma mark - Methods

-(void)setHelpScreens
{
    if (IS_iPhone5)
    {
        [arrImages addObject:[UIImage imageNamed:@"homescreen.png"]];
        [arrImages addObject:[UIImage imageNamed:@"browsemembersinyourarea.png"]];
        [arrImages addObject:[UIImage imageNamed:@"likeorpass.png"]];
        [arrImages addObject:[UIImage imageNamed:@"matchwithmembers.png"]];
        [arrImages addObject:[UIImage imageNamed:@"addwishiz.png"]];
    }
    else
    {
        [arrImages addObject:[UIImage imageNamed:@"homescreen.png"]];
        [arrImages addObject:[UIImage imageNamed:@"browsemembersinyourarea.png"]];
        [arrImages addObject:[UIImage imageNamed:@"likeorpass.png"]];
        [arrImages addObject:[UIImage imageNamed:@"matchwithmembers.png"]];
        [arrImages addObject:[UIImage imageNamed:@"addwishiz.png"]];
    }
    self.scrImages.contentSize = CGSizeMake(self.scrImages.frame.size.width * arrImages.count, self.scrImages.frame.size.height);
    self.scrImages.clipsToBounds = YES;
    self.scrImages.contentMode = UIViewContentModeScaleAspectFill;
    //mainImageView.contentMode = UIViewContentModeScaleAspectFill;
     
    [self performSelector:@selector(setScrollViewForImage) withObject:nil afterDelay:0.3];
    
    self.pageControl.pageIndicatorTintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"slider_indicator_off.png"]];
    self.pageControl.currentPageIndicatorTintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"slider_indicator_on.png"]];
}

-(void)setScrollViewForImage
{
    for (int i = 0; i < arrImages.count; i++)
    {
        CGRect frame;
        frame.origin.x = self.scrImages.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrImages.frame.size;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
        imgView.image = [arrImages objectAtIndex:i];
        [self.scrImages addSubview:imgView];
    }
}

#pragma mark -
#pragma mark - Actions

-(IBAction)changePage:(id)sender
{
    int page = self.pageControl.currentPage;
    CGRect frame = self.scrImages.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrImages scrollRectToVisible:frame animated:YES];
}

-(IBAction)onClickbtnInfo:(id)sender
{
    LoginInfoVC *vc=[[LoginInfoVC alloc]initWithNibName:@"LoginInfoVC" bundle:nil];
    vc.parent=self;
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

-(IBAction)onClickbtnFBLogin:(id)sender
{

    if ([FacebookUtility sharedObject].session.state==FBSessionStateOpen || [FacebookUtility sharedObject].session.state==FBSessionStateOpenTokenExtended)
    {
        [super updateLocation];
        [[User currentUser]setUser];
        User *curUser = [User currentUser];
        HomeViewController *home ;
        home._loadViewOnce = NO;
        if (IS_IPHONE_5)
        {
            home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
        }
        else
        {
            home = [[HomeViewController alloc] initWithNibName:@"HomeViewController_ip4" bundle:nil];
        }
        home.didUserLoggedIn = YES;
        home._loadViewOnce = NO;
        NSMutableArray *navigationarray = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [navigationarray removeAllObjects];
        [navigationarray addObject:home];
        [self.navigationController setViewControllers:navigationarray animated:YES];
    }
    else
    {
        if ([FacebookUtility sharedObject].session.state!=FBSessionStateOpen || [FacebookUtility sharedObject].session.state!=FBSessionStateOpenTokenExtended)
        {
            [[FacebookUtility sharedObject]getFBToken];
        }
        
        if ([[FacebookUtility sharedObject]isLogin])
        {
            [self getFacebookUserDetails];
        }
        else
        {
            [[FacebookUtility sharedObject]loginInFacebook:^(BOOL success, NSError *error)
             {
                 if (success)
                 {
                     if ([FacebookUtility sharedObject].session.state==FBSessionStateOpen || [FacebookUtility sharedObject].session.state==FBSessionStateOpenTokenExtended)
                     {
                         [self getFacebookUserDetails];
                     }
                 }
                 else
                 {
                     UIAlertView *alertView = [[UIAlertView alloc]
                                               initWithTitle:@"Error"
                                               message:error.localizedDescription
                                               delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
                     [alertView show];
                 }
             }];
        }
        //self.viewDatePic.hidden=NO;
    }
}

-(IBAction)onClickDone:(id)sender
{
    
 
    self.viewDatePic.hidden=YES;
    
    NSDate *birthDate = self.picDate.date;
    NSDate *currentDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:birthDate toDate:currentDate options:0];
    
    NSInteger days = [dateComponents day];
    NSInteger months = [dateComponents month];
    NSInteger years = [dateComponents year];
    
    NSLog(@"%d Years , %d Months , %d Days", years, months, days);
    
    if(years < 18)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"You should be a minimum of 18 yrs old to Sign Up!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        });
    }
    else
    {
        
        NSLog( @"### running FB sdk version: %@", [FBSettings sdkVersion] );
        strBdate=[[UtilityClass sharedObject]DateToString:birthDate withFormate:@"yyyy-MM-dd"]; //0000-00-00
        
        if ([FacebookUtility sharedObject].session.state!=FBSessionStateOpen || [FacebookUtility sharedObject].session.state!=FBSessionStateOpenTokenExtended)
        {
            [[FacebookUtility sharedObject]getFBToken];
        }
        
        if ([[FacebookUtility sharedObject]isLogin])
        {
            [self getFacebookUserDetails];
        }
        else
        {
            [[FacebookUtility sharedObject]loginInFacebook:^(BOOL success, NSError *error)
             {
                 if (success)
                 {
                     if ([FacebookUtility sharedObject].session.state==FBSessionStateOpen || [FacebookUtility sharedObject].session.state==FBSessionStateOpenTokenExtended)
                     {
                         [self getFacebookUserDetails];
                     }
                 }
                 else
                 {
                     UIAlertView *alertView = [[UIAlertView alloc]
                                               initWithTitle:@"Error"
                                               message:error.localizedDescription
                                               delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
                     [alertView show];
                 }
             }];
        }
    }
}

-(void)getFacebookUserDetails
{
    
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi showPIOnView:self.view withMessage:@"Logging In.."];
    
    if ([[FacebookUtility sharedObject]isLogin])
    {
        [[FacebookUtility sharedObject]fetchMeWithFields:@"id, birthday, email, gender, location, hometown, first_name, age_range, last_name, name, picture.width(800).height(800)" FBCompletionBlock:^(id response, NSError *error)
         {
             if (!error)
             {
                 [[UserDefaultHelper sharedObject] setFacebookUserDetail:[NSMutableDictionary dictionaryWithDictionary:response]];
                 [self parseLogin:response];
             }
             else
             {
                 [pi hideProgressIndicator];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.description message:@"Please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 alert.tag = 202;
                 [alert show];
             }
         }];
    }
    else
    {
        [pi hideProgressIndicator];
    }
}

#pragma mark -
#pragma mark -  login Parse methods

-(void)parseLogin :(NSDictionary*)FBUserDetailDict
{
    EntSex sex;
    if ([[FBUserDetailDict objectForKey:@"gender"] isEqualToString:@"female"])
    {
        sex=EntSexFemale;
    }
    else
    {
        sex=EntSexMale;
    }
    
    NSString *strPushToken =[[UserDefaultHelper sharedObject] deviceToken];
    if (!([strPushToken length] > 0))
    {
        strPushToken = @"SIMULATOR_TEST";
    }
    NSString *lat=@"0.0";
    if ([[UserDefaultHelper sharedObject] currentLatitude]!=nil)
    {
        lat=[[UserDefaultHelper sharedObject] currentLatitude];
    }
    NSString *log=@"0.0";
    if ([[UserDefaultHelper sharedObject] currentLongitude]!=nil)
    {
        log=[[UserDefaultHelper sharedObject] currentLongitude];
    }

    NSString *BDAy =[FBUserDetailDict objectForKey:@"birthday"];
    NSString *emailAddress =[FBUserDetailDict objectForKey:@"email"];

    NSString *location =[FBUserDetailDict objectForKey:@"location"];
     NSString *proPic=@"https://fbcdn-profile-a.akamaihd.net/static-ak/rsrc.php/v2/yL/r/HsTZSDw4avx.gif";
    if ([[[FBUserDetailDict objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]!=nil)
    {
        proPic=[[[FBUserDetailDict objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
    }

    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    
    [dictParam setObject:[FBUserDetailDict objectForKey:@"id"] forKey:PARAM_ENT_FBID];
    [dictParam setObject:[FBUserDetailDict objectForKey:@"first_name"] forKey:PARAM_ENT_FIRST_NAME];
    [dictParam setObject:[FBUserDetailDict objectForKey:@"last_name"] forKey:PARAM_ENT_LAST_NAME];
    [dictParam setObject:[FBUserDetailDict objectForKey:@"email"] forKey:PARAM_ENT_EMAIL];
    [dictParam setObject:[NSString stringWithFormat:@"%d",sex] forKey:PARAM_ENT_SEX];
    [dictParam setObject:strPushToken forKey:PARAM_ENT_PUSH_TOKEN];
    
    [dictParam setObject:lat forKey:PARAM_ENT_CURR_LAT];
    [dictParam setObject:log forKey:PARAM_ENT_CURR_LONG];
    [dictParam setObject:BDAy forKey:PARAM_ENT_DOB];
    [dictParam setObject:proPic forKey:PARAM_ENT_PROFILE_PIC];
    [dictParam setObject:@"1" forKey:PARAM_ENT_DEVICE_TYPE];
    
    [[UserDefaultHelper sharedObject]setFacebookLoginRequest:dictParam];

    AFNHelper *afn=[[AFNHelper alloc]init];
    
    [afn getDataFromPath:METHOD_LOGIN withParamData:dictParam withBlock:^(id response, NSError *error)
    {
        [[ProgressIndicator sharedInstance]hideProgressIndicator];
        if (response)
        {
            //if ([[response objectForKey:@"errFlag"] intValue]!=0)
            //{
                [[User currentUser]setUser];
                HomeViewController *home;
                home._loadViewOnce = NO;
                if (IS_IPHONE_5)
                {
                    home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
                }
                else
                {
                    home = [[HomeViewController alloc] initWithNibName:@"HomeViewController_ip4" bundle:nil];
                }
                home.didUserLoggedIn = YES;
                home._loadViewOnce = NO;
                NSMutableArray *navigationarray = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
                [navigationarray removeAllObjects];
                [navigationarray addObject:home];
                [self.navigationController setViewControllers:navigationarray animated:YES];
        }
    }];
}

-(void)getLocation
{
    [[LocationHelper sharedObject]startLocationUpdatingWithBlock:^(CLLocation *newLocation, CLLocation *oldLocation, NSError *error)
    {
        if (!error)
        {
            [[LocationHelper sharedObject]stopLocationUpdating];
        }
    }];
}

#pragma mark -
#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 202)
    {
        [self getFacebookUserDetails];
    }
}

#pragma mark -
#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = self.scrImages.frame.size.width;
    float fractionalPage = self.scrImages.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
}

#pragma mark -
#pragma mark - Memory mgmt

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end