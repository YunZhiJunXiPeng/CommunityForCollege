//
//  LearningViewController.m
//  EnglishiLearing
//
//  Created by 卖女孩的小火柴 on 16/8/19.
//  Copyright © 2016年 梁海洋. All rights reserved.
//

#define DataURL @"http://dict.youdao.com/infoline?mode=publish&client=mobile&apiversion=3.0&lastId=0&style=image&abtest=1&client=mobile&deviceid=249e147d418017663d788835b93e0019&idfa=83903AA6-652F-4E34-ACFC-960F4C061376&imei=249e147d418017663d788835b93e0019&keyfrom=mdict.6.5.0.iphonepro&mid=9.3.3&model=iPhone7%2C2&ssid=Student&userid=m15210797693%40163.com&username=m15210797693%40163.com&vendor=AppStore"

#define reloadeDataURL1 @"http://dict.youdao.com/infoline?mode=publish&client=mobile&apiversion=3.0&lastId="
#define reloadeDataURL2 &style=image&abtest=1&client=mobile&deviceid=249e147d418017663d788835b93e0019&idfa=83903AA6-652F-4E34-ACFC-960F4C061376&imei=249e147d418017663d788835b93e0019&keyfrom=mdict.6.5.0.iphonepro&mid=9.3.3&model=iPhone7%2C2&ssid=Student&userid=m15210797693%40163.com&username=m15210797693%40163.com&vendor=AppStore

#import "LearningViewController.h"
#import "LearningTableViewCell.h"
#import "LearingModel.h"
#import "UIImageView+WebCache.h"
#import "CalculateTool.h"
#import "MJRefresh.h"
#import "Reachability.h"
#import "LearningVideoViewController.h"
#import "videoPlayView.h"
#import "NSObject+alertView.h"

@interface LearningViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *learningTVC;
@property (nonatomic,strong)UIWebView *webView;
//数据源数组
@property (nonatomic,strong)NSMutableArray *dataArray;
//数组ID
@property (nonatomic,strong)NSMutableArray *array_ID;
//model
@property (nonatomic,strong)LearingModel *model;


@end

@implementation LearningViewController


//懒加载数据源数组
- (NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化数组_array_ID
    _array_ID = [NSMutableArray arrayWithCapacity:10];
    
    
    [self redrawTableView];
    
    
    [self checkNetworkstate];
    [self setupRefresh];
    
    
    
}

//初始化tableView
- (void)redrawTableView
{
    _learningTVC = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _learningTVC.delegate = self;
    _learningTVC.dataSource = self;
    [self.view addSubview:_learningTVC];
    
    //注册cell
    [self.learningTVC registerClass:[LearningTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
}


#pragma mark - 网络
-(void)checkNetworkstate
{
    //1监测wifi状态
    Reachability *wifi=[Reachability reachabilityForLocalWiFi];
    //检测手机是否能上网（wifi／3G／2G）
    Reachability *conn=[Reachability reachabilityForInternetConnection];
    //判断网络状态
    if ([wifi currentReachabilityStatus]!=NotReachable) {
        [self jsonData];
        
    }else if ([conn currentReachabilityStatus]!=NotReachable){
        [self jsonData];
        
    }else
    {
        // 加载缓存数据
        //        [self selectData];
//        [NSObject alterString:@"木有网络"];
        
    }
    
    [self.learningTVC reloadData];
}


#pragma mark - 刷新
-(void)setupRefresh
{
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [self.learningTVC addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    
    //********************* 自动刷新(一进入程序就下拉刷新)
    [self.learningTVC headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.learningTVC addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.learningTVC.headerPullToRefreshText = @"马上为你刷新";
    self.learningTVC.headerReleaseToRefreshText = @"松开马上刷新";
    self.learningTVC.headerRefreshingText = @"正在为你刷新中";
    
    self.learningTVC.footerPullToRefreshText = @"马上为你加载";
    self.learningTVC.footerReleaseToRefreshText = @"松开马上加载";
    self.learningTVC.footerRefreshingText = @"正在为你加载中";
    
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    
        [self checkNetworkstate];
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.learningTVC headerEndRefreshing];
        
        // 刷新
        [self.learningTVC reloadData];
    });
    
    [self.learningTVC reloadData];
    
}


- (void)footerRereshing
{
    
    //1监测wifi状态
    Reachability *wifi=[Reachability reachabilityForLocalWiFi];
    //检测手机是否能上网（wifi／3G／2G）
    Reachability *conn=[Reachability reachabilityForInternetConnection];
    //判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) {
        [self reloadData];
        
    }else if ([conn currentReachabilityStatus]!=NotReachable){
        [self reloadData];
        
    }else
    {
//        [NSObject alterString:@"当前木有网络🙆🙆"];
    }
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.learningTVC reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.learningTVC footerEndRefreshing];
    });
    self.learningTVC.footerPullToRefreshText = @"马上为你加载";
    self.learningTVC.footerReleaseToRefreshText = @"松开马上加载";
    self.learningTVC.footerRefreshingText = @"正在为你加载中";
}

