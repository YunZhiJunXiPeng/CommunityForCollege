//
//  TwoLevelViewController.m
//  Community-for-college
//
//  Created by 夏夕空 on 16/8/16.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "TwoLevelViewController.h"
#import "CarouselFingure.h"
#import "TwoLevelModel.h"
#import "CalculateTool.h"
#import <UIImageView+WebCache.h>
#import "HotCityCollectionViewCell.h"
#import "CountryDetailViewController.h"
#import "CityDetailViewController.h"
#import "CityCollectionViewController.h"
#import "FreeGoTableViewCell.h"
#import <Masonry.h>
#import "LoginAndRegister.h"
#import "NSObject+alertView.h"


#define LEVEL2_URL_1 @"http://open.qyer.com/qyer/footprint/country_detail?client_id=qyer_ios&client_secret=cd254439208ab658ddf9&count=20&country_id="
#define LEVEL2_URL_2 @"&page=1&track_app_channel=App%2520Store&track_app_version=7.0.1&track_device_info=iPhone7%2C2&track_deviceid=83903AA6-652F-4E34-ACFC-960F4C061376&track_os=ios%25209.3.3&v=1"




@interface TwoLevelViewController ()<CarouselFingureDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
// 轮播图数组/Users/zhaoce/Desktop/Community-for-college/Community-for-college/Community-for-college/TwoLevelViewController.m
@property (strong,nonatomic) NSArray*imageArray;
//  城市信息的数据源
@property (strong,nonatomic) NSMutableArray*CityArray;
// 显示城市的collectionView
@property (strong,nonatomic) UICollectionView*collectionView;
//  封装的轮播视图
@property (strong,nonatomic) CarouselFingure*ImageShow;
// 整个页面的滚动视图
@property (strong,nonatomic) UIScrollView*scrollView;

@property (strong,nonatomic) UILabel*CName;
@property (strong,nonatomic) UILabel*EName;

// 查看国家实用信息的view
@property (strong,nonatomic) UIView*panView;
@property (strong,nonatomic) UILabel*entryCont;
// 展开的button
@property (strong,nonatomic) UIButton*showButton;
// 热门城市label
@property (strong,nonatomic) UILabel*CollectionTitle;
// 跳转所有城市页面的button
@property (strong,nonatomic) UIButton*AllCity;

//  显示超值自由行的TableView
@property (strong,nonatomic) UITableView*tableView;
@property (strong,nonatomic) NSArray*FreegoArray;

//  下方收藏的view
@property (strong,nonatomic) UIView*hideView;
@end

@implementation TwoLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CarouselFingure*ImageShow = [[CarouselFingure alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0.4 * self.view.frame.size.height)];
    _ImageShow = ImageShow;
    ImageShow.delegate = self;
    [self createScrollView];
    
    [self setSubViews];

     [self.scrollView addSubview:ImageShow];

    [self createCollectionView];
     [self setSubViews];
    [self requestCountry];
   
    
}

- (NSArray *)FreegoArray{
    if (_FreegoArray == nil) {
        _FreegoArray = [NSArray array];
    }
    return _FreegoArray;
}


- (void)createScrollView{
    UIScrollView*scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.delegate = self;
//    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*2);
    scrollView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:188.0/255.0 blue:227.0/255.0 alpha:1];
    
    _scrollView = scrollView;
    [self.view addSubview:_scrollView];
}




- (NSArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [NSArray array];
    }
    return _imageArray;
}




- (void)requestCountry{
    NSString*urlStr1 = [LEVEL2_URL_1 stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)self.ID]];
    NSURL*url = [NSURL URLWithString:[urlStr1 stringByAppendingString:LEVEL2_URL_2]];
