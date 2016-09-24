//
//  HomepageViewController.m
//  Community-for-college
//
//  Created by lanou3g on 16/8/19.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "HomepageViewController.h"

@interface HomepageViewController ()<UIWebViewDelegate>
{
    
    UIWebView *protWebView;
    
}
@property (weak, nonatomic) IBOutlet UIWebView *WebView;

@end

@implementation HomepageViewController
@synthesize WebView;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:@"http://m.kingreader.com/Class/List1/bsapp.chtml?tgid=6988141"];
    [WebView loadRequest:[NSURLRequest requestWithURL:url]];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    NSLog(@"webViewDidStartLoad");
    
}

- (void)webViewDidFinishLoad:(UIWebView *)web{
    
    NSLog(@"webViewDidFinishLoad");
    
}

-(void)webView:(UIWebView*)webView  DidFailLoadWithError:(NSError*)error{
    
    NSLog(@"DidFailLoadWithError");
    
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
