//
//  BookViewController.m
//  Community-for-college
//
//  Created by lanou3g on 16/8/17.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "BookViewController.h"
#import "BoyBoosTableViewController.h"
#import "GirlBooksTableViewController.h"
#import "HomepageViewController.h"
#import "Masonry.h"
#import "LeftSortsViewController.h"

#import "MJRefresh.h"//下拉刷新
#define KScrollViewWidth self.scrollView.bounds.size.width
#define KScrollViewHeight self.scrollView.bounds.size.height

@interface BookViewController ()<UIScrollViewDelegate>
/**  UIScrollView */
@property (weak,nonatomic) UIScrollView *scrollView;


@end

@implementation BookViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"十年少";
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
#pragma mark ------ 首页跳转抽屉 ------
    UIButton *lbtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    [lbtn setImage:[UIImage imageNamed:@"个人"] forState:UIControlStateNormal];
        lbtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [lbtn addTarget:self action:@selector(drawer) forControlEvents:UIControlEventTouchUpInside];
    [lbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:lbtn];
    
    //创建ScrollView
    [self setupScrollView];
    //添加子控制器
    [self setupChildViewControllers];
    //创建控件
    [self setUI];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:245.0/255 green:88.0/255 blue:135.0/255 alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    
 
}

//跳转抽屉
- (void)drawer
{
//    LeftSortsViewController *leftDrawer = [LeftSortsViewController new];
//    [self.navigationController pushViewController:leftDrawer animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupChildViewControllers{

    BoyBoosTableViewController *Boy = [[BoyBoosTableViewController alloc] init];

    [self addChildViewController:Boy];
    GirlBooksTableViewController *Girl = [[GirlBooksTableViewController alloc] init];
    [self addChildViewController:Girl];

}

-(void)setupScrollView{
    //不允许自动调整scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView =[[UIScrollView alloc] init];
    
    [self.view addSubview:scrollView];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
    
    self.scrollView = scrollView;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width  , self.view.frame.size.height);
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, 0);
}

- (void)setUI{


    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , 40)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];

    NSArray *segArr = @[@"男生分区",@"女生分区"];
    self.seg = [[UISegmentedControl alloc] initWithItems:segArr];
    
    _seg.frame = CGRectMake(10, 5, self.view.frame.size.width - 20, 30);
    [_seg addTarget:self action:@selector(onClick:) forControlEvents:(UIControlEventValueChanged)];
    
    //   文字选中之前的样子
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:15];
//    dic[NSForegroundColorAttributeName] = [UIColor blueColor];
    
    [_seg setTitleTextAttributes:dic forState:(UIControlStateNormal)];
    
    //    文字选中之后的样子
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor redColor];
    _seg.tintColor = [UIColor colorWithRed:247.0/255.0 green:133.0/255.0 blue:193.0/255.0 alpha:1];
    
    [_seg setTitleTextAttributes:dict forState:(UIControlStateHighlighted)];
    

    
    
//    self.navigationItem.titleView = _seg;
    [self.view addSubview:_seg];
    self.seg.selectedSegmentIndex = 0;
    if (self.seg.selectedSegmentIndex==0) {
        [self onClick:_seg];
    }
}


-(void)addChildVCView:(NSInteger)index{
    CGFloat offsetX =index * self.view.frame.size.width;
    
    UIViewController *childVc = self.childViewControllers[index];
    //如果加载直接返回
    if (childVc.isViewLoaded)return;
    
    childVc.view.frame = CGRectMake(offsetX, 40, KScrollViewWidth, KScrollViewHeight);
   
    
    [self.scrollView addSubview:childVc.view];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    self.seg.selectedSegmentIndex = scrollView.contentOffset.x/KScrollViewWidth+0.5;
    [self addChildVCView: self.seg.selectedSegmentIndex];
}



- (void)onClick:(UISegmentedControl *)segmentedControl{
    
    self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width * self.seg.selectedSegmentIndex, 0.0f);
    
    NSInteger index = self.scrollView.contentOffset.x/self.view.bounds.size.width;
    
    [self addChildVCView:index];
}



@end
