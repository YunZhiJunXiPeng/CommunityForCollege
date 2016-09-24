//
//  HeroDetailsViewController.m
//  Community-for-college
//
//  Created by 卖女孩的小火柴 on 16/8/29.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "HeroDetailsViewController.h"
#import <UIImageView+WebCache.h>
#import "HeroModel.h"
#import "CalculateTool.h"
#import "HeroDetailsTableViewCell.h"
@interface HeroDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *heroDetailsTableView;

@property (nonatomic,strong)HeroModel *detailsModel;

@property (nonatomic,strong)NSMutableArray *heroDetailsDataArray;

@property (nonatomic,strong)UILabel *Alabel3;

@property (nonatomic,assign)CGFloat height;
@end

@implementation HeroDetailsViewController

- (NSMutableArray *)heroDetailsDataArray
{
    if (!_heroDetailsDataArray) {
        _heroDetailsDataArray = [NSMutableArray array];
    }
    return _heroDetailsDataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    //tableView代理以及初始化
    [self HeroDetailsTableView];
    
    [self reloadHeroDetails];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [self headerViewForTableView];
//    [self footerViewForTableView];
    
}
//tableView代理以及初始化
- (void)HeroDetailsTableView
{
    self.heroDetailsTableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.heroDetailsTableView.delegate = self;
    self.heroDetailsTableView.dataSource = self;
    //注册cell
    [self.heroDetailsTableView registerClass:[HeroDetailsTableViewCell class] forCellReuseIdentifier:@"heroCell"];
    self.heroDetailsTableView.backgroundColor = [UIColor clearColor];
    //增补视图
    UIView *aview = [[UIView alloc]initWithFrame:(CGRectMake(0, 0, 0, 0))];
    aview.backgroundColor = [UIColor brownColor];
    self.heroDetailsTableView.tableFooterView = aview;
    [self.view addSubview:self.heroDetailsTableView];
}
//tableView头部视图
- (void)headerViewForTableView
{
    
    //标题
    self.title = [NSString stringWithFormat:@"%@/%@",_heroDetailsModel.en_name,_heroDetailsModel.name];
    
    self.heroDetailsTableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -200, [UIScreen mainScreen].bounds.size.width, 200)];
    NSLog(@"🙆🙆🙆🙆🙆🙆🙆🙆%@",_heroDetailsModel.en_name);
    NSString *str1 = [NSString stringWithFormat:@"http://111.202.85.42/dlied1.qq.com/qqtalk/lolApp/images/hero_background/%@",_heroDetailsModel.en_name];
    str1 = [str1 stringByAppendingString:@"_Splash_0.jpg?mkey=57c266624e165a8e&f=1b58&c=0&p=.jpg"];
    imageView.backgroundColor = [UIColor whiteColor];
    [imageView sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:nil];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.tag = 101;
    
    [self.heroDetailsTableView addSubview:imageView];
    
    UIView *headerLabelView = [[UIView alloc]initWithFrame:(CGRectMake(0, -134, imageView.frame.size.width, imageView.frame.size.height / 2 + 44))];
    headerLabelView.alpha = 0.7;
//    headerLabelView.backgroundColor = [UIColor cyanColor];
    headerLabelView.tag = 102;
    [self.heroDetailsTableView insertSubview:headerLabelView aboveSubview:imageView];
    
    
    //别称
    UILabel *HLabel1 = [[UILabel alloc]initWithFrame:(CGRectMake(10, 5, 100, 20))];
    HLabel1.text = [NSString stringWithFormat:@"%@",_heroDetailsModel.nick];
    HLabel1.textColor = [UIColor whiteColor];
    [headerLabelView addSubview:HLabel1];
    
    //属性，位置
    UILabel *Hlabel2 = [[UILabel alloc]initWithFrame:(CGRectMake(10, CGRectGetMaxY(HLabel1.frame) + 10, 200, 20))];
    Hlabel2.textColor = [UIColor whiteColor];
    Hlabel2.font = [UIFont systemFontOfSize:14];
    if (_heroDetailsModel.tag3 == nil) {
        Hlabel2.text = [NSString stringWithFormat:@"%@   %@",_heroDetailsModel.tag1,_heroDetailsModel.tag2];
    }
    else
    {
        Hlabel2.text = [NSString stringWithFormat:@"%@   %@   %@",_heroDetailsModel.tag1,_heroDetailsModel.tag2,_heroDetailsModel.tag3];
    }
    [headerLabelView addSubview:Hlabel2];
    
    UILabel *Hlabel3 = [[UILabel alloc]initWithFrame:(CGRectMake(10, CGRectGetMaxY(Hlabel2.frame) + 10, 300, 30))];
    Hlabel3.text = [NSString stringWithFormat:@"攻:%@  法:%@  防:%@  操作:%@",_detailsModel.attack,_detailsModel.magic,_detailsModel.defense,_detailsModel.difficulty];
    Hlabel3.textColor = [UIColor whiteColor];
    [headerLabelView addSubview:Hlabel3];
    
}

