//
//  GirlBooksTableViewController.m
//  Community-for-college
//
//  Created by lanou3g on 16/8/16.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "GirlBooksTableViewController.h"
#import "GirlBooksModel.h"
#import "GirlBooksTableViewCell.h"
#import "GirlBooksDetailViewController.h"


#import "CarouselFingure.h"
#import "MJRefresh.h"//下拉刷新加载
#import "Reachability.h"//网络状态
#import "NSObject+alertView.h"
@interface GirlBooksTableViewController ()<CarouselFingureDelegate>

@property (strong , nonatomic) NSMutableArray *dataArray;
@property (nonatomic)NSInteger loadingCount;

@end

@implementation GirlBooksTableViewController

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self session];
//    下拉刷新
    [self setupRefresh];
//    网络状态
    [self checkNetworkstate];


}



- (void)session{
    
    NSURL *url = [NSURL URLWithString:@"http://api.easou.com/api/bookapp/search.m?word=%E9%83%BD%E5%B8%82&type=2&sort_type=0&page_id=1&count=20&cid=eef_&version=002&os=ios&udid=21fd0800de1134e8474f17b36679535caf9374fd&appverion=1029&ch=bnf1349_10388_001&session_id="];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        for (NSDictionary *dic in dict[@"items"]) {
            GirlBooksModel *model = [GirlBooksModel new];
            [model setValuesForKeysWithDictionary:dic];

            [self.dataArray addObject:model];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{

            [self.tableView reloadData];
        });
        }
    }];
    [task resume];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (GirlBooksTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GirlBooksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[GirlBooksTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    GirlBooksModel *model = _dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GirlBooksDetailViewController *detail = [[GirlBooksDetailViewController alloc]init];
    GirlBooksModel *model = _dataArray[indexPath.row];
    detail.model = model;
    detail.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detail animated:YES];
    
}




#pragma mark - 刷新
-(void)setupRefresh
{
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    
    //********************* 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"马上为你刷新";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新";
    self.tableView.headerRefreshingText = @"正在为你刷新中";
    
    self.tableView.footerPullToRefreshText = @"马上为你加载";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载";
    self.tableView.footerRefreshingText = @"正在为你加载中";
    
    
}


- (void)footerRereshing
{
    _loadingCount++;
    //1监测wifi状态
    Reachability *wifi=[Reachability reachabilityForLocalWiFi];
    //检测手机是否能上网（wifi／3G／2G）
    Reachability *conn=[Reachability reachabilityForInternetConnection];
    //判断网络状态
    if ([wifi currentReachabilityStatus]!=NotReachable) {
        [self session];
        
    }else if ([conn currentReachabilityStatus]!=NotReachable){
        [self session];
        
    }else
    {
        [NSObject alterString:@"当前木有网络🙆🙆"];
    }
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
    });
}


#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新
        [self.tableView reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });
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
        [self session];
        
    }else if ([conn currentReachabilityStatus]!=NotReachable){
        [self session];
        
    }else
    {
        // 加载缓存数据
        //        [self selectData];
        [NSObject alterString:@"木有网络"];
        
    }
}
@end
