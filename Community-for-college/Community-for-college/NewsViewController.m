
#import "NewsViewController.h"
#import "HeadlineTableViewController.h"
#import "InformationTableViewController.h"
#import "PhoneTableViewController.h"
#import "GameTableViewController.h"
#import "HeaderOfNews.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "NSObject+alertView.h"
#import "LearningViewController.h"
@interface NewsViewController ()<UIScrollViewDelegate>
{
    CGFloat _historyY;
    NSInteger _whichTableView;
}

@property (nonatomic)BOOL isNO;
@property (nonatomic,retain)UIView *myView;
@property (nonatomic,retain)UIButton *changeBT;

@end

@implementation NewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;

    self.navigationController.navigationBar.barTintColor =  [UIColor colorWithRed:245.0/255 green:88.0/255 blue:135.0/255 alpha:1];
    self.title = @"涨姿势";
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    // 网络
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
    
//    self.conn=[Reachability reachabilityForInternetConnection];
//    [self.conn startNotifier];
    
    //
    [self layoutUI];
    
    // 自定义NavigationBar
//    [self layoutNavigationBar];
    
    // 字体 夜间模式
//    [self layoutFontNightButton];
    
}

// 加载不同列表界面
-(void)loadTableView:(NSInteger)tableView
{
    switch (tableView) {
            
        case 0:
            [self addChildViewController:self.headlineTC];
            [_scrollView addSubview:self.headlineTC.tableView];

            break;
        case 1:
            [self addChildViewController:self.informationTC];
            [_scrollView addSubview:self.informationTC.tableView];

            break;
        case 2:
            [self addChildViewController:self.phoneTC];
            [_scrollView addSubview:self.phoneTC.tableView];

            break;
        case 3:
            [self addChildViewController:self.gameTC];
            [_scrollView addSubview:self.gameTC.tableView];
            
        case 4:
            [self addChildViewController:self.learnVC];
            [_scrollView addSubview:self.learnVC.view];
            break;
        
    }
}

#pragma mark-----Reachability
-(void)networkStateChange
{
    [self checkNetworkstate];
}

-(void)checkNetworkstate
{
    //1监测wifi状态
    Reachability *wifi=[Reachability reachabilityForLocalWiFi];
    //检测手机是否能上网（wifi／3G／2G）
    Reachability *conn=[Reachability reachabilityForInternetConnection];
    //判断网络状态
    if ([wifi currentReachabilityStatus]!=NotReachable) {
        [NSObject alterString:@"~有wifi啦~"];
    }else if ([conn currentReachabilityStatus]!=NotReachable){
        
        [NSObject alterString:@"~小心流量走光房产成移动的啦~"];
    }else
    {
//        [NSObject alterString:@"~木有网络~"];
    }
}

-(void)dealloc
{
//    [self.conn stopNotifier];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark-----NavigationBar
//自定义NavigationBar
-(void)layoutNavigationBar
{
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(lineAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

// 右button
-(void)lineAction:(UIBarButtonItem *)button
{
    if (_isNO) {
        [UIView beginAnimations:@"animat" context:nil];
        //设置时间
        [UIView setAnimationDuration:0.8f];
        self.myView.transform = CGAffineTransformMakeTranslation(0, 265);
        self.myView.transform = CGAffineTransformScale(self.myView.transform, 1.01, 1.01);
        [UIView commitAnimations];
        _isNO = NO;
    }else{
        [UIView beginAnimations:@"animat" context:nil];
        [UIView setAnimationDuration:0.8f];
        self.myView.transform = CGAffineTransformMakeTranslation(0, -265);
        self.myView.transform = CGAffineTransformScale(self.myView.transform, 0.01, 1.01);
        [UIView commitAnimations];
        _isNO = YES;
    }
}

#pragma mark----- 夜间模式

- (void)viewWillAppear:(BOOL)animated
{
    _userDefault = [NSUserDefaults standardUserDefaults];
    [self changeNight];
}
- (void)changeNight
{
    
    _strNight = [_userDefault objectForKey:@"style"];
    if (_strNight == nil) {
        [_changeBT setBackgroundImage:[UIImage imageNamed:@"night"] forState:UIControlStateNormal];
       
        //        [[AppDelegate appDelegte] changeImageAlpha];
        [_userDefault removeObjectForKey:@"style"];
        [_userDefault synchronize];
        
        
        
    }else if([_strNight isEqualToString:@"LOVE"])
    {
        
        [_changeBT setBackgroundImage:[UIImage imageNamed:@"sun"] forState:UIControlStateNormal];
        
        //        [[AppDelegate appDelegte] changeImageAlpha];
        [_userDefault setObject:@"LOVE"forKey:@"style"];
        [_userDefault synchronize];
        
    }
}


-(void)layoutFontNightButton
{
    self.myView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN.size.width -44, -260, 35, 200)];
    _myView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:0.9];
    _myView.layer.cornerRadius = 15;
    [self.view addSubview:_myView];
    
    self.changeBT = [UIButton buttonWithType:UIButtonTypeSystem];
    _changeBT.frame = CGRectMake(3, 150, 30, 30);
    [_changeBT addTarget:self action:@selector(changColor:) forControlEvents:UIControlEventTouchDown];
    //changeBT.backgroundColor = [UIColor redColor];
    [_changeBT setBackgroundImage:[UIImage imageNamed:kNightImage] forState:UIControlStateNormal];
    [_myView addSubview:_changeBT];
    
    self.isNO = YES;
    
}

