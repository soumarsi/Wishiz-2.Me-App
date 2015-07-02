
//
//  HomeViewController.m
//  Tinder
//
//  Created by Rahul Sharma on 24/11/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#import "HomeViewController.h"
#import <FacebookSDK/FBSessionTokenCachingStrategy.h>
#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>
#import "RoundedImageView.h"
#import "UploadImages.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
#import "Login.h"
#import "TinderGenericUtility.h"
#import "TinderPreviewUserProfileViewController.h"

#import "ChatViewController.h"
#import "MenuViewController.h"

#import "UIImageView+Download.h"

#import "QuestionVC.h"
#import "ProfileVC.h"

@interface HomeViewController ()
{
    BOOL inAnimation;
    CALayer *waveLayer;
    NSTimer *animateTimer;
    RoundedImageView *profileImageView;
    NSMutableArray * arr ;
    NSArray *  profileImg;
    CGPoint original;
    
    IBOutlet UIView *matchesView;
    IBOutlet UIView *visibleView1;
    IBOutlet UIView *visibleView2;
    
    IBOutlet UIImageView *mainImageView;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *nameLabel2;
    IBOutlet UILabel *commonFriends;
    IBOutlet UILabel *picsCount;
    IBOutlet UILabel *commonInterest;
    
    IBOutlet UILabel *lblMutualFriend;
    IBOutlet UILabel *lblMutualLikes;
    IBOutlet UILabel *lblMutualFriend2;
    IBOutlet UILabel *lblMutualLikes2;
    
    NSTimer *locationUpdateTimer;
    
}
@property (nonatomic, strong, readonly) IBOutlet UIImageView *imgvw;
@property (nonatomic, strong) IBOutlet UILabel *decision;
@property (nonatomic, strong) IBOutlet UIImageView *like_icon;
@property (nonatomic, strong) IBOutlet UIImageView *nope_icon;
@property (nonatomic, strong) IBOutlet UIButton *likedBtn;
@property (nonatomic, strong) IBOutlet UIButton *nopeBtn;
@property (nonatomic, strong) IBOutlet UILabel *lblNoOfImage;

@end

@implementation HomeViewController
@synthesize dictLoginUsrdetail;
@synthesize arrFBImageUrl;
@synthesize strProfileUrl;
@synthesize flag;
@synthesize loginView;
@synthesize imgvw;
@synthesize lblNoOfImage;
@synthesize didUserLoggedIn;
@synthesize _loadViewOnce;
@synthesize myProfileMatches;

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
#pragma mark - View cycle

