//
//  HeadlineTableViewController.m
//  Community-for-college
//
//  Created by 卖女孩的小火柴 on 16/8/15.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
#import "HeadlineTableViewController.h"
#import "DetailViewController.h"//详情页面
#import "CellForOneImage.h"//自定义cell
#import "CellForThreeImage.h"//自定义cell
#import "UIImageView+WebCache.h"//网络解析图片
#import "MJRefresh.h"//下拉刷新加载
#import "RequstHandle.h"//解析请求
#import "ListModel.h"//列表model
#import "HeaderOfNews.h"//url接口等
#import "CommonHandle.h"//公用的单例
#import "BigTableViewCell.h"
#import "AttributedLabel.h"
#import "Reachability.h"//网络状态
#import "NSObject+alertView.h"//提示alert
//#import "ListDataBase.h"


@interface HeadlineTableViewController ()<RequestHandleDelegat>

@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic)NSInteger loadingCount;
@property (nonatomic,retain)NSString *listURL;


@end

@implementation HeadlineTableViewController
- (NSMutableArray*)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
        [self requestData];
        
    }else if ([conn currentReachabilityStatus]!=NotReachable){
        [self requestData];
        
    }else
    {
        // 加载缓存数据
//        [self selectData];
        [NSObject alterString:@"木有网络"];
        
    }
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

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    
    //    [self checkNetworkstate];
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新
        [self.tableView reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });

    
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
        [self requestData];
        
    }else if ([conn currentReachabilityStatus]!=NotReachable){
        [self requestData];
        
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

#pragma mark - 数据处理

-(void)requestData
{
    
    NSString *newListURL = [NSString stringWithFormat:kHeadLineListURL,self.loadingCount * 20];
    
    // 请求数据
    [[RequstHandle alloc]initWithURLString:newListURL paraString:nil metod:@"GET" delegate:self];
}

//获取数据
-(void)requestHandle:(RequstHandle *)requesthandle didSucceedWithData:(NSMutableData *)data
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *array = [dic valueForKey:kHeadLineKey];
    if (array == nil) {
        //提示讯息
        [NSObject alterString:@"木有数据"];
    }else
    {
        //遍历字典
        for (NSDictionary *dic1 in array) {
            ListModel *list = [[ListModel alloc]init];
            [list setValuesForKeysWithDictionary:dic1];
            if (![dic1 valueForKey:@"photosetID"]) {
                if (list.imgextra) {
                    list.imgextra1 = [list.imgextra[0] valueForKey:@"imgsrc"];
                    list.imgextra2 = [list.imgextra[1] valueForKey:@"imgsrc"];
                }
                [self.dataArr addObject:list];
                // 放入缓存
//                [self insertData:list];
            }
            
        }
        
        [self.tableView reloadData];
        
    }
}
- (void)requestHandle:(RequstHandle *)requsetHandle failWithError:(NSError *)error
{
    NSLog(@"请求失败");
}

#pragma mark - 布局tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 202;
    }
    
    return 105;
}

//****************  push  *****************

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *meVC = [[DetailViewController alloc]init];
    ListModel *list = [_dataArr objectAtIndex:indexPath.row];
    meVC.str = list.docid;
//    meVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [meVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:meVC animated:YES];
}

//****************  布局Cell  *****************

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListModel *list = [_dataArr objectAtIndex:indexPath.row];
 
    if (indexPath.row == 0)
    {
        BigTableViewCell *cell = [BigTableViewCell new];
        cell.myTitle.text = list.title;
        
        NSString *str = list.imgsrc;
        NSURL *url = [NSURL URLWithString:str];
        [cell.bigImageView sd_setImageWithURL:url];
   
    return cell;
        
    }
    else
        if ([list valueForKey:@"imgextra"] != nil) {
            static NSString *identtifier = @"cell1";
            CellForThreeImage *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if (!cell1) {
                cell1 = [[CellForThreeImage alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identtifier];
            }
            cell1.myTitleForThree.text = list.title;
            NSURL *url1 = [NSURL URLWithString:list.imgextra1];
            NSURL *url2 = [NSURL URLWithString:list.imgextra2];
            NSString *str2 = list.imgsrc;
            NSURL *url3 = [NSURL URLWithString:str2];
            [cell1.myImageForThree1 sd_setImageWithURL:url1];
            [cell1.myImageForThree2 sd_setImageWithURL:url2];
            [cell1.myImageForThree3 sd_setImageWithURL:url3];
            
            return cell1;
        }
        else{
            static NSString *identtifier1 = @"cell2";
            CellForOneImage *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            if (!cell2) {
                cell2 = [[CellForOneImage alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identtifier1];
            }
            cell2.myTitleForOne.text =list.title;
            cell2.SourceForOne.text = list.source;
            NSString *str = list.imgsrc;
            NSURL *url = [NSURL URLWithString:str];
            [cell2.myImageForOne sd_setImageWithURL:url];
            
            
            return cell2;
            
        }
    
    
}


@end
