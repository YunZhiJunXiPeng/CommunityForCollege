//
//  NotMissViewController.m
//  Community-for-college
//
//  Created by 夏夕空 on 16/8/20.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "NotMissViewController.h"

@interface NotMissViewController ()

@end

@implementation NotMissViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:188.0/255.0 blue:227.0/255.0 alpha:1];
    UIWebView*webView = [[UIWebView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width,  self.view.frame.size.height)];
    NSURLRequest*request = [NSURLRequest requestWithURL:[NSURL URLWithString:_LinkUrl]];
    NSLog(@"%@",_LinkUrl);
    [webView loadRequest:request];
    [(UIScrollView *)[[webView subviews] objectAtIndex:0] setBounces:NO];
    [self.view addSubview:webView];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