- (void)viewDidLoad
{
    DebugLog(@"HomeViewController");
    
    [super viewDidLoad];
    
    [self getLocation];
    
    self.loginView.readPermissions = @[@"user_photos"];
    arr = [[NSMutableArray alloc]init];
    self.navigationController.navigationBar.translucent = NO;

    self.navigationController.navigationBarHidden = NO;
    [APPDELEGATE addBackButton:self.navigationItem];
    //[self.navigationItem setTitle:@"Wishiz.me"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation_bar_logo"]];
    
    [APPDELEGATE addrightButton:self.navigationItem];
    
    [self.revealSideViewController setDirectionsToShowBounce: PPRevealSideDirectionLeft | PPRevealSideDirectionRight ];
    self.revealSideViewController.delegate = self;
    
    lblNoFriendAround.hidden = NO;
    btnInvite.hidden = YES;
    [Helper setButton:btnInvite Text:@"Invite your friends!" WithFont:SEGOUE_UI FSize:14 TitleColor:[UIColor grayColor] ShadowColor:nil];
    [btnInvite.titleLabel setTextAlignment:NSTextAlignmentCenter];
    btnInvite.titleEdgeInsets = UIEdgeInsetsMake(-6, 15.0, 0.0, 0.0);
    [Helper setToLabel:lblNoFriendAround Text:@"Finding users with Wishiz!" WithFont:SEGOUE_UI FSize:17 Color:[UIColor blackColor]];
    lblNoFriendAround.textAlignment = NSTextAlignmentCenter;
    
    [imgvw.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [imgvw.layer setBorderWidth: 0.7];
    [mainImageView.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [mainImageView.layer setBorderWidth: 0.7];
    
    if (IS_IPHONE_5) {
        profileImageView = [[RoundedImageView alloc] initWithFrame:CGRectMake(105, 170, 110, 110)];
    }else{
        profileImageView = [[RoundedImageView alloc] initWithFrame:CGRectMake(105, 130, 110, 110)];
    }
    
    self.decision.text = @"Liked";
    self.decision.hidden = YES;
    
    //profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    profileImageView.clipsToBounds = YES;
    [self.view addSubview:profileImageView];
    
    [profileImageView downloadFromURL:[User currentUser].profile_pic withPlaceholder:[UIImage imageNamed:@"pfImage.png"]];
    
    viewItsMatched.backgroundColor = [Helper getColorFromHexString:@"#000000" :1.0];
    inAnimation = NO;
    waveLayer=[CALayer layer];
    if (IS_IPHONE_5) {
        waveLayer.frame = CGRectMake(155, 220, 10, 10);
    }else{
        waveLayer.frame = CGRectMake(155, 180, 10, 10);
    }
    waveLayer.borderWidth =0.2;
    waveLayer.cornerRadius =5.0;
    [self.view.layer addSublayer:waveLayer];
    profileImageView.hidden = NO;
    [waveLayer setHidden:NO];
    [self.view bringSubviewToFront:profileImageView];
    
    //self.viewPercentMatch.layer.cornerRadius=40.0f;
    self.viewPercentMatch.backgroundColor=[UIColor clearColor];
    
    _like_icon.transform = CGAffineTransformMakeRotation(-.34906585);
    _nope_icon.transform = CGAffineTransformMakeRotation(.34906585);
    [_like_icon setHidden:YES];
    [_nope_icon setHidden:YES];
    
    [self performSelector:@selector(sendRequestForGetMatches) withObject:nil afterDelay:5];
    
    
    /*BOOL isQuestionShow=[[NSUserDefaults standardUserDefaults]boolForKey:@"isQuestionShow"];
    if (!isQuestionShow)
    {
        QuestionVC *vcQue=[[QuestionVC alloc]initWithNibName:@"QuestionVC" bundle:nil];
        [self presentViewController:vcQue animated:YES completion:^{
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isQuestionShow"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
    }*/
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    PPRevealSideInteractions interContent = PPRevealSideInteractionContentView;
    self.revealSideViewController.panInteractionsWhenClosed = interContent;
    self.revealSideViewController.panInteractionsWhenOpened = interContent;
    
    //[self performSelector:@selector(sendRequestForGetMatches) withObject:nil afterDelay:5];
    [self performSelector:@selector(startAnimation) withObject:nil];
    [self performSelector:@selector(preloadLeft) withObject:nil afterDelay:0.1];
    [self performSelector:@selector(preLoadRight) withObject:nil afterDelay:0.3];
}

#pragma mark -
#pragma mark - Nav button methods

-(void)preloadLeft
{
    MenuViewController *menu=[[MenuViewController alloc]initWithNibName:@"MenuViewController" bundle:nil];
    [self.revealSideViewController preloadViewController:menu forSide:PPRevealSideDirectionLeft];
    PP_RELEASE(menu);
}

-(void)preLoadRight
{
    ChatViewController *menu = [[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];

    [self.revealSideViewController preloadViewController:menu forSide:PPRevealSideDirectionRight];
    PP_RELEASE(menu);
}

#pragma mark -
#pragma mark - requestForGetMatches

-(void)sendRequestForGetMatches
{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[User currentUser].fbid forKey:PARAM_ENT_USER_FBID];
    
    AFNHelper *afn=[[AFNHelper alloc]init];
    [afn getDataFromPath:@"findMatchesNew" withParamData:paramDict withBlock:^(id response, NSError *error)
    {
        if (response)
        {
            if ([[response objectForKey:@"errFlag"] intValue]==0)
            {
                NSArray *matches = [[NSOrderedSet orderedSetWithArray:response[@"matches"]] array];
                //NSArray *matches = response[@"matches"];
                
                
                if ([matches count] > 0) {
                    NSMutableArray *matchesTemp = [matches mutableCopy];
                    if ([[Helper sharedInstance] intCount]==0) {
                        [[Helper sharedInstance] setIntCount:matchesTemp.count];
                    }
                    while ([[Helper sharedInstance] intCount]+1<=matchesTemp.count) {
                        [matchesTemp removeObjectAtIndex:0];
                    }

                    [self performSelectorOnMainThread:@selector(fetchMatchesData:) withObject:matchesTemp waitUntilDone:NO];
                }else{
                    [Helper setToLabel:lblNoFriendAround Text:@"There's no one new around you." WithFont:SEGOUE_UI FSize:17 Color:[UIColor blackColor]];
                    btnInvite.hidden = NO;
                    lblNoFriendAround = NO;
                    [waveLayer setHidden:YES];
                }
            }
            else{
                [Helper setToLabel:lblNoFriendAround Text:@"There's no one new around you." WithFont:SEGOUE_UI FSize:17 Color:[UIColor blackColor]];
                btnInvite.hidden = NO;
                lblNoFriendAround = NO;
                [waveLayer setHidden:YES];
            }
        }else{
            [Helper setToLabel:lblNoFriendAround Text:@"There's no one new around you." WithFont:SEGOUE_UI FSize:17 Color:[UIColor blackColor]];
            btnInvite.hidden = NO;
            lblNoFriendAround = NO;
            [waveLayer setHidden:YES];
        }
    }];
}

-(void)fetchMatchesData:(NSArray*)matches
{

    myProfileMatches = [NSMutableArray arrayWithArray:matches];
    NSLog(@"%d", myProfileMatches.count);
    
    if(myProfileMatches.count>0)
    {
        NSMutableDictionary *dictForMutal=[myProfileMatches objectAtIndex:0];
        [TinderFBFQL executeFQlForMutualFriendForId:nil andFriendId:[dictForMutal valueForKey:@"fbId"] andDelegate:self];
        [self populateFundingCampaignCount:[dictForMutal valueForKey:@"profile_id"]];
        [self populateUserPhotoCount:[dictForMutal valueForKey:@"profile_id"]];
        
        for (NSDictionary *match in myProfileMatches)
        {
            NSString *pictureURL = [NSString stringWithFormat:@"%@userfiles/view_%@_%@_%@.jpg", MAIN_URL, match[@"profile_id"], match[@"photo_id"], match[@"index"]];
            
            [self imageDownloader:pictureURL forId:match[@"profile_id"]];
        }
        
    }
}



-(void)imageDownloader:(NSString*)url forId:(NSString*)fbid
{
    
    NSString *tmpDir = NSTemporaryDirectory();
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:url]
                                                        options:0
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize)
     {
     }
                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
     {
         if (image && finished)
         {
             NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0)];
             NSString *savePath = [tmpDir stringByAppendingPathComponent:fbid];
             [data writeToFile:[savePath stringByAppendingPathExtension:@"jpg"] atomically:YES];
             [self performSelectorOnMainThread:@selector(doneDownloadingImageFor:) withObject:fbid waitUntilDone:NO];
         }
     }];
}


