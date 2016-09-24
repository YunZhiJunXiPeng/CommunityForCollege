//
//  GameCollectionView.m
//  Community-for-college
//
//  Created by 卖女孩的小火柴 on 16/8/26.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "GameCollectionView.h"
#import "GameCollectionViewCell.h"
#import "GameModel.h"
#import "MJRefresh.h"//下拉刷新加载
#import "Reachability.h"//网络状态
#import "NSObject+alertView.h"//提示alert
@interface GameCollectionView ()


@property (nonatomic,strong)GameModel *model;
@property (nonatomic,strong)UICollectionView *collectionView;

@end

@implementation GameCollectionView

- (NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
//        _dataArray = [NSMutableArray array];
        //注册cell
        [self.collectionView registerClass:[GameCollectionViewCell class] forCellWithReuseIdentifier:@"gameCell"];
        
        [self checkNetworkstate];
        [self setupRefresh];
    }
    return self;
}

//  返回顶部
- (void)loopingAlignment{
    [self.collectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

//布局，已经写在总控制器了
- (void)addCollectionView
{
    //布局
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.itemSize = CGSizeMake(self.frame.size.width - 30 / 3, (self.frame.size.width - 40) * 0.8);
    //设置行间距
    flowLayout.minimumLineSpacing = 16;
    //设置列间距
    flowLayout.minimumInteritemSpacing = 10;
    //滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每隔分区边缘位置（大小）
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    //设置增补视图的size
//    flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, self.frame.size.height *270 / 667);
//    flowLayout.footerReferenceSize = CGSizeMake(self.bounds.size.width, 30);
    
    //创建uicollectionView
    self.collectionView = [[UICollectionView alloc]initWithFrame:(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 100)) collectionViewLayout:flowLayout];
    //禁止弹跳
    self.collectionView.bounces = NO;
    //设置背景颜色
    self.collectionView.backgroundColor = [UIColor colorWithHue:0.89 saturation:0.89 brightness:0.89 alpha:1.0];

    
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
        [self jsonForData];
        
    }else if ([conn currentReachabilityStatus]!=NotReachable){
        [self jsonForData];
        
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
    [self.collectionView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"gameCollection"];
    
    //********************* 自动刷新(一进入程序就下拉刷新)
    [self.collectionView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.collectionView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.collectionView.headerPullToRefreshText = @"马上为你刷新";
    self.collectionView.headerReleaseToRefreshText = @"松开马上刷新";
    self.collectionView.headerRefreshingText = @"正在为你刷新中";
    
    self.collectionView.footerPullToRefreshText = @"马上为你加载";
    self.collectionView.footerReleaseToRefreshText = @"松开马上加载";
    self.collectionView.footerRefreshingText = @"正在为你加载中";
    
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    
    //    [self checkNetworkstate];
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新
        [self.collectionView reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.collectionView headerEndRefreshing];
    });
    
    
}

- (void)footerRereshing
{
    
    //1监测wifi状态
    Reachability *wifi=[Reachability reachabilityForLocalWiFi];
    //检测手机是否能上网（wifi／3G／2G）
    Reachability *conn=[Reachability reachabilityForInternetConnection];
    //判断网络状态
    if ([wifi currentReachabilityStatus]!=NotReachable) {
        [self jsonForData];
        
    }else if ([conn currentReachabilityStatus]!=NotReachable){
        [self jsonForData];
        
    }else
    {
        [NSObject alterString:@"当前木有网络🙆🙆"];
    }
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.collectionView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.collectionView footerEndRefreshing];
    });
}


- (void)jsonForData
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"video" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *array = dict[@"array"];
    for (NSDictionary *dic in array) {
        _model = [GameModel new];
        [_model setValuesForKeysWithDictionary:dic];
        [self.dataArray addObject:_model];
    }
    
    NSLog(@"=============%@",_model.title);
    NSLog(@"-------------%ld",_dataArray.count);
    [self reloadData];
}

@end