//夜间模式
-(void)changColor:(UIButton *)button
{
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    _strNight = [_userDefault objectForKey:@"style"];
    if (_strNight == nil) {
        [_changeBT setBackgroundImage:[UIImage imageNamed:kSunImage] forState:UIControlStateNormal];
        [[AppDelegate appDelegte] changeImageAlpha];
        
        [_userDefault setObject:@"LOVE"forKey:@"style"];
        [_userDefault synchronize];
        
        
    }else if([_strNight isEqualToString:@"LOVE"])
    {
        [_changeBT setBackgroundImage:[UIImage imageNamed:kNightImage] forState:UIControlStateNormal];
        [[AppDelegate appDelegte] changeImageAlpha];
        [_userDefault removeObjectForKey:@"style"];
        [_userDefault synchronize];
        
    }
}

#pragma mark-----标头
-(void)layoutUI
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 35)];
    
    view.backgroundColor = [UIColor colorWithRed:1.0 green:113 / 255.0 blue:180 / 255.0 alpha:1.0];
    view.opaque = NO;
    
    NSArray *array = @[@"头条", @"资讯",  @"手机", @"游戏",@"视频"];
    
    for (int i = 0; i < 5; i++) {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeSystem];
        bt.frame = CGRectMake(13 + (Size.width - 25) * i / 5, 0, 60, 35);
        [bt setTitle:array[i] forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bt addTarget:self action:@selector(showNews:) forControlEvents:UIControlEventTouchUpInside];
        bt.tag = 100 + i;
        [view addSubview:bt];
        
    }
    
    self.redView = [[UIView alloc] initWithFrame:CGRectMake(19, 3, 50, 30)];
    _redView.backgroundColor = [UIColor whiteColor];
    _redView.alpha = 0.3;
    _redView.layer.cornerRadius = 5;
    [view addSubview:_redView];
    
    //********************  scrollView  ********************
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -24, Size.width, Size.height - 40)];
    //    self.scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(Size.width * 5, Size.height - 40);
    _scrollView.bounces = NO;
    
    //********************  tableView  ********************
    self.headlineTC = [[HeadlineTableViewController alloc] init];
    self.informationTC = [[InformationTableViewController alloc] init];
    self.phoneTC = [[PhoneTableViewController alloc] init];
    self.gameTC = [[GameTableViewController alloc] init];
    self.learnVC = [[LearningViewController alloc]init];
    
    self.headlineTC.tableView.frame = CGRectMake(0, 59, Size.width, Size.height - 40);
    self.informationTC.tableView.frame = CGRectMake(Size.width * 1, 59, Size.width, Size.height - 40);
    self.phoneTC.tableView.frame = CGRectMake(Size.width * 2, 59, Size.width, Size.height - 40);
    self.gameTC.tableView.frame = CGRectMake(Size.width * 3, 59, Size.width, Size.height - 40);
    self.learnVC.view.frame = CGRectMake(Size.width * 4, 59, Size.width, Size.height - 40);
    
    
    [self addChildViewController:self.headlineTC];
    

    [_scrollView addSubview:self.headlineTC.tableView];
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    [self.view addSubview:view];
    
}

