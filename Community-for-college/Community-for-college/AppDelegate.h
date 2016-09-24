

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LeftSlideViewController.h"
#import "RootTabBarController.h"
@class RootTabBarController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+(AppDelegate *)appDelegte;
//夜间模式使用
-(void)changeImageAlpha;

@property (strong, nonatomic) LeftSlideViewController *LeftSlideVC;
@property (strong,nonatomic) RootTabBarController*RootVC;



@end

