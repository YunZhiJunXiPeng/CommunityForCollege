

#import "RootTabBarController.h"
#import "BookViewController.h"
#import "GirlBooksTableViewController.h"
#import "DouDouViewController.h"
#import "NewsViewController.h"
#import "TravelViewController.h"
#import "CFCNavigationController.h"
@interface RootTabBarController ()

@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
 
    self.tabBar.barTintColor = [UIColor colorWithRed:245.0/255 green:88.0/255 blue:135.0/255 alpha:1];
    self.tabBar.translucent = NO;
    /*****   设置所有UITabBarButton的文字属性 *******/
    [self setupItemTitleTextAttributes];
    
    /****   调用下面的方法  *****/
    /****   添加子控制器    *****/
    [self setupChileViewControllers];
  
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    
}



/*****   设置所有UITabBarButton的文字属性 *******/

- (void)setupItemTitleTextAttributes
{
    UITabBarItem *item = [UITabBarItem appearance];
    
    //   文字选中之前的样子
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    dic[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    [item setTitleTextAttributes:dic forState:(UIControlStateNormal)];
    
    //    文字选中之后的样子
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor colorWithRed:249.0/255 green:200.0/255 blue:24.0/255 alpha:1];
    
    [item setTitleTextAttributes:dict forState:(UIControlStateSelected)];
    
    
}


/****   添加子控制器    *****/

- (void)setupChileViewControllers
{

    [self setupOneChileViewController:[[CFCNavigationController alloc] initWithRootViewController:[[BookViewController alloc] init]] title:@"十年少" image:@"BookDeselect" selectedImage:@"BookSelected"];
     [self setupOneChileViewController:[[CFCNavigationController alloc] initWithRootViewController:[[NewsViewController alloc] init]] title:@"涨姿势" image:@"NewsDeselect" selectedImage:@"NewsSelected"];
    [self setupOneChileViewController:[[CFCNavigationController alloc] initWithRootViewController:[[DouDouViewController alloc] init]] title:@"打豆豆" image:@"Doudou2" selectedImage:@"Doudou1"];
   [self setupOneChileViewController:[[CFCNavigationController alloc] initWithRootViewController:[[TravelViewController alloc] init]]  title:@"去哪儿" image:@"Traveldeselect" selectedImage:@"TravelSelected"];
}

/**  初始化一个子控制器
 
 vc  子控制器
 title  标题
 image  未选中的图片
 selectedImage   选中时的图片
 
 */

- (void)setupOneChileViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    
    vc.tabBarItem.title = title;
    if (image.length) {
        UIImage*normalimage = [UIImage imageNamed:image];
        normalimage = [normalimage imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
        vc.tabBarItem.image = normalimage;
        
        UIImage*selectedImage2 = [UIImage imageNamed:selectedImage];
        selectedImage2 = [selectedImage2 imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
        vc.tabBarItem.selectedImage = selectedImage2;
    }
    [self addChildViewController:vc];
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