#pragma mark-----小横杠的位置
- (void)showViewFrameByTableView:(NSInteger)whichTableView
{
    if (whichTableView == 0) {
        
        [UIView beginAnimations:@"温柔滚动" context:@"context"];
        [UIView setAnimationDuration:0.5];
        self.redView.frame = CGRectMake(19, 3, 50, 30);
        _redView.backgroundColor = [UIColor whiteColor];
        _redView.alpha = 0.3;
        _redView.layer.cornerRadius = 5;
        [UIView commitAnimations];
        
    } else if (whichTableView == 1) {
        [UIView beginAnimations:@"温柔滚动" context:@"context"];
        [UIView setAnimationDuration:0.5];
        self.redView.backgroundColor = [UIColor whiteColor];
        _redView.alpha = 0.3;
        _redView.layer.cornerRadius =5;
        self.redView.frame = CGRectMake(13 + (Size.width - 25) * 1 / 5 + 3, 3, 50, 30);
        [UIView commitAnimations];
    } else if (whichTableView == 2) {
        
        [UIView beginAnimations:@"温柔滚动" context:@"context"];
        [UIView setAnimationDuration:0.5];
        self.redView.backgroundColor = [UIColor whiteColor];
        _redView.alpha = 0.3;
        _redView.layer.cornerRadius = 5;
        self.redView.frame = CGRectMake(13 + (Size.width - 25) * 2 / 5 + 4, 3, 50, 30);
        [UIView commitAnimations];
    } else if (whichTableView == 3) {
       
        [UIView beginAnimations:@"温柔滚动" context:@"context"];
        [UIView setAnimationDuration:0.5];
        self.redView.backgroundColor = [UIColor whiteColor];
        _redView.alpha = 0.3;
        _redView.layer.cornerRadius = 5;
        self.redView.frame = CGRectMake(13 + (Size.width - 25) * 3 / 5 + 5, 3, 50, 30);
        [UIView commitAnimations];
    }
    else if (whichTableView == 4) {
        
        [UIView beginAnimations:@"温柔滚动" context:@"context"];
        [UIView setAnimationDuration:0.5];
        self.redView.backgroundColor = [UIColor whiteColor];
        _redView.alpha = 0.3;
        _redView.layer.cornerRadius = 5;
        self.redView.frame = CGRectMake(13 + (Size.width - 25) * 4 / 5 + 5, 3, 50, 30);
        [UIView commitAnimations];
    }
}

#pragma mark---button的点击方法
-(void)showNews:(UIButton*)button
{
    switch (button.tag) {
            
        case 100:
            self.scrollView.contentOffset = CGPointMake(0, 0);
            _whichTableView = 0;
            break;
        case 101:
            self.scrollView.contentOffset = CGPointMake(SCREEN.size.width, 0);
            _whichTableView = 1;
            break;
        case 102:
            self.scrollView.contentOffset = CGPointMake(SCREEN.size.width * 2, 0);
            _whichTableView = 2;
            break;
        case 103:
            self.scrollView.contentOffset = CGPointMake(SCREEN.size.width * 3, 0);
            _whichTableView = 3;
            break;
        case 104:
            self.scrollView.contentOffset = CGPointMake(SCREEN.size.width * 4, 0);
            _whichTableView = 4;
            break;
    }
    [self showViewFrameByTableView:_whichTableView];
    
}

#pragma mark ----- 如果是上下滚动  不翻页 小横岗不改变
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _historyY = scrollView.contentOffset.y;
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y != _historyY) {
        
    }else{
        if (_scrollView.contentOffset.x <=SCREEN.size.width/2)
        {
            _whichTableView = 0;
            
        }
        else if(_scrollView.contentOffset.x >=SCREEN.size.width/2 &&_scrollView.contentOffset.x <= SCREEN.size.width*1)
        {
            _whichTableView = 1;
            
        } else if (_scrollView.contentOffset.x >= SCREEN.size.width *3/2&&_scrollView.contentOffset.x <= SCREEN.size.width*2)
        {
            _whichTableView = 2;
            
        } else if (_scrollView.contentOffset.x >= SCREEN.size.width *4/2&&_scrollView.contentOffset.x <= SCREEN.size.width *3)
        {
            _whichTableView = 3;
            
        }
        else if (_scrollView.contentOffset.x >= SCREEN.size.width *5/2&&_scrollView.contentOffset.x <= SCREEN.size.width *4)
        {
            _whichTableView = 4;
            
        }
        [self loadTableView:_whichTableView];
        [self showViewFrameByTableView:_whichTableView];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