-(void)doneDownloadingImageFor:(NSString*)fbid
{
    static NSInteger count = 0;
    count++;
    if (count != [myProfileMatches count]){
        lblNoFriendAround.hidden = YES;
        NSDictionary *match = [myProfileMatches objectAtIndex:0];

        mainImageView.clipsToBounds = YES;
        
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate * birthday = [dateFormatter dateFromString:match[@"birthdate"]];
        
        NSDate* now = [NSDate date];
        NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                           components:NSCalendarUnitYear
                                           fromDate:birthday
                                           toDate:now
                                           options:0];
        NSInteger age = [ageComponents year];
        NSString *userAge = [@(age) stringValue];
        
        NSString *savePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:match[@"profile_id"]] stringByAppendingPathExtension:@"jpg"];
        
        mainImageView.image = [UIImage imageWithContentsOfFile:savePath];
        NSArray *array = [match[@"real_name"] componentsSeparatedByString:@" "];
        NSString *nameage =[[NSString stringWithFormat:@"%@, %@", [array objectAtIndex:0], userAge] uppercaseString];

        [Helper setToLabel:nameLabel Text:[NSString stringWithString:nameage] WithFont:HELVETICALTSTD_ROMAN FSize:18 Color: WHITE_COLOR]   ;
        
        NSString *strMFC=[NSString stringWithFormat:@"%@",match[@"mutualFriendcout"]];
        
        if ([strMFC isEqualToString:@"(null)"]) {
            strMFC = @"0";
        }
        
        [waveLayer setHidden:YES];
        [profileImageView setHidden:YES];
        [btnInvite setHidden:YES];
        [lblNoFriendAround setHidden:YES];
        
        
        [matchesView setHidden:NO];
        [btnInvite setHidden:YES];
        
        
        original = visibleView1.center;
        visibleView1.hidden = NO;
        
        if (count > 1 && [myProfileMatches count]>1)
        {
            visibleView2.hidden = NO;
            visibleView2.clipsToBounds = YES;
            //imgvw.contentMode = UIViewContentModeScaleAspectFill;
            imgvw.clipsToBounds = YES;
            NSDictionary *match1 = [myProfileMatches objectAtIndex:1];
            NSString *savePath1 = [[NSTemporaryDirectory() stringByAppendingPathComponent:match1[@"profile_id"]] stringByAppendingPathExtension:@"jpg"];
            
            imgvw.image = [UIImage imageWithContentsOfFile:savePath1];
            NSArray *array = [match[@"real_name"] componentsSeparatedByString:@" "];

            [Helper setToLabel:nameLabel2 Text:[NSString stringWithFormat:@"%@, %@", array[0], match1[@"birthdate"]] WithFont:HELVETICALTSTD_ROMAN FSize:13 Color: WHITE_COLOR] ;
            //////////////
            [Helper setToLabel:lblMutualFriend2 Text:@"0" WithFont:HELVETICALTSTD_LIGHT FSize:19 Color: WHITE_COLOR] ;
            [Helper setToLabel:lblNoOfImage Text:[NSString stringWithFormat:@"0%@", match1[@"imgCnt"]] WithFont:HELVETICALTSTD_LIGHT FSize:19 Color: WHITE_COLOR] ;
        }
        else {
            visibleView2.hidden = YES;
        }
        count = 0;
    }
}

