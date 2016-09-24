//
//  LeftSortsViewController.m
//  Community-for-college
//
//  Created by 夏夕空 on 16/8/15.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "LeftSortsViewController.h"
#import "AppDelegate.h"
#import "NewsViewController.h"
#import "LoginAndRegister.h"
#import "LeftSortsTableViewCell.h"
#import "personalViewController.h"
#import "NSFileManager+ClearCache.h"
//夜间模式
#import "NightViewController.h"
//图片库
#import "LO_ViewController.h"

@interface LeftSortsViewController ()<UITableViewDelegate,UITableViewDataSource>;
@property (strong,nonatomic) UITableView*tableView;
@property (strong,nonatomic) NSMutableArray*dataArray;
@property (strong,nonatomic) UIView*headerView;
@property (strong,nonatomic) UIImageView*headerImage;
@property (strong,nonatomic) UILabel*prompt;
//等级
@property (nonatomic,assign)NSInteger level;
@property (nonatomic,strong)NSUserDefaults *timerLeverUD;
@property (nonatomic,strong)NSTimer *timer;
@property (strong,nonatomic) UILabel*LevelLabel;
@property (nonatomic,strong)AppDelegate *tempAppDelegate;
@property (strong,nonatomic) UIButton*LogOutButton;

@end

@implementation LeftSortsViewController
static NSString *Identifier = @"Identifier";
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self ChangeHeaderImage];
    [self showLogoutButton];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeLevelImageView) userInfo:nil repeats:YES];
    
    
}