//    NSLog(@"%@",url);
    NSURLSession*session = [NSURLSession sharedSession];
    NSURLSessionTask*task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
        NSDictionary*dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        NSDictionary*dic = dict[@"data"];
            NSArray*photoArray = [NSArray array];
            if (dic[@"photos"]) {
                photoArray = dic[@"photos"];
            }
        TwoLevelModel*model = [TwoLevelModel new];
            model.New_discount = dic[@"new_discount"];
        [model setValuesForKeysWithDictionary:dic];
             _CityArray = [NSMutableArray array];
            for (NSDictionary*hotCity in model.hot_city) {
                TwoLevelModel*citymodel = [TwoLevelModel new];
                [citymodel setValuesForKeysWithDictionary:hotCity];
                [_CityArray addObject:citymodel];
//                NSLog(@"%@",_CityArray);
            }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.ImageShow.imagesArray = photoArray;
            [self.collectionView reloadData];
            [self setModel:model];
            [self.tableView reloadData];
        });
    }
}];
    [task resume];
}







//  创建CollectionView
- (void)createCollectionView{
    
    UIView*panview1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.ImageShow.frame), self.view.frame.size.width, 0.17*self.view.frame.size.height)];
    panview1.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [panview1 addGestureRecognizer:tapGesture];
    _panView = panview1;
    [self.scrollView addSubview:panview1];
    
    //    设置布局对象
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    //    设置item大小
    flowLayout.itemSize = CGSizeMake((self.view.bounds.size.width - 40)/2.2, (self.view.bounds.size.width - 40)*0.27);
    //    设置行间距
    flowLayout.minimumLineSpacing = self.view.frame.size.width/67;
    //    设置列间距
    flowLayout.minimumInteritemSpacing = self.view.frame.size.width/67;
    //    设置滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //    设置每个分区的边缘位置(上左下右）
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    
    //    设置增补视图的size
    flowLayout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 45);
    flowLayout.footerReferenceSize = CGSizeMake(self.view.bounds.size.width, 30);
    
    //    创建UICollectionView
    UICollectionView*collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(panview1.frame) + 15 , self.view.bounds.size.width - 20, self.view.frame.size.height/2.5) collectionViewLayout:flowLayout];
    
    //    设置背景颜色
    collectionView.backgroundColor = [UIColor whiteColor];
    //    设置代理
    collectionView.delegate = self;
    //    设置数据源
    collectionView.dataSource = self;
//    设置CollectionView不可滚动
    collectionView.scrollEnabled = NO;
//    collectionView.userInteractionEnabled = NO;
    //    注册cell
    [collectionView registerClass:[HotCityCollectionViewCell class] forCellWithReuseIdentifier:@"collection"];
    _collectionView = collectionView;
    
//    添加子控件
    [self.scrollView addSubview:collectionView];
    
  
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _CityArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HotCityCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collection" forIndexPath:indexPath];
    cell.model = _CityArray[indexPath.row];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CityDetailViewController*detail =  [CityDetailViewController new];
    TwoLevelModel*model = _CityArray[indexPath.row];
    detail.ID = model.id;
    [self showViewController:detail sender:nil];
}



//  布局方法
- (void)setSubViews{
    UILabel*CName = [[UILabel alloc]initWithFrame:CGRectMake(15, self.ImageShow.frame.size.height/2 + 10, 150, 30)];
    CName.textColor = [UIColor whiteColor];
    CName.font = [UIFont systemFontOfSize:22];
//    CName.backgroundColor = [UIColor orangeColor];
    self.CName = CName;
    
    UILabel*EName = [[UILabel alloc]initWithFrame:CGRectMake(15, self.ImageShow.frame.size.height/2 + 50, 150, 20)];
    EName.textColor = [UIColor whiteColor];
    EName.font = [UIFont systemFontOfSize:14];
    self.EName = EName;

    

    UILabel*entryCont = [[UILabel alloc]initWithFrame:CGRectMake(10, self.ImageShow.frame.size.height + 15, self.view.frame.size.width - 20, 50)];
    
    entryCont.font = [UIFont systemFontOfSize:14];
    entryCont.textColor = [UIColor grayColor];
    entryCont.numberOfLines = 0;
    entryCont.backgroundColor = [UIColor whiteColor];
    _entryCont = entryCont;
    
    UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 120, CGRectGetMaxY(_entryCont.frame) + 5, 120, 20)];
    label.textColor = [UIColor colorWithRed:1.0 green:113 / 255.0 blue:180 / 255.0 alpha:1.0] ;
    label.font  = [UIFont systemFontOfSize:15];
    label.text = @"国家实用信息";
    
    
    UILabel*CollectionTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 30)];
    CollectionTitle.textColor = [UIColor blackColor];
    CollectionTitle.font = [UIFont systemFontOfSize:15];
    CollectionTitle.text = @"热门城市";
    _CollectionTitle = CollectionTitle;
   
    UIButton*AllCity = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100, 10, 70, 30)];
    [AllCity setTitle:@"查看全部" forState:(UIControlStateNormal)];
    [AllCity addTarget:self action:@selector(ShowAllCity:) forControlEvents:(UIControlEventTouchUpInside)];
    AllCity.titleLabel.font = [UIFont systemFontOfSize:15];
    [AllCity setTitleColor: [UIColor colorWithRed:1.0 green:113 / 255.0 blue:180 / 255.0 alpha:1.0] forState:(UIControlStateNormal)];
    _AllCity = AllCity;
    [self.collectionView addSubview:_CollectionTitle];
    [self.collectionView addSubview:_AllCity];
    [self.scrollView addSubview:label];
    [self.scrollView addSubview:CName];
    [self.scrollView addSubview:EName];
    [self.scrollView addSubview:entryCont];
  
//    布局tableView
    UITableView*tabView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tabView.delegate = self;
    tabView.dataSource = self;
    _tableView = tabView;
    tabView.scrollEnabled = NO;
    tabView.backgroundColor = [UIColor clearColor];
    [tabView registerClass:[FreeGoTableViewCell class] forCellReuseIdentifier:@"FreeGo"];
    [self.scrollView addSubview:tabView];
    
    UIView*hideView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 99, self.view.frame.size.width, 35)];
    hideView.backgroundColor =  [UIColor colorWithRed:1.0 green:113 / 255.0 blue:180 / 255.0 alpha:1.0] ;
    _hideView = hideView;
    [self addViewInHideView];
    [self.view insertSubview:hideView aboveSubview:self.scrollView];
    
    
}


//  最下边固定的view
- (void)addViewInHideView{
    UIView*heartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, self.view.frame.size.width*0.4-0.5 , 35)];
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CollectionTap:)];
    [heartView addGestureRecognizer:tap];
    heartView.backgroundColor = [UIColor whiteColor];
    UIImageView*image1 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 8, 19, 19)];
    image1.image = [UIImage imageNamed:@"空心心"];
    [heartView addSubview:image1];
    UILabel*label1 = [[UILabel alloc]initWithFrame:CGRectMake(45, 5, self.view.frame.size.width*0.4 - 56, 25)];
    label1.text = @"添加到我的想去";
    label1.font = [UIFont systemFontOfSize:13];
    label1.textColor = [UIColor grayColor];
    label1.textAlignment = NSTextAlignmentCenter;
    [heartView addSubview:label1];
    
    UIView*shareView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.4, 0.5, self.view.frame.size.width*0.3, 35)];
    shareView.backgroundColor = [UIColor whiteColor];
    UIImageView*shareImage = [[UIImageView alloc]initWithFrame:CGRectMake(25, 8, 19, 19)];
    shareImage.image = [UIImage imageNamed:@"Share"];
    [shareView addSubview:shareImage];
    UILabel*label2 = [[UILabel alloc]initWithFrame:CGRectMake(45, 5, self.view.frame.size.width*0.3 - 56, 25)];
    label2.textColor = [UIColor grayColor];
    label2.text = @"分享";
    label2.font = [UIFont systemFontOfSize:13];
    label2.textAlignment = NSTextAlignmentCenter;
    [shareView addSubview:label2];
    
    UIView*partner = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.7 , 0.5, self.view.frame.size.width*0.3, 35)];
    partner.backgroundColor = [UIColor whiteColor];
    UIImageView*partnerImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 25, 25)];
    partnerImage.image = [UIImage imageNamed:@"结伴"];
    [partner addSubview:partnerImage];
    UILabel*label3 = [[UILabel alloc]initWithFrame:CGRectMake(45, 5, self.view.frame.size.width*0.3 - 56, 25)];
    label3.textColor = [UIColor grayColor];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.text = @"结伴而行";
    label3.font = [UIFont systemFontOfSize:13];
    [partner addSubview:label3];
    
    [_hideView addSubview:shareView];
    [_hideView addSubview:heartView];
    [_hideView addSubview:partner];
}


//  收藏的点击手势
- (void)CollectionTap:(UIGestureRecognizer*)sender{
    NSUserDefaults*user = [NSUserDefaults standardUserDefaults];
    NSString*name = [user objectForKey:@"name"];
    if (!name) {
        LoginAndRegister*login = [[LoginAndRegister alloc]initWithNibName:@"LoginAndRegister" bundle:[NSBundle mainBundle]];
        UINavigationController*nav = [[UINavigationController alloc]initWithRootViewController:login];
        [self showViewController:nav sender:nil];
    }else{
        [NSObject alterString:@"收藏成功了"];
    }
}



//   在视图将要显示的时候判断ScrollView的contentsize 如果高度为零说明没有设置contentsize的大小
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.scrollView.contentSize.height == 0) {
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,CGRectGetMaxY(self.collectionView.frame) + 120);
    }
}

//  tableView 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_FreegoArray.count > 0) {
        self.tableView.frame = CGRectMake(10, CGRectGetMaxY(self.collectionView.frame) + 15, self.view.frame.size.width - 20,115*_FreegoArray.count + 70 );
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,CGRectGetMaxY(self.tableView.frame));
    }
    return _FreegoArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FreeGoTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"FreeGo" ];
//    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary*dict = _FreegoArray[indexPath.row];
    cell.title.text = dict[@"title"];
    [cell.Image sd_setImageWithURL:[NSURL URLWithString:dict[@"photo"]]];
    NSArray*array = [dict[@"price"] componentsSeparatedByString:@"<"];
    cell.price1.text = [array[1] componentsSeparatedByString:@">"][1];
    cell.price2.text = [array[2] componentsSeparatedByString:@">"][1];
    cell.priceoff.text = dict[@"priceoff"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 20, 0)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 100, 20)];
    label.text = @"超值自由行";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor blackColor];
    [headerView addSubview:label];
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}


- (void)tapGesture:(UIGestureRecognizer*)gesture{
    CountryDetailViewController*detail = [CountryDetailViewController new];
    detail.ID = self.ID;
    [self.navigationController pushViewController:detail animated:YES];
}


//  点击显示所有城市的触发事件
- (void)ShowAllCity:(UIButton*)sender{
       UICollectionViewLayout*layout = [UICollectionViewLayout new];
    CityCollectionViewController*allCity = [[CityCollectionViewController alloc]initWithCollectionViewLayout:layout];
    allCity.ID = self.ID;
    [self showViewController:allCity sender:nil];
}

//  重写的set方法
- (void)setModel:(TwoLevelModel *)model{
    if (_model != model) {
        _model = nil;
        _model = model;
        self.navigationItem.title  = [NSString stringWithFormat:@"%@(%@)",_model.cnname,_model.enname];
        self.CName.text = _model.cnname;
//        NSLog(@"%@",self.CName.text);
        self.EName.text = _model.enname;
        self.entryCont.text = _model.entryCont;
        self.FreegoArray = _model.New_discount;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}











/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