#pragma mark -
#pragma mark - actionForNopeAndLike

-(IBAction)pan:(UIPanGestureRecognizer*)gs
{
    NSDictionary *profile = [myProfileMatches objectAtIndex:0];
    CGPoint curLoc = visibleView1.center;
    CGPoint translation = [gs translationInView:gs.view.superview];
    float diff = 0;
    
    if (gs.state == UIGestureRecognizerStateBegan) {
    } else if (gs.state == UIGestureRecognizerStateChanged) {
        if (curLoc.x < original.x) {
            diff = original.x - curLoc.x;
            if (diff > 50)
                [_nope_icon setAlpha:1];
            else {
                [_nope_icon setAlpha:diff/50];
            }
            [_like_icon setHidden:YES];
            [_nope_icon setHidden:NO];
            
        }
        else if (curLoc.x > original.x) {
            diff = curLoc.x - original.x;
            if (diff > 50)
                [_like_icon setAlpha:1];
            else {
                [_like_icon setAlpha:diff/50];
            }
            
            [_like_icon setHidden:NO];
            [_nope_icon setHidden:YES];
        }
        
        gs.view.center = CGPointMake(gs.view.center.x + translation.x,
                                     gs.view.center.y + translation.y);
        [gs setTranslation:CGPointMake(0, 0) inView:self.view];
    }
    else if (gs.state == UIGestureRecognizerStateEnded)
    {
        if (![_nope_icon isHidden] || ![_like_icon isHidden])
        {
            [_nope_icon setHidden:YES];
            [_like_icon setHidden:YES];
            [visibleView1 setHidden:YES];
            visibleView1.center = original;
            visibleView1.frame = visibleView2.frame;
            visibleView1.clipsToBounds = YES;

            [visibleView1 setHidden:NO];
            diff = curLoc.x - original.x;
            
            if (abs(diff) > 50) {
                mainImageView.image = nil;
                //mainImageView.contentMode = UIViewContentModeScaleAspectFill;
                mainImageView.clipsToBounds = YES;
                mainImageView.image = imgvw.image;
                
                UIButton *btn = nil;
                if (diff > 0) {
                    btn = self.likedBtn;
                    //do liked
                    [self performSelector:@selector(updateNextProfileView) withObject:nil afterDelay:0];
                    [self performSelector:@selector(sendInviteAction:) withObject:@{@"profile_id": profile[@"profile_id"], @"action": [NSNumber numberWithInt:1]}];
                }
                else {
                    
                    btn = self.nopeBtn;
                    //do nope
                    [self performSelector:@selector(updateNextProfileView) withObject:nil afterDelay:0];
                    [self performSelector:@selector(sendInviteAction:) withObject:@{@"profile_id": profile[@"profile_id"], @"action": [NSNumber numberWithInt:2]}];
                    
                }
                
                self.decision.text = @"";
  
            }
        }
    }
}

