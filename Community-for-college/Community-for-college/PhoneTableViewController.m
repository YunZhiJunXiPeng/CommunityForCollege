//
//  PhonTableViewController.m
//  Community-for-college
//
//  Created by 卖女孩的小火柴 on 16/8/15.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
#import "PhoneTableViewController.h"
#import "Reachability.h"//网络状态
#import "MJRefresh.h"//下拉加载
#import "DetailViewController.h"//详情页面
#import "CellForOneImage.h"//自定义cell1
#import "CellForThreeImage.h"//自定义cell2
#import <UIImageView+WebCache.h>//网络图片解析要用
#import "RequstHandle.h"//请求数据单例
#import "ListModel.h"//列表model
#import "HeaderOfNews.h"//url接口等
#import "BigTableViewCell.h"//首页cell
#import "AttributedLabel.h"//lable布局
#import "NSObject+alertView.h"//提示alert
@interface PhoneTableViewController ()
@property (nonatomic,strong)NSMutableArray *dataArray;
//加载数据计数
@property (nonatomic,assign)NSInteger loadingCount;
//显示详情的cell
@property (nonatomic,strong)BigTableViewCell *cell;
@end

@implementation PhoneTableViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.loadingCount = 0;
    
    // 加载缓存数据
    //    [self selectData];
    
    [self checkNetworkstate];
    
    // 集成刷新空间
    [self setupRefresh];
    
}
//检测网络状态
- (void)checkNetworkstate
{
    //1、检测wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    //2、检测手机是否能上网(wifi\2G\3G\4G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    //3、判断网络状态
    if ([wifi currentReachabilityStatus]!= NotReachable) {
        [self requestData];
    }else if([conn currentReachabilityStatus] != NotReachable)
    {
        [self requestData];
    }
    else
    {
//        [NSObject alterString:@"木有网络"];
    }
}
#pragma mark ---- 刷新
- (void)setupRefresh
{
    //1、dataKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh) dateKey:@"table"];
    //自动刷新(点击进入该页面时触发)
    [self.tableView headerBeginRefreshing];
    //2、上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    
    //设置文字
    self.tableView.headerPullToRefreshText = @"马上为你刷新";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新";
    self.tableView.headerRefreshingText = @"正在为你刷新中";
    
    self.tableView.footerPullToRefreshText = @"马上为你加载";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载";
    self.tableView.footerRefreshingText = @"正在为你加载中";
    
}
- (void)headerRefresh
{
    [self checkNetworkstate];//首先检测是否有网络
    
    //模拟两秒后进行刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.6 *NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        //刷新页面
        [self.tableView reloadData];
        //结束刷新
        [self.tableView headerEndRefreshing];
    });
}
- (void)footerRefresh
{
    self.loadingCount ++;
    [self checkNetworkstate];//检测网络状态
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
    });
}

#pragma mark ------ 请求数据 ------
- (void)requestData
{
    NSString *newListURL = [NSString stringWithFormat:kPhoneListURL,self.loadingCount*20];
    //请求数据
    [[RequstHandle alloc]initWithURLString:newListURL paraString:nil metod:@"GET" delegate:self];
    
}

//获取数据
//请求成功
-(void)requestHandle:(RequstHandle *)requesthandle didSucceedWithData:(NSMutableData *)data
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *array = [dic valueForKey:kPhoneKey];
    if (array == nil) {
        //提示讯息
        [NSObject alterString:@"木有数据"];
    }else
    {
        //遍历字典
        for (NSDictionary *dict  in array) {
            ListModel *list = [[ListModel alloc]init];
            [list setValuesForKeysWithDictionary:dict];
            if (![dict valueForKey:@"photosetID"]) {
                if (list.imgextra) {
                    list.imgextra1 = [list.imgextra[0] valueForKey:@"imgsrc"];
                    list.imgextra2 = [list.imgextra[1] valueForKey:@"imgsrc"];
                }
                [self.dataArray addObject:list];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];//刷新页面
        });
    }
    
}
//请求失败
-(void)requestHandle:(RequstHandle *)requesthandle faiWithError:(NSError *)error
{
    [NSObject alterString:@"请求数据失败"];
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

#pragma mark ------ cell高度 ------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 202;
    }else
    {
        return 105;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *dataVC = [[DetailViewController alloc]init];
    ListModel *list = [_dataArray objectAtIndex:indexPath.row];
    dataVC.str = list.docid;
    [dataVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:dataVC animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ListModel *list = _dataArray[indexPath.row];
    _cell = [[BigTableViewCell alloc]init];
    
    if (indexPath.row == 0) {
        _cell.myTitle.text = list.title;
//        [_cell.myTitle setColor:[UIColor whiteColor] fromIndex:0 length:_cell.myTitle.text.length];
//        [_cell.myTitle setFont:[UIFont systemFontOfSize:18] fromIndex:0 length:_cell.myTitle.text.length];
        NSString *str = list.imgsrc;
        NSURL *url = [NSURL URLWithString:str];
        [_cell.bigImageView sd_setImageWithURL:url];
        
        return _cell;
    }
    else if ([list valueForKey:@"imgextra"] != nil)
    {
        static NSString *identifier = @"cell1";
        CellForThreeImage *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell1) {
            cell1 = [[CellForThreeImage alloc]initWithStyle:(UITableViewCellStyleValue2) reuseIdentifier:identifier];
        }
        cell1.myTitleForThree.text = list.title;
        NSURL *url1 = [NSURL URLWithString:list.imgextra1];
        NSURL *url2 = [NSURL URLWithString:list.imgextra2];
        NSString *str3 = list.imgsrc;
        NSURL *url3 = [NSURL URLWithString:str3];
        [cell1.myImageForThree1 sd_setImageWithURL:url1];
        [cell1.myImageForThree2 sd_setImageWithURL:url2];
        [cell1.myImageForThree3 sd_setImageWithURL:url3];
        
        return cell1;
    }else
    {
        static NSString *identifier1 = @"cell";
        CellForOneImage *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[CellForOneImage alloc]initWithStyle:(UITableViewCellStyleValue2) reuseIdentifier:identifier1];
        }
        cell.myTitleForOne.text = list.title;
        cell.SourceForOne.text = list.source;
        NSString *str = list.imgsrc;
        NSURL *url = [NSURL URLWithString:str];
        [cell.myImageForOne sd_setImageWithURL:url];
        
        return cell;
    }
}

@end
