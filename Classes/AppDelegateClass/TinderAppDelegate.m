//
//  TinderAppDelegate.m
//  Tinder
//
//  Created by Rahul Sharma on 24/11/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#import "TinderAppDelegate.h"
#import "SplashVC.h"
#import "ChatViewController.h"
#import "JSDemoViewController.h"
#import "PayPalMobile.h"

#define _offsetValue 62
#define _animated  YES
NSString *const FBSessionStateChangedNotification =
@"com.facebook.samples.Tinder:FBSessionStateChangedNotification";

@implementation TinderAppDelegate

@synthesize navigationController;
@synthesize loggedInSession;
@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //For Push Noti Reg.
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
 
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.vcSplash = [[SplashVC alloc]initWithNibName:@"SplashVC" bundle:nil];
    self.window.rootViewController = self.vcSplash;
    [self.window makeKeyAndVisible];
    
    [self customizeNavigationBar];
    
    [[FacebookUtility sharedObject]getFBToken];
    
    [FBProfilePictureView class];
    
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"AXLjFRDk7ooLDf-zX9B2uKlxXwATgcaHOIpxBE4ogYk6bELOutqX5UNKmU4k",
                                                           PayPalEnvironmentSandbox : @"AVpJkRCGI8Fhftf0paClu8vchhP78zlkSYRAeD8NRal8bBXdHfECTxxKnIGj"}];
    
    [FBLoginView class];

    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
    NSString *dt = [[deviceToken description] stringByTrimmingCharactersInSet:
                    [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    dt = [dt stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[UserDefaultHelper sharedObject]setDeviceToken:dt];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	DLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession closeAndClearTokenInformation];
    [[FBSession activeSession] close];
    [[FBSession activeSession] closeAndClearTokenInformation];
    [FBSession setActiveSession:nil];
    //
    //
    //        [FBAppCall handleDidBecomeActive];
    //        [[FBSession activeSession] handleDidBecomeActive];
    
    // if the app is going away, we close the session if it is open
    // this is a good idea because things may be hanging off the session, that need
    // releasing (completion block, etc.) and other components in the app may be awaiting
    // close notification in order to do cleanup
    [[FacebookUtility sharedObject].session close];

}
#pragma mark -
#pragma mark - FBSetion Methods

- (void) closeSession
{
    //[[FBSession activeSession] closeAndClearTokenInformation];
    
    
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
   
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

#pragma mark -
#pragma mark - Facebook Methods

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[FacebookUtility sharedObject].session];
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext_ != nil)
    {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"Tinder" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel_;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
    NSURL *storeURL = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Tinder.sqlite"]];
    
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    
    NSDictionary *options = @{ NSSQLitePragmasOption : @{@"journal_mode" : @"DELETE"} };
    
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return persistentStoreCoordinator_;
}

#pragma mark -
#pragma mark - Utility Methods

-(void)addBackButton:(UINavigationItem*)naviItem
{
    UIImage *imgButton = [UIImage imageNamed:@"menu_icon_off.png"];
	UIButton *leftbarbutton = [UIButton buttonWithType:UIButtonTypeCustom];
	[leftbarbutton setBackgroundImage:imgButton forState:UIControlStateNormal];
    [leftbarbutton setBackgroundImage:[UIImage imageNamed:@"menu_icon_on.png"] forState:UIControlStateHighlighted];
	[leftbarbutton setFrame:CGRectMake(0, 0, imgButton.size.width, imgButton.size.height)];
    [leftbarbutton addTarget:self action:@selector(menuClicked) forControlEvents:UIControlEventTouchUpInside];
    naviItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftbarbutton];
}
-(void)menuClicked
{
    MenuViewController *menu=[[MenuViewController alloc]initWithNibName:@"MenuViewController" bundle:nil];
    _revealSideViewController.delegate = self;
    [_revealSideViewController pushViewController:menu onDirection:PPRevealSideDirectionLeft withOffset:_offsetValue animated:_animated];
    PP_RELEASE(menu);
}
-(void)addrightButton:(UINavigationItem*)naviItem
{
    UIImage *imgButton = [UIImage imageNamed:@"chat_icon_off_line.png"];
	UIButton *rightbarbutton = [UIButton buttonWithType:UIButtonTypeCustom];
	[rightbarbutton setBackgroundImage:imgButton forState:UIControlStateNormal];
    [rightbarbutton setBackgroundImage:[UIImage imageNamed:@"chat_icon_on_line.png"] forState:UIControlStateHighlighted];
	[rightbarbutton setFrame:CGRectMake(0, 0, imgButton.size.width, imgButton.size.height)];
    [rightbarbutton addTarget:self action:@selector(chatbuttonClicked) forControlEvents:UIControlEventTouchUpInside];
    naviItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbarbutton];
}
-(void)chatbuttonClicked
{
    [[Helper sharedInstance] setIntLike:1];
    ChatViewController *menu=[[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
    _revealSideViewController.delegate = self;
    [_revealSideViewController pushViewController:menu onDirection:PPRevealSideDirectionRight withOffset:_offsetValue animated:_animated];
    PP_RELEASE(menu);
}

-(void)customizeNavigationBar
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigation_bar.png"]
                                       forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], UITextAttributeTextColor,
      [UIColor clearColor], UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
      [UIFont fontWithName:HELVETICALTSTD_LIGHT size:15.0], UITextAttributeFont, nil]];
}

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
*/

- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark -
#pragma mark - sharedAppDelegate

+(TinderAppDelegate *)sharedAppDelegate
{
    return (TinderAppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void)showToastMessage:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.detailsLabelText = message;
	hud.margin = 10.f;
	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:2.0];
}

@end