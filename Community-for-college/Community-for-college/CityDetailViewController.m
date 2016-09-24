//
//  CityDetailViewController.m
//  Community-for-college
//
//  Created by 夏夕空 on 16/8/17.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "CityDetailViewController.h"
#import "CarouselFingure.h"
#import "FunctionCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import "NotMissTableViewCell.h"
#import "NotMissViewController.h"
#import "LoginAndRegister.h"


@interface CityDetailViewController ()<CarouselFingureDelegate,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) CarouselFingure *ImageShow;
@property (strong,nonatomic) UIScrollView*scrollView;

@property (strong,nonatomic) NSArray*ImageShowArray;

@property (strong,nonatomic) NSArray*icon_listArray;

@property (strong,nonatomic) UILabel*CName;
@property (strong,nonatomic) UILabel*EName;
@property (strong,nonatomic) UILabel*weather;
@property (strong,nonatomic) UILabel*temperature;
@property (strong,nonatomic) UICollectionView*functionCollection;

@property (strong,nonatomic) UIImageView*mapImage;
@property (strong,nonatomic) UILabel*mapLabel;

@property (strong,nonatomic) UILabel*SCLabel;
@property (strong,nonatomic) UITableView*tableView;
@property (strong,nonatomic) NSArray*not_miss;
@end

#define DetailCityURL1 @"http://open.qyer.com/qyer/place/city_index?city_id="
#define DetailCityURL2 @"&client_id=qyer_ios&client_secret=cd254439208ab658ddf9&count=20&page=1&track_app_channel=App%2520Store&track_app_version=7.0.1&track_device_info=iPhone7%2C2&track_deviceid=83903AA6-652F-4E34-ACFC-960F4C061376&track_os=ios%25209.3.3&v=1"

@implementation CityDetailViewController

static NSString *indetifier  = @"function_cell" ;

- (NSArray *)icon_listArray{
    if (!_icon_listArray) {
        _icon_listArray = [NSArray array];
    }
    return _icon_listArray;
}

- (NSArray *)ImageShowArray{
    if (!_ImageShowArray) {
        _ImageShowArray = [NSArray array];
    }
    return _ImageShowArray;
}

- (NSArray *)not_miss{
    if (!_not_miss) {
        _not_miss = [NSArray array];
    }
    return _not_miss;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:188.0/255.0 blue:227.0/255.0 alpha:1];
    CarouselFingure*ImageShow = [[CarouselFingure alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 240)];
    _ImageShow = ImageShow;
    ImageShow.delegate  = self;
    [self createScrollView];
    [self.scrollView addSubview:_ImageShow];
    [self setSubviews];
    [self RequsetData];
   
 
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (void)createScrollView{
    UIScrollView*scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    
    scrollView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:188.0/255.0 blue:227.0/255.0 alpha:1];
    
    _scrollView = scrollView;
    [self.view addSubview:_scrollView];
}


// 添加子视图
- (void)setSubviews{
    UILabel*CName = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 100, 30)];
    CName.center = CGPointMake(self.ImageShow.frame.size.width/2, CGRectGetMidY(self.ImageShow.frame));
    CName.textColor = [UIColor whiteColor];
    CName.textAlignment = NSTextAlignmentCenter;
    CName.font = [UIFont systemFontOfSize:25];
    _CName = CName;
    [self.scrollView addSubview:CName];
    
    UILabel*EName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    EName.textAlignment = NSTextAlignmentCenter;
    EName.center = CGPointMake(self.ImageShow.frame.size.width/2, self.ImageShow.frame.size.height/2 + 25);
    EName.textColor = [UIColor whiteColor];
    EName.font = [UIFont systemFontOfSize:22];
    _EName = EName;
    [self.scrollView addSubview:EName];
    
    UILabel*weather = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.ImageShow.frame) - 50, 60, 30)];
    weather.font = [UIFont systemFontOfSize:14];
    weather.textColor = [UIColor whiteColor];
    _weather = weather;
    [self.scrollView addSubview:weather];
    
    UILabel*temperature = [[UILabel alloc]initWithFrame: CGRectMake(60, self.weather.frame.origin.y, 150, 30)];
    temperature.font = [UIFont systemFontOfSize:14];
    temperature.textColor = [UIColor whiteColor];
    _temperature = temperature;
    [self.scrollView addSubview:temperature];
    
    UICollectionViewFlowLayout*layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 5;