-(void)updateNextProfileView
{
    [fundingImage setImage:nil];
    [myProfileMatches removeObjectAtIndex:0];
    [[Helper sharedInstance] setIntCount:myProfileMatches.count];
    if(myProfileMatches.count>0)
    {
        NSMutableDictionary *dictForMutal=[myProfileMatches objectAtIndex:0];
    }
    if ([myProfileMatches count] > 0)
    {
        NSDictionary *match = [myProfileMatches objectAtIndex:0];
        
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate * birthday = [dateFormatter dateFromString:match[@"birthdate"]];
        
        NSDate* now = [NSDate date];
        NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                           components:NSCalendarUnitYear
                                           fromDate:birthday
                                           toDate:now
                                           options:0];
        NSInteger age = [ageComponents year];
        NSString *userAge = [@(age) stringValue];
        
        NSArray *array = [match[@"real_name"] componentsSeparatedByString:@" "];
        [nameLabel setText:[NSString stringWithFormat:@"%@, %@", array[0], userAge]];
        
        NSString *savePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:match[@"profile_id"]] stringByAppendingPathExtension:@"jpg"];
   
        mainImageView.image = [UIImage imageWithContentsOfFile:savePath];
        
        [self populateFundingCampaignCount:match[@"profile_id"]];
        [self populateUserPhotoCount:match[@"profile_id"]];
        
        [waveLayer setHidden:YES];
        [profileImageView setHidden:YES];
        
        [matchesView setHidden:NO];
        
        original = visibleView1.center;
        
        if ([myProfileMatches count] > 1)
        {
            visibleView2.hidden = NO;
            visibleView2.clipsToBounds = YES;
            
            NSDictionary *match1 = [myProfileMatches objectAtIndex:1];
            NSString *savePath1 = [[NSTemporaryDirectory() stringByAppendingPathComponent:match1[@"profile_id"]] stringByAppendingPathExtension:@"jpg"];
            
            NSDateFormatter * dateFormatter1 = [[NSDateFormatter alloc]init];
            [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
            NSDate * birthday1 = [dateFormatter1 dateFromString:match1[@"birthdate"]];
            
            NSDate* now1 = [NSDate date];
            NSDateComponents* ageComponents1 = [[NSCalendar currentCalendar]
                                               components:NSCalendarUnitYear
                                               fromDate:birthday1
                                               toDate:now1
                                               options:0];
            NSInteger age = [ageComponents1 year];
            NSString *userAge1 = [@(age) stringValue];

            NSArray *array = [match[@"real_name"] componentsSeparatedByString:@" "];

            [nameLabel2 setText:[NSString stringWithFormat:@"%@, %@", array[0], userAge1]];
            
            imgvw.image = [UIImage imageWithContentsOfFile:savePath1];
            
            
        }
        else
        {
            visibleView2.hidden = YES;
        }
    }
    else
    {
        [matchesView setHidden:YES];
        [btnInvite setHidden:NO];
        [waveLayer setHidden:NO];
        [profileImageView setHidden:NO];
        [self performSelector:@selector(startAnimation) withObject:nil];
    }
}

-(IBAction)likeDislikeButtonAction:(UIButton*)sender
{
    
    NSDictionary *profile = [myProfileMatches objectAtIndex:0];
    UIImage *fundImage = [UIImage imageNamed:@"fund_icon_transparent"];
    UIImage *nopeImage = [UIImage imageNamed:@"nope_icon"];
    
        self.decision.hidden = YES;
        [self.view bringSubviewToFront:self.decision];
        if (sender.tag == 300) {
            self.decision.text = @"Liked";
            self.decision.textColor = [UIColor colorWithRed:0.001 green:0.548 blue:0.002 alpha:1.000];
            [fundingImage setImage: fundImage];
            [self performSelector:@selector(showUserProfile) withObject:nil afterDelay:1];
            [self performSelector:@selector(updateNextProfileView) withObject:nil afterDelay:2];
        }
        else {
            self.decision.text = @"Noped";
            self.decision.textColor = [UIColor redColor];
            [fundingImage setImage: nopeImage];
            [self performSelector:@selector(updateNextProfileView) withObject:nil afterDelay:1];
            [self performSelector:@selector(sendInviteAction:) withObject:@{@"profile_id": profile[@"profile_id"], @"action": [NSNumber numberWithInt:2]}];
        }
    
    
}

-(void)loadImageForSharedFrnd :(NSArray*)arrayFrnd
{
    commonFriends.text=[NSString stringWithFormat:@"%lu",(unsigned long)arrayFrnd.count];
}

-(void)loadImageForSharedIntrest:(NSArray*)arrayIntrst
{
}

