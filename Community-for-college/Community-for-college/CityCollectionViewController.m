//
//  CityCollectionViewController.m
//  Community-for-college
//
//  Created by 夏夕空 on 16/8/17.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "CityCollectionViewController.h"
#import "TwoLevelModel.h"
#import "AllCityCollectionViewCell.h"
#import "CityDetailViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "Reachability.h"
#import "NSObject+alertView.h"

#define CITY_URL1 @"http://open.qyer.com/place/city/get_city_list?client_id=qyer_ios&client_secret=cd254439208ab658ddf9&count=20&countryid="
#define CITY_URL2 @"&page=1&track_app_channel=App%2520Store&track_app_version=7.0.1&track_device_info=iPhone7%2C2&track_deviceid=83903AA6-652F-4E34-ACFC-960F4C061376&track_os=ios%25209.3.3&v=1"

@interface CityCollectionViewController ()
@property (strong,nonatomic) NSMutableArray*dataArray;
@property (assign,nonatomic) int count;
@end

@implementation CityCollectionViewController

static NSString * const reuseIdentifier = @"Cell";



- (void)viewDidLoad {
    [super viewDidLoad];
    _count = 1;
    self.collectionView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:188.0/255.0 blue:227.0/255.0 alpha:1];
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    //    设置item大小
    flowLayout.itemSize = CGSizeMake((self.collectionView.bounds.size.width - 40)/2.1, (self.collectionView.bounds.size.width - 40)*0.5);
    //    设置行间距
    flowLayout.minimumLineSpacing = 10;
    //    设置列间距
    flowLayout.minimumInteritemSpacing = 10;
    //    设置滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //    设置每个分区的边缘位置(上左下右）
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    self.collectionView.collectionViewLayout = flowLayout;
     _dataArray = [NSMutableArray array];
    [self.collectionView registerClass:[AllCityCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self checkNetworkstate];
    [self setupRefresh];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 请求数据的方法
- (void)requestCity{
    
    NSString *str1 = [NSString stringWithFormat:@"&page=%d",_count];
//    NSLog(@"+++++++++++++++++%d",_count);
    NSString*str = [str1 stringByAppendingString:@"&track_app_channel=App%2520Store&track_app_version=7.0.1&track_device_info=iPhone7%2C2&track_deviceid=83903AA6-652F-4E34-ACFC-960F4C061376&track_os=ios%25209.3.3&v=1"];
    NSString*urlStr = [[CITY_URL1 stringByAppendingString:[NSString stringWithFormat:@"%ld",self.ID]] stringByAppendingString:str];
    NSURL*url = [NSURL URLWithString:urlStr];
    NSURLSession*session = [NSURLSession sharedSession];
    NSURLSessionTask*task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
        NSDictionary*dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        NSArray*array = [NSArray new];
        array = dict[@"data"];
       
            for (NSDictionary*dic in array) {
            TwoLevelModel*model = [TwoLevelModel new];
            [model setValuesForKeysWithDictionary:dic];
                
            [_dataArray addObject:model];
//                NSLog(@"%@",_dataArray);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        }
    }];
    [task resume];
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AllCityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CityDetailViewController*detail =  [CityDetailViewController new];
    TwoLevelModel*model = _dataArray[indexPath.row];
    detail.ID = model.id;
    [self showViewController:detail sender:nil];
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
        [self requestCity];
        
    }else if ([conn currentReachabilityStatus]!=NotReachable){
        [self requestCity];
    
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
    [self.collectionView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"collectionView"];
    
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
    _count ++;
    //1监测wifi状态
    Reachability *wifi=[Reachability reachabilityForLocalWiFi];
    //检测手机是否能上网（wifi／3G／2G）
    Reachability *conn=[Reachability reachabilityForInternetConnection];
    //判断网络状态
    if ([wifi currentReachabilityStatus]!=NotReachable) {
        [self requestCity];
        
    }else if ([conn currentReachabilityStatus]!=NotReachable){
        [self requestCity];
        
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




#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
