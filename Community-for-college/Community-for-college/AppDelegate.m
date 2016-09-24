
#import "AppDelegate.h"
#import "LeftSortsViewController.h"
#import "LeftSlideViewController.h"
//友盟



@interface AppDelegate ()
@property (nonatomic, retain)UIImageView *imageView;
@property (nonatomic,retain)UIImageView *splashView;

@property (nonatomic,strong)NSTimer *loginTime;
@property (nonatomic,assign)NSInteger timeNumber;
@property (nonatomic,strong)NSUserDefaults *timerLeverUD;
@property (nonatomic,assign)NSInteger level;
@end
static AppDelegate *_appDelegate;
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    _RootVC =  [RootTabBarController new];
    LeftSortsViewController*sortVC = [LeftSortsViewController new];
   _LeftSlideVC = [[LeftSlideViewController alloc]initWithLeftView:sortVC andMainView:_RootVC];
    self.window.rootViewController = _LeftSlideVC;
//    [NSThread sleepForTimeInterval:1.0f];
    
    [self.window makeKeyAndVisible];
    
    
    _appDelegate = self;
    [self layoutKato];    
    
//    [self changeImageAlpha];

    
#pragma mark ------ 会员等级 ------
    _timerLeverUD = [NSUserDefaults standardUserDefaults];
        [_timerLeverUD removeObjectForKey:@"timerNumber"];
        [_timerLeverUD removeObjectForKey:@"level"];
    _loginTime = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(addLoginTime) userInfo:nil repeats:YES];
    _timeNumber = 0;
    _timeNumber = [[_timerLeverUD objectForKey:@"timerNumber"] integerValue];
    
    _level = [[_timerLeverUD objectForKey:@"level"] integerValue];
#pragma mark ------------
    

       return YES;
}
+(AppDelegate *)appDelegte
{
    return _appDelegate;
}
-(void)layoutKato
{
    self.imageView = [[UIImageView alloc]initWithFrame:self.window.bounds];
    _imageView.image = [UIImage imageNamed:@"black.png"];
    _imageView.alpha = 0.0;
    
    [self.window addSubview:_imageView];

}

-(void)changeImageAlpha
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString*str  = [userDefault objectForKey:@"style"];
    if (str) {
        self.imageView.alpha = 0;
    }else
    {
        self.imageView.alpha = 0.3;
    }
    
    
//    if ([CommonHandle shareHandle].isWhite == YES) {
//        self.imageView.alpha = 0.6;
//        
//    }else if ([CommonHandle shareHandle].isWhite == NO)
//    {
//        self.imageView.alpha = 0;
//    }
}


#pragma mark ------ 会员等级 ------
- (void)addLoginTime
{
    
    _timeNumber ++;
    
    [_timerLeverUD removeObjectForKey:@"timerNumber"];
    [_timerLeverUD setObject:[NSString stringWithFormat:@"%ld",_timeNumber] forKey:@"timerNumber"];
    
    
//    NSLog(@"--------%ld",_timeNumber);
//    NSLog(@"%ld",_level);
    
    if (_timeNumber >= 10 && _timeNumber % 10 == 0) {
        NSLog(@"等级加%ld",(_timeNumber / 10));
        
        _level ++;
        [_timerLeverUD removeObjectForKey:@"level"];
        [_timerLeverUD setObject:[NSString stringWithFormat:@"%ld",_level] forKey:@"level"];
        [_timerLeverUD synchronize];
        
       
//        NSLog(@"等级%ld",_level );
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "--.Community_for_college" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Community_for_college" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Community_for_college.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

//  禁止横屏
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        
        return UIInterfaceOrientationMaskAll;
    
    else  /* iphone */
        
        return UIInterfaceOrientationMaskPortrait ;
}


@end