-(IBAction)showUserProfile
{
    
    if ([myProfileMatches count]==0)
    {
        return;
    }
    ProfileVC *vc=[[ProfileVC alloc]initWithNibName:@"ProfileVC" bundle:nil];
    
    NSDictionary *dict=[myProfileMatches objectAtIndex:0];
    User *user=[[User alloc]init];
    user.fbid=[dict objectForKey:@"fbId"];
    user.profile_id=[dict objectForKey:@"profile_id"];
    
    NSArray*splitname = [[dict objectForKey:@"real_name"] componentsSeparatedByString:@" "];
    user.real_name = [splitname objectAtIndex:0];
    user.username=[splitname objectAtIndex:0];

    NSString *pictureURL = [NSString stringWithFormat:@"%@userfiles/view_%@_%@_%@.jpg", MAIN_URL, [dict objectForKey:@"profile_id"], [dict objectForKey:@"photo_id"], [dict objectForKey:@"index"]];
    user.profile_pic=pictureURL;
    vc.user=user;
    vc.user_profile_id =[dict objectForKey:@"profile_id"];
    [self.navigationController pushViewController:vc animated:NO];
    [fundingImage setImage:nil];

    
    
    [[NSUserDefaults standardUserDefaults] setObject:[User currentUser].profile_id forKey:@"currentProfileId"];
    [[NSUserDefaults standardUserDefaults] setObject:user.profile_id forKey:@"otherProfileId"];
    [[NSUserDefaults standardUserDefaults] setObject:user.real_name forKey:@"otherRealName"];
    [[NSUserDefaults standardUserDefaults] setObject:user.profile_pic forKey:@"otherProfilePic"];
//    [[NSUserDefaults standardUserDefaults] setObject:user.fbid forKey:@"otherFBid"];
//    [[NSUserDefaults standardUserDefaults] setObject:user.username forKey:@"otherUsername"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    DebugLog(@"CURRENT USER----->%@",[User currentUser].profile_id);
    DebugLog(@"PROFILE USR------>%@",user.profile_id);
    DebugLog(@"CURRENT PROFILE ID----->%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentProfileId"]);
    DebugLog(@"OTHER PROFILE ID------>%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"otherProfileId"]);
    DebugLog(@"OTHER REAL NAME----->%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"otherRealName"]);
    DebugLog(@"OTHER PROFILE PIC------>%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"otherProfilePic"]);
    DebugLog(@"OTHER FB ID----->%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"otherFBid"]);
    DebugLog(@"OTHER USERNAME------>%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"otherUsername"]);
    DebugLog(@"USER SITECONVID----->%@",[User currentUser].siteconvid);
    DebugLog(@"USER MATCH ID------>%@",[User currentUser].matchid);
}

-(void)donePreviewing:(NSNumber*)val
{
    if ([val integerValue] == 0) {
        return;
    }
    NSDictionary *profile = [myProfileMatches objectAtIndex:0];
    [self performSelector:@selector(sendInviteAction:) withObject:@{@"profile_id": profile[@"profile_id"], @"action": val}];
    [self performSelector:@selector(updateNextProfileView) withObject:nil afterDelay:0];
}

-(void)sendInviteAction:(NSDictionary*)params
{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:params[@"profile_id"]  forKey:PARAM_ENT_INVITEE_FBID];
    [paramDict setObject:flStrForObj(params[@"action"])  forKey:PARAM_ENT_USER_ACTION];
    [paramDict setObject:[User currentUser].fbid forKey:PARAM_ENT_USER_FBID];
    
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    handler.requestType = eParseKey;
    NSMutableURLRequest * request = [Service parseInviteAction:paramDict];
    [handler placeWebserviceRequestWithString:request Target:self Selector:@selector(inviteActionResponse:)];
}

-(void)inviteActionResponse:(NSDictionary*)response
{
    NSDictionary * dict1 = [response objectForKey:@"ItemsList"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    if ([[dict1 objectForKey:@"errFlag"]integerValue] ==0 &&[[dict1 objectForKey:@"errNum"]integerValue] ==55) {
        viewItsMatched.hidden = NO;
        
        for (NSString *str in [dict1 allKeys]) {
            [dict setObject:[dict1[str] isKindOfClass:(id)[NSNull class]]?@"":dict1[str] forKey:str];
        }
        [[UserDefaultHelper sharedObject]setItsMatch:[NSMutableDictionary dictionaryWithDictionary:dict]];
        
        [self.view bringSubviewToFront:viewItsMatched];
        
        [Helper setToLabel:lblItsMatchedSubText Text:[NSString stringWithFormat:@"You and %@ have liked each other.",dict[@"uName"]] WithFont:HELVETICALTSTD_LIGHT FSize:14 Color:[UIColor whiteColor]];
        
        lblItsMatchedSubText.textAlignment= NSTextAlignmentCenter;
        
        RoundedImageView *userImg  = [[RoundedImageView alloc] initWithFrame:CGRectMake(45, 125, 110, 110)];
        [userImg downloadFromURL:[User currentUser].profile_pic withPlaceholder:nil];
        
        RoundedImageView *FriendImg  = [[RoundedImageView alloc] initWithFrame:CGRectMake(155+20, 125, 110, 110)];
        UIActivityIndicatorView *activityIndicator=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(50/2-20/2, 46/2-20/2, 20, 20)];
        [FriendImg addSubview:activityIndicator];
        
        activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
        [activityIndicator startAnimating];
        
        NSString *pictureURL = [NSString stringWithFormat:@"%@userfiles/view_%@_%@_%@.jpg", MAIN_URL, dict[@"profile_id"], dict[@"photo_id"], dict[@"index"]];
        
        FriendImg.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:pictureURL]]];
        [activityIndicator stopAnimating];
        self.matchid =dict[@"matchid"];
        [viewItsMatched addSubview:userImg];
        [viewItsMatched addSubview:FriendImg];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    else{
        viewItsMatched.hidden = YES;
        lblNoFriendAround.hidden = NO;
        [Helper setToLabel:lblNoFriendAround Text:@"There's no one new around you." WithFont:SEGOUE_UI FSize:17 Color:[UIColor blackColor]];
        btnInvite.hidden = NO;
    }
    if (visibleView1.hidden == YES) {
        [Helper setToLabel:lblNoFriendAround Text:@"There's no one new around you." WithFont:SEGOUE_UI FSize:17 Color:[UIColor blackColor]];
        btnInvite.hidden = NO;
        lblNoFriendAround .hidden= NO;
        visibleView2.hidden = NO;
    }
}

-(void) populateFundingCampaignCount:(NSString *) profile_id
{
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setObject:profile_id forKey:PARAM_ENT_USER_PROFILE_ID];
    
    AFNHelper *afn=[[AFNHelper alloc]init];
    [afn getDataFromPath:METHOD_GET_FUNDING_CAMPAIGNS_COUNT withParamData:dictParam withBlock:^(id response, NSError *error)
     {
         if (response)
         {
             commonInterest.text = response[@"count"];
         }
     }];
}

