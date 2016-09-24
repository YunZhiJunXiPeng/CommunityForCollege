//
//  CountryDetailViewController.m
//  Community-for-college
//
//  Created by 夏夕空 on 16/8/17.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "CountryDetailViewController.h"
/*
 http://open.qyer.com/qyer/place/country_useful_info?client_id=qyer_ios&client_secret=cd254439208ab658ddf9&count=20&country_id=215&page=1&track_app_channel=App%2520Store&track_app_version=7.0.1&track_device_info=iPhone%25205s&track_deviceid=86AA7EB2-6813-43BB-9E1D-6A4435F2E54D&track_os=ios%25209.2.1&v=1
 */
#import "CalculateTool.h"



@interface CountryDetailViewController ()<UIScrollViewDelegate>
@property (strong,nonatomic) UIScrollView*scrollView;
//@property (assign,nonatomic) NSInteger count;
@property (strong,nonatomic) UIScrollView*headerScroll;
@property (strong,nonatomic) UIView*specialView;
@end

@implementation CountryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    创建用作控制的小滚动视图
    UIScrollView*headerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
    headerView.backgroundColor =  [UIColor colorWithRed:255.0/255.0 green:150.0/255.0 blue:200.0/255.0 alpha:1];
    _headerScroll = headerView;
    headerView.delegate = self;
    _headerScroll.showsVerticalScrollIndicator = NO;
    _headerScroll.showsHorizontalScrollIndicator = NO;
    _headerScroll.bounces = NO;
    [self.view addSubview:_headerScroll];
//    self.view.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:188.0/255.0 blue:227.0/255.0 alpha:1];
    
//     创建放置多个webview的大滚动视图
    UIScrollView*scrollView =  [[UIScrollView alloc]initWithFrame:CGRectMake(0, 35, self.view.frame.size.width, self.view.frame.size.height - 35)];
    _scrollView = scrollView;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:188.0/255.0 blue:227.0/255.0 alpha:1];
    [self.view addSubview:scrollView];
    [self requestData];
    
}

// 请求数据方法
- (void)requestData{
    NSString*str1 = @"http://open.qyer.com/qyer/place/country_useful_info?client_id=qyer_ios&client_secret=cd254439208ab658ddf9&count=20&country_id=";
    NSString*str2 = @"&page=1&track_app_channel=App%2520Store&track_app_version=7.0.1&track_device_info=iPhone%25205s&track_deviceid=86AA7EB2-6813-43BB-9E1D-6A4435F2E54D&track_os=ios%25209.2.1&v=1";
    NSString*urlStr = [str1 stringByAppendingString:[NSString stringWithFormat:@"%ld%@",self.ID,str2]];
    NSURL*url = [NSURL URLWithString:urlStr];
    NSURLSession*session = [NSURLSession sharedSession];
    NSURLSessionTask*task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        NSArray*array = dic[@"data"];
        NSMutableArray*titleArray = [NSMutableArray array];
        dispatch_async(dispatch_get_main_queue(), ^{
             NSInteger count = 0;
            for (NSDictionary*dict in array) {
                NSString*title = dict[@"title"];
                NSString*appview_url = dict[@"appview_url"];
//                根据元素个数循调用创建webView方法
                [self createWebViewWithCount:count Url:appview_url];
                [titleArray addObject:title];
                count ++;
            }
//            调用循环创建button的方法
            [self createButtonWithCount:count Titles:titleArray];
            [self setScrollViewContentSize:count];
        });
        }
    }];
    [task resume];
}




//  创建webView方法
- (void)createWebViewWithCount:(NSInteger)count Url:(NSString*)url{
   
    UIWebView*webView = [[UIWebView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*count,0, self.view.frame.size.width,  self.view.frame.size.height - 35)];
//    NSLog(@"%@",url);
    NSURLRequest*request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [webView loadRequest:request];
    [(UIScrollView *)[[webView subviews] objectAtIndex:0] setBounces:NO];
    [self.scrollView addSubview:webView];
}



//  循环创建button
- (void)createButtonWithCount:(NSInteger)count Titles:(NSMutableArray*)array{
     float offset = 0;
    
    for (int i = 0; i < count; i ++) {
        CGFloat width = [CalculateTool widthForLableText:array[i] ForTextSize:16];
        UIButton*button = [[UIButton alloc]initWithFrame:CGRectMake(15*(i + 1) + offset , 5, width + 10 , 25)];
        if (i == 0) {
            _specialView = [[UIView alloc]initWithFrame:button.frame];
            _specialView.layer.cornerRadius = 5;
            _specialView.layer.masksToBounds = YES;
             _specialView.backgroundColor = [UIColor redColor];
            _specialView.alpha = 0.5;
            [self.headerScroll addSubview:_specialView];
        }
          offset += width;
        [button setTitle:array[i] forState:(UIControlStateNormal)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        button.tag = 1000 + i;
        [button addTarget:self action:@selector(ChangeView:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.headerScroll addSubview:button];
    }
    _headerScroll.contentSize = CGSizeMake(offset + (15*count + 1) + 15, 35);
}


//  设置小滚动视图button的点击事件 使大的ScrollView进行偏移
- (void)ChangeView:(UIButton*)sender{
    NSInteger count = _scrollView.contentSize.width/self.view.frame.size.width;
    for (int i = 0; i < count; i ++) {
        if (sender.tag == 1000 + i) {
            self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width*i, 0);
            [self setSpecialViewWithTag:sender.tag];
            break;
        }
    }
}

//  给选中button添加选中效果
- (void)setSpecialViewWithTag:(NSInteger)tag{
    
    [UIView beginAnimations:@"温柔滚动" context:@"context"];
    [UIView setAnimationDuration:0.5];
    UIButton*button = [self.view viewWithTag:tag];
    _specialView.frame =  button.frame;
    [UIView commitAnimations];
}


//   ScrollView停止滑动触发的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger current = _scrollView.contentOffset.x / self.view.frame.size.width;
            [UIView beginAnimations:@"温柔滚动" context:@"context"];
            [UIView setAnimationDuration:0.5];
            UIButton*button = [self.view viewWithTag:1000 + current ];
            _specialView.frame =  button.frame;
            [UIView commitAnimations];
    if ( 3 < current &&  current < 6)
    {
        if (CGRectGetMaxX(button.frame) > self.view.frame.size.width) {
            _headerScroll.contentOffset = CGPointMake(button.frame.origin.x - 10, 0);
        }else if(button.frame.origin.x < self.view.frame.size.width){
            _headerScroll.contentOffset = CGPointMake( 0, 0);
        }
    }
    


}


//  设置ScrollView的contentSize
- (void)setScrollViewContentSize:(NSInteger)count{
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width*count, self.view.frame.size.height);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