//tableView脚部视图
/*
- (void)footerViewForTableView
{
    
    CGFloat height = [CalculateTool heightForLableText:_detailsModel.story ForTextSize:17];
    
    UIView *footView = [[UIView alloc]initWithFrame:(CGRectMake(0, -2, self.view.frame.size.width, height + 200))];
    footView.backgroundColor = [UIColor brownColor];
    self.heroDetailsTableView.tableFooterView = footView;
    
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:(CGRectMake(15, 22, 20, 20))];
    imageView.image = [UIImage imageNamed:@"6边形"];
    [footView addSubview:imageView];
    
    UILabel *Alabel1 = [[UILabel alloc]initWithFrame:(CGRectMake(CGRectGetMaxX(imageView.frame) + 5, CGRectGetMinY(imageView.frame), 200, 20))];
    Alabel1.text = @"背景故事";
    [footView addSubview:Alabel1];
    
//    UILabel *Alabel2 = [[UILabel alloc]initWithFrame:(CGRectMake(CGRectGetMaxX(imageView.frame) + 5, CGRectGetMaxY(imageView.frame) + 15, 300, 40))];
//    if ([_heroDetailsModel.tag3 isEqualToString:@""]) {
//        
//        Alabel2.text = [NSString stringWithFormat:@"%@/%@",_heroDetailsModel.tag1,_heroDetailsModel.tag2];
//    }else
//    {
//        Alabel2.text = [NSString stringWithFormat:@"%@/%@/%@",_heroDetailsModel.tag1,_heroDetailsModel.tag2,_heroDetailsModel.tag3];
//    }
//    Alabel2.text = [NSString stringWithFormat:@"%@",_heroDetailsModel.opponent_reason1];
//    [footView addSubview:Alabel2];
    
    
    NSLog(@"==============高度%f",height);
    _Alabel3 = [[UILabel alloc]initWithFrame:(CGRectMake(CGRectGetMaxX(imageView.frame) + 5,  45, 300, height + 100))];
    _Alabel3.backgroundColor = [UIColor cyanColor];
    _Alabel3.numberOfLines = 0;
    _Alabel3.font = [UIFont systemFontOfSize:15];
    _Alabel3.text = _detailsModel.story;
    
    [footView addSubview:_Alabel3];
    
    
}
 
 */

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    if (point.y < -200) {
        CGRect rect1 = [self.heroDetailsTableView viewWithTag:101].frame;
        rect1.origin.y = point.y;
        rect1.size.height = -point.y;
        [self.heroDetailsTableView viewWithTag:101].frame = rect1;
        
        
    }
    else if (point.y < -134)
    {
        CGRect rect2 = [self.heroDetailsTableView viewWithTag:102].frame;
        rect2.origin.y = 2 * point.y / 3 ;
        rect2.size.height = - point.y ;
        [self.heroDetailsTableView viewWithTag:102].frame = rect2;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (HeroDetailsTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HeroDetailsTableViewCell *cell = [self.heroDetailsTableView dequeueReusableCellWithIdentifier:@"heroCell"];
    
    _height = [CalculateTool heightForLableText:_detailsModel.story ForTextSize:20];
    NSLog(@"😂😂😂😂😂😂😂%f",_height);
    if (_height <= 410) {
        _height = 410;
    }
    cell.Alabel3.frame = CGRectMake(15, 60, self.view.frame.size.width - 30, _height);
    cell.Alabel3.numberOfLines = 0;
    cell.Alabel3.text = _detailsModel.story;
    NSLog(@"=========%@",_detailsModel.story);
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = NO;//取消选中cell
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _height + 100;
}
- (void)reloadHeroDetails
{
    NSString *heroStr = [NSString stringWithFormat:@"http://ossweb-img.qq.com/upload/qqtalk/lol_hero/hero_%@.js",_heroDetailsModel.id];
    NSURL *heroURL = [NSURL URLWithString:heroStr];
    NSURLSession *heroSession = [NSURLSession sharedSession];
    NSURLSessionTask *heroTask = [heroSession dataTaskWithURL:heroURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
            
                _detailsModel = [HeroModel new];
                [_detailsModel setValuesForKeysWithDictionary:dict];
                [self.heroDetailsDataArray addObject:_detailsModel];

            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                [self.heroDetailsTableView reloadData];
                
            });
            
            NSLog(@"---------=========%@",_detailsModel.story);
            
        }
    }];
    [heroTask resume];
}

@end