//json解析
- (void)jsonData
{
    //session解析
    NSString *str = DataURL;
    NSURL *urlStr = [NSURL URLWithString:str];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithURL:urlStr completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            //解析数据
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
            if (error == nil) {
                for (NSDictionary *dic in array) {
                    _model = [LearingModel new];
                    [_model setValuesForKeysWithDictionary:dic];
                    [_dataArray addObject:_model];
                   
                    [_array_ID addObject:_model.ID];
                    
                   
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.learningTVC reloadData];
        });
    }];
    [task resume];
}

//加载数据
- (void)reloadData
{
    //session解析
    NSString *string = _array_ID[9];
    [_array_ID removeAllObjects];
    
    NSString *dataStr = [[reloadeDataURL1 stringByAppendingString:string] stringByAppendingString:@"&style=image&abtest=1&client=mobile&deviceid=249e147d418017663d788835b93e0019&idfa=83903AA6-652F-4E34-ACFC-960F4C061376&imei=249e147d418017663d788835b93e0019&keyfrom=mdict.6.5.0.iphonepro&mid=9.3.3&model=iPhone7%2C2&ssid=Student&userid=m15210797693%40163.com&username=m15210797693%40163.com&vendor=AppStore"];

    NSURL *urlStr = [NSURL URLWithString:dataStr];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithURL:urlStr completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            //解析数据
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
            if (error == nil) {
                for (NSDictionary *dic in array) {
                    _model = [LearingModel new];
                    [_model setValuesForKeysWithDictionary:dic];
                    [_dataArray addObject:_model];
                    
                    [_array_ID addObject:_model.ID];
                }
                
            }
           
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.learningTVC reloadData];
        });
    }];
    [task resume];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//tableView高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
//tableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LearningTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.sendModel = [LearingModel new];
    cell.sendModel = _dataArray[indexPath.row];
    cell.titleLabel.text = cell.sendModel.title;
    cell.typeLabel.text = cell.sendModel.type;
    cell.typeLabel.frame = CGRectMake(CGRectGetMinX(cell.titleLabel.frame), CGRectGetMaxY(cell.titleLabel.frame) + 11, [CalculateTool widthForLableText:cell.typeLabel.text ForTextSize:17], 15);
    cell.typeLabel.font = [UIFont systemFontOfSize:13];
    cell.typeLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [cell.image_View sd_setImageWithURL:cell.sendModel.image[0]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LearningVideoViewController *learningVC = [LearningVideoViewController new];
    LearingModel *model = _dataArray[indexPath.row];
    learningVC.videoModel = model;
    learningVC.title = model.title;
    learningVC.videoURL = model.videourl;
    [self.navigationController pushViewController:learningVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