-(void) populateUserPhotoCount:(NSString *) profile_id
{
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setObject:profile_id forKey:PARAM_ENT_USER_PROFILE_ID];
    
    AFNHelper *afn=[[AFNHelper alloc]init];
    [afn getDataFromPath:METHOD_GETPROFILE_PHOTOS_COUNT withParamData:dictParam withBlock:^(id response, NSError *error)
     {
         if (response)
         {
             picsCount.text = response[@"count"];
         }
     }];
}

-(void)getLocation
{
    [[LocationHelper sharedObject]startLocationUpdatingWithBlock:^(CLLocation *newLocation, CLLocation *oldLocation, NSError *error) {
        if (!error) {
            [[LocationHelper sharedObject]stopLocationUpdating];
            [super updateLocation];
        }
        else{
            NSLog(@"Error updating location.");
        }
    }];
    
}

-(IBAction)btnActionForItsMatchedView :(id)sender{
    
    UIButton * btn =(UIButton*)sender;
    if (btn.tag ==100) {
        viewItsMatched.hidden = YES;
    }
    else if (btn.tag ==200) {
        
        ProfileVC *vc=[[ProfileVC alloc]initWithNibName:@"ProfileVC" bundle:nil];
        
        NSMutableDictionary * dict=[[UserDefaultHelper sharedObject] itsMatch];
        
        User *user=[[User alloc]init];
        user.profile_id=dict[@"profile_id"];
        
        user.real_name = dict[@"uName"];
        
        NSString *pictureURL = [NSString stringWithFormat:@"%@userfiles/view_%@_%@_%@.jpg", MAIN_URL, [dict objectForKey:@"profile_id"], [dict objectForKey:@"photo_id"], [dict objectForKey:@"index"]];
        user.profile_pic=pictureURL;
        
        vc.user_profile_id =[dict objectForKey:@"profile_id"];
        vc.user=user;
        
        [self.navigationController pushViewController:vc animated:NO];
        [fundingImage setImage:nil];

        viewItsMatched.hidden = YES;
        
    }
    else{
        ProgressIndicator * pi = [ProgressIndicator sharedInstance];
        [pi showPIOnView:viewItsMatched withMessage:@"Loading.."];
        
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSMutableDictionary * dict=[[UserDefaultHelper sharedObject] itsMatch];
        
        NSString *imgpath = [NSString stringWithFormat:@"%@/image1.jpg",docDir];
        NSString *pictureURL = [NSString stringWithFormat:@"%@userfiles/view_%@_%@_%@.jpg", MAIN_URL, dict[@"profile_id"], dict[@"photo_id"], dict[@"index"]];
        NSURL *url = [NSURL URLWithString:[Helper removeWhiteSpaceFromURL:pictureURL]];
        
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:url
                                                            options:0
                                                           progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
             // progression tracking code
         }
                                                          completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
         {
             if (image && finished)
             {
                 NSData* theData  = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0)];
                 BOOL isWrite =[theData writeToFile:imgpath atomically:YES];
                 if (isWrite ==YES)
                 {
                     [[UserDefaultHelper sharedObject]setPath:imgpath];
                     [self performSelectorOnMainThread:@selector(pushToChatViewController:) withObject:dict waitUntilDone:YES];
                 }
             }
         }];
    }
}