//    layout.minimumInteritemSpacing = 5;
    layout.itemSize = CGSizeMake((self.view.frame.size.width - 50)/5, 65);
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView*collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.ImageShow.frame) + 15, self.view.frame.size.width, 170)collectionViewLayout:layout];
    collection.backgroundColor = [UIColor whiteColor];
    _functionCollection = collection;
    collection.delegate = self;
    collection.dataSource = self;
    collection.pagingEnabled = YES;
    [collection registerClass:[FunctionCollectionViewCell class] forCellWithReuseIdentifier:indetifier];
    [self.scrollView addSubview:collection];
    
    UIImageView*mapImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.functionCollection.frame) + 10, self.view.frame.size.width, 140)];
    _mapImage = mapImage;
    [self.scrollView addSubview:mapImage];
    UILabel*mapLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 35)];
    mapLabel.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
    mapLabel.textColor = [UIColor colorWithRed:1.0 green:113 / 255.0 blue:180 / 255.0 alpha:1.0];
    mapLabel.layer.cornerRadius = 20;
    mapLabel.layer.masksToBounds = YES;
    mapLabel.textAlignment = NSTextAlignmentCenter;
    mapLabel.center = CGPointMake(mapImage.frame.size.width/2, mapImage.frame.size.height/2);
    _mapLabel = mapLabel;
    [mapImage addSubview:mapLabel];
    
//    跳转登录view
    UIView*SCView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(mapImage.frame) + 10, self.view.frame.size.width, 50)];
    SCView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:SCView];
    UILabel*SCLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 10,self.view.frame.size.width - 60 , SCView.frame.size.height - 20)];
    SCLabel.textColor = [UIColor colorWithRed:1.0 green:113 / 255.0 blue:180 / 255.0 alpha:1.0];
    SCLabel.font = [UIFont systemFontOfSize:16];
    _SCLabel = SCLabel;
    UITapGestureRecognizer*gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Login:)];
    [SCView addGestureRecognizer:gesture];
    [SCView addSubview:SCLabel];
    
    UIImageView*heart = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
    heart.image = [UIImage imageNamed:@"心"];
    [SCView addSubview:heart];
    
    UITableView*tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(SCView.frame) + 10, self.view.frame.size.width,([UIScreen mainScreen].bounds.size.height) + 160) style:(UITableViewStylePlain)];
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    [tableView registerClass:[NotMissTableViewCell class] forCellReuseIdentifier:@"notmiss_id"];
    [self.scrollView addSubview:tableView];
    
    
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(self.tableView.frame) + 100);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _not_miss.count;
}

//  跳入登录界面
- (void)Login:(UIGestureRecognizer*)sender{
    LoginAndRegister*login = [[LoginAndRegister alloc]initWithNibName:@"LoginAndRegister" bundle:[NSBundle mainBundle]];
    UINavigationController*nav = [[UINavigationController alloc]initWithRootViewController:login];
    [self showViewController:nav sender:nil];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NotMissTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"notmiss_id" ];
    NSDictionary*dic = _not_miss[indexPath.row];
    [cell.ImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"pic_url"]]];
    cell.descLabel.text = dic[@"desc"];
    cell.Namelabel.text = dic[@"name"];
    cell.selectionStyle = NO;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NotMissViewController*NotMiss = [NotMissViewController new];
    NSString*link = _not_miss[indexPath.row][@"link_url"];
    NotMiss.LinkUrl = link;
    [self showViewController:NotMiss sender:nil];
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ([UIScreen mainScreen].bounds.size.height + 100)/3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel*nameLabel = [[UILabel alloc]init];
    nameLabel.textColor = [UIColor colorWithRed:1.0 green:113 / 255.0 blue:180 / 255.0 alpha:1.0];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:18];
    nameLabel.text = @"不可错过";
    return nameLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    NSLog(@"%ld", _icon_listArray.count);
    return _icon_listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FunctionCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:indetifier forIndexPath:indexPath];
    NSDictionary*dic = _icon_listArray[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"icon_pic"]]];
    cell.label.text = dic[@"icon"];
    return cell;
}