- (void)changeLevelImageView
{
    
    _timerLeverUD = [NSUserDefaults standardUserDefaults];
    _level = [[_timerLeverUD objectForKey:@"level"] integerValue];
      NSInteger imageStar = _level / 20;
    _LevelLabel.text = [NSString stringWithFormat:@"等级：%ld级",_level];
    if (_level >= 0 && _level % 5 == 0)
    {
              
        switch (imageStar) {
            case 0:
                self.changeLevelIgeView.image = [UIImage imageNamed:@"level1.png"];
                break;
            case 1:
                self.changeLevelIgeView.image = [[UIImage imageNamed:@"level2.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                break;
            case 2:
                self.changeLevelIgeView.image = [[UIImage imageNamed:@"level3.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                break;
            case 3:
                self.changeLevelIgeView.image = [[UIImage imageNamed:@"level4.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                break;
            case 4:
                self.changeLevelIgeView.image = [[UIImage imageNamed:@"level5.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                break;
            case 5 :
                [_timer invalidate];
                _timer = nil;
                
                break;
                
            default:
                break;
        }
    }else if ( imageStar >=  5 && _changeLevelIgeView.image == nil){
         self.changeLevelIgeView.image = [UIImage imageNamed:@"奇花2"];
    }
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //等级图片
    _changeLevelIgeView = [[UIImageView alloc]initWithFrame:(CGRectMake(130, 80, 50, 55))];
//    等级
    _LevelLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [self changeLevelImageView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTableView];
    
    //初始化_tempAppDelegate
    _tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)createTableView{
    UITableView*tableView = [[UITableView alloc]init];
    tableView.frame = self.view.bounds;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.scrollEnabled = NO;
    tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    [tableView registerNib:[UINib nibWithNibName:@"LeftSortsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:Identifier];
    [self.view addSubview:tableView];
    
    
   
}


- (void)cancelled:(UIButton*)sender{
    NSUserDefaults*user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"name"];
    [self ChangeHeaderImage];
    [self showLogoutButton];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LeftSortsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:18.0f];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor blackColor];
    
    if (indexPath.row == 0) {
        cell.nameLabel.text = @"首页";
        cell.Image.image = [UIImage imageNamed:@"首页"];
    } else if (indexPath.row == 1) {
        cell.nameLabel.text = @"清除缓存";
        cell.Image.image = [UIImage imageNamed:@"清除缓存"];
    } else if (indexPath.row == 2) {
        cell.nameLabel.text = @"";
        cell.Image.image = [UIImage imageNamed:@""];
    } else if (indexPath.row == 3) {
        cell.nameLabel.text = @"个性装扮";
        cell.Image.image = [UIImage imageNamed:@"个性装扮"];
    } else if (indexPath.row == 4) {
        cell.nameLabel.text = @"";
        cell.Image.image = [UIImage imageNamed:@""];
    } else if (indexPath.row == 5) {
        cell.nameLabel.text = @"我的相册";
        cell.Image.image = [UIImage imageNamed:@"相册"];
    } else if (indexPath.row == 6) {
        cell.nameLabel.text = @"设置和帮助";
        cell.Image.image = [UIImage imageNamed:@"设置和帮助"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        _tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [_tempAppDelegate.LeftSlideVC closeLeftView]; //关闭左侧抽屉
        _tempAppDelegate.RootVC.selectedIndex = 0;
    }else if(indexPath.row == 1){
        //        清除缓存
        NSFileManager*fileManager = [NSFileManager defaultManager];
        NSString*path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
        float size = [fileManager floderSizeAtPath:path];
        UIAlertController*AlertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"缓存大小为%.2fMB确定要清除缓存吗",size] preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction*action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [fileManager clearCache:path];
        }];
        UIAlertAction*action2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
        [AlertController addAction:action];
        [AlertController addAction:action2];
        [self presentViewController:AlertController animated:YES completion:nil];

    }
    else if (indexPath.row == 3)
    {
        NightViewController *isNight = [NightViewController new];
        [_tempAppDelegate.LeftSlideVC closeLeftView]; //关闭左侧抽屉
        [_tempAppDelegate.RootVC.selectedViewController pushViewController:isNight animated:YES];
    }
    else if (indexPath.row == 5)
    {
        LO_ViewController *ViewController = [LO_ViewController new];
        [_tempAppDelegate.LeftSlideVC closeLeftView]; //关闭左侧抽屉
        [_tempAppDelegate.RootVC.selectedViewController pushViewController:ViewController animated:YES];
    }else if (indexPath.row == 6)
    {
        //详细信息
    personalViewController*personal =  [[personalViewController alloc]init];
    
    [_tempAppDelegate.LeftSlideVC closeLeftView];
    [_tempAppDelegate.RootVC.selectedViewController pushViewController:personal animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 43;
}

//  返回tableView的头视图
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 180;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 180)];
    view.backgroundColor = [UIColor colorWithRed:245.0/255 green:88.0/255 blue:135.0/255 alpha:1];
    UIImageView*headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, view.centerY - view.frame.size.width/4.8, view.frame.size.width/4, view.frame.size.width/4)];
    headerImage.backgroundColor = [UIColor whiteColor];
    headerImage.layer.cornerRadius = view.frame.size.width/8;
    headerImage.layer.masksToBounds = YES;
    
    _headerImage = headerImage;
    _headerView = view;
    
    UILabel*prompt = [[UILabel alloc]init];
    prompt.size = CGSizeMake(100, 30);
    prompt.centerX = _headerImage.centerX;
    prompt.centerY = CGRectGetMaxY(_headerImage.frame) + 10;
    prompt.textAlignment = NSTextAlignmentCenter;
    prompt.textColor = [UIColor whiteColor];
    _prompt = prompt;
     [self ChangeHeaderImage];
     [_headerView addSubview:prompt];
    [view addSubview:headerImage];
    
    
    [view addSubview:_changeLevelIgeView];
    
    
    _LevelLabel.center = CGPointMake(headerImage.centerX, headerImage.centerY + 60);
    _LevelLabel.font = [UIFont systemFontOfSize:15];
    _LevelLabel.textColor = [UIColor whiteColor];
    _LevelLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:_LevelLabel];
    [self showLogoutButton];
    return view;
}

//  显示或隐藏退出登录按钮
- (void)showLogoutButton{
    
    NSUserDefaults*user = [NSUserDefaults standardUserDefaults];
    NSString*name = [user objectForKey:@"name"];
    if (name) {
        UIButton*button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(_changeLevelIgeView.centerX, CGRectGetMaxY(_LevelLabel.frame) + 5, 80, 30);
        [button addTarget:self action:@selector(cancelled:) forControlEvents:(UIControlEventTouchUpInside)];
        [button setBackgroundImage:[UIImage imageNamed:@"Login_0005_button-bg"] forState:(UIControlStateNormal)];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:@"退出登录" forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _LogOutButton = button;
        [_headerView addSubview:button];
    }else{
        [_LogOutButton removeFromSuperview];
    }
}


//  判断登录状态改变headerImage
- (void)ChangeHeaderImage{
    NSUserDefaults*user = [NSUserDefaults standardUserDefaults];
    NSString*userName = [user objectForKey:@"name"];
    _headerImage.userInteractionEnabled = YES;
    if (!userName) {
        _headerImage.image = [UIImage imageNamed:@"未登录"];
        _prompt.font = [UIFont systemFontOfSize:15];
        UITapGestureRecognizer*gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(LoginTap:)];
        [_headerImage addGestureRecognizer:gesture];
        _prompt.text = @"点击头像登录";
    }else{
        _headerImage.image = [UIImage imageNamed:@"已登录"];
        _prompt.font = [UIFont systemFontOfSize:15];
        _prompt.text = userName;
         UITapGestureRecognizer*gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(PersonalTap:)];
         [_headerImage addGestureRecognizer:gesture];

    }
}


// 未登录 点击头像跳入的界面
- (void)LoginTap:(UIGestureRecognizer*)sender{
    LoginAndRegister*login = [[LoginAndRegister alloc]initWithNibName:@"LoginAndRegister" bundle:[NSBundle mainBundle]];
    UINavigationController*nav = [[UINavigationController alloc]initWithRootViewController:login];
    [self showViewController:nav sender:nil];
}

//  登陆之后 点击头像跳入的界面
- (void)PersonalTap:(UIGestureRecognizer*)sender{
    LO_ViewController *camerVC = [LO_ViewController new];
    [_tempAppDelegate.LeftSlideVC closeLeftView]; //关闭左侧抽屉
    [_tempAppDelegate.RootVC.selectedViewController pushViewController:camerVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

@end