-(void)pushToChatViewController :(NSDictionary *)dict
{
    NSMutableDictionary * dictChat = [[NSMutableDictionary alloc]init];
    JSDemoViewController *vc = [[JSDemoViewController alloc] init];
    vc.matchid = self.matchid;
    vc.siteconvid = @"";;
    vc.friendProfileId = dict[@"profile_id"];
    vc.status = @"";
    vc.ChatPersonNane =dict[@"uName"];
    
    NSString *pictureURL = [NSString stringWithFormat:@"%@userfiles/view_%@_%@_%@.jpg", MAIN_URL, dict[@"profile_id"], dict[@"photo_id"], dict[@"index"]];
    vc.matchedUserProfileImagePath = pictureURL;
    
   
    [dictChat setValue:dict[@"profile_id"] forKey:@"profile_id"];
    [dictChat setValue:@"" forKey:@"status"];
    
    [dictChat setValue:dict[@"real_name"] forKey:@"real_name"];
    [dictChat setValue:pictureURL forKey:@"profilePic"];
    
    vc.dictUser = dictChat;
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.revealSideViewController popViewControllerWithNewCenterController:n animated:YES];
    [self.revealSideViewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark - PPRevealSideViewControllerDelegate

- (BOOL) pprevealSideViewController:(PPRevealSideViewController *)controller shouldDeactivateGesture:(UIGestureRecognizer*)gesture forView:(UIView*)view
{
    
    if ([view isEqual:matchesView] ||
        [view isEqual:mainImageView] ||
        [view.superview isEqual:visibleView2] ||
        [view.superview isEqual:visibleView1] ||
        [view isEqual:visibleView1] ||
        [view isEqual:visibleView2] ||
        [view.superview isEqual:matchesView])
    {
        return YES;
    }
    return NO;
}

#pragma mark -
#pragma mark - Animation Methods

-(void)startAnimation
{
    if ([waveLayer isHidden] || ![self.view window] || inAnimation == YES)
    {
        return;
    }
    inAnimation = YES;
    [self waveAnimation:waveLayer];
}

-(void)waveAnimation:(CALayer*)aLayer
{
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.duration = 3;
    transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transformAnimation.removedOnCompletion = YES;
    transformAnimation.fillMode = kCAFillModeRemoved;
    [aLayer setTransform:CATransform3DMakeScale( 10, 10, 1.0)];
    [transformAnimation setDelegate:self];
    
    CATransform3D xform = CATransform3DIdentity;
    xform = CATransform3DScale(xform, 40, 40, 1.0);
    //xform = CATransform3DTranslate(xform, 60, -60, 0);
    transformAnimation.toValue = [NSValue valueWithCATransform3D:xform];
    [aLayer addAnimation:transformAnimation forKey:@"transformAnimation"];
    
    
    UIColor *fromColor = [UIColor colorWithRed:255 green:120 blue:0 alpha:1];
    UIColor *toColor = [UIColor colorWithRed:255 green:120 blue:0 alpha:0.1];
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    colorAnimation.duration = 3;
    colorAnimation.fromValue = (id)fromColor.CGColor;
    colorAnimation.toValue = (id)toColor.CGColor;
    
    [aLayer addAnimation:colorAnimation forKey:@"colorAnimationBG"];
    
    
    UIColor *fromColor1 = [UIColor colorWithRed:0 green:255 blue:0 alpha:1];
    UIColor *toColor1 = [UIColor colorWithRed:0 green:255 blue:0 alpha:0.1];
    CABasicAnimation *colorAnimation1 = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    colorAnimation1.duration = 3;
    colorAnimation1.fromValue = (id)fromColor1.CGColor;
    colorAnimation1.toValue = (id)toColor1.CGColor;
    
    [aLayer addAnimation:colorAnimation1 forKey:@"colorAnimation"];
}

- (void)animationDidStart:(CAAnimation *)anim
{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    inAnimation = NO;
    [self performSelectorInBackground:@selector(startAnimation) withObject:nil];
}

#pragma mark -
#pragma mark - Mail Methods

-(IBAction)openMail :(id)sender
{
    [super sendMailSubject:@"Wishiz.me App!" toRecipents:[NSArray arrayWithObject:@""] withMessage:@"I am using the Wishiz.me App! Why don't you try it out…<br/>Install Wishiz.me now !<br/><b>Google Play :-</b> <a href='#'>Wishiz.me/a><br/><b>iTunes :-</b>"];
}

#pragma mark -
#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 400) { //connection timeout error
        
    }
}

#pragma mark -
#pragma mark - Memory Mgmt

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