// 请求数据
- (void)RequsetData{
    NSString*str = [[DetailCityURL1 stringByAppendingString:self.ID] stringByAppendingString:DetailCityURL2];
    NSLog(@"%@",str);
    NSURL*url = [NSURL URLWithString:str];
    NSURLSession*session = [NSURLSession sharedSession];
    NSURLSessionTask*task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {

        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        NSDictionary*dict = dic[@"data"];
        ThreeLevelModel*model  = [ThreeLevelModel new];
        [model setValuesForKeysWithDictionary:dict];
        
       dispatch_async(dispatch_get_main_queue(), ^{
//            回主线程调用set方法
           [self setModel:model];
           [self.functionCollection reloadData];
           [self.tableView reloadData];
       });
        }
    }];
    [task resume];
}

// 重写的setter方法
- (void)setModel:(ThreeLevelModel *)model{
    
    _ImageShow.imagesArray = model.city_pic;
    _CName.text = model.cnname;
    _EName.text = model.enname;
    if (![model.weather[@"info"] isEqualToString:@""]) {
        _weather.text = model.weather[@"info"];
//        NSLog(@"%@",_weather.text);
        _temperature.text = [model.weather[@"low_temp"] stringByAppendingString:[NSString stringWithFormat:@" ~ %@",model.weather[@"high_temp"]]];
    }
    _icon_listArray = model.icon_list;
    
    [_mapImage sd_setImageWithURL:[NSURL URLWithString:model.city_map]];
//    NSLog(@"%@",_icon_listArray);
    _mapLabel.text = [NSString stringWithFormat:@"%@地图",model.cnname];
    _SCLabel.text = [NSString stringWithFormat:@"登陆查看收藏的%@目的地",model.cnname];
//     如果请求到的数据 这一数组为空 给它赋死值 显示
    if (model.not_miss.count == 0) {
        _not_miss = @[@{@"pic_url":@"http://abc.2008php.com/2015_Website_appreciate/2015-04-16/20150416222014.jpg",@"desc":@"你会是想到了那些在路上的回忆，还是想到了那个未曾出发的自己？",@"name":@"当另一个契机突如其来"},@{@"pic_url":@"http://www.3dkezhan.com/uploadfiles/uploadfiles/image/2014/03-13/20140313170512_13238.jpg",@"desc":@"但我宁愿成为那远方的一部分，而不是隔着纸张和荧幕漠然地遥望它们。赶路狂奔过的陌生街道，足以忘却疲惫的登高美景，难吃的要死的当地食物，帮助过自己的陌生人。",@"name":@"或许舟车劳顿，或许颠沛流离"},@{@"pic_url":@"http://www.3dkezhan.com/uploadfiles/uploadfiles/image/2014/03-13/20140313170512_77653.jpg",@"desc":@"在路上听到的一首歌……或者你曾驱车驶向荒野，抬头仰望星空，与奇装异服的当地人为伍，看到鲸的尾巴破浪而出。在雪中瑟瑟发抖，在夏日大汗涔涔，坐直升机飞往峡谷深处，也从五千米高空跳伞而下。",@"name":@"抬头仰望星空，与奇装异服的当地人为伍"}];
//        self.tableView.frame = CGRectZero;

    }else{
      _not_miss = model.not_miss;
    }
}






@end
