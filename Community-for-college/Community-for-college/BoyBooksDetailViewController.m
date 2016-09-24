//
//  BoyBooksDetailViewController.m
//  Community-for-college
//
//  Created by lanou3g on 16/8/16.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "BoyBooksDetailViewController.h"
#import "BoyBookScrollView.h"
#import "DBHandle.h"
#import "BoyBooksModel.h"
//#import <UMSocial.h>
@interface BoyBooksDetailViewController ()

@property (strong , nonatomic) BoyBookScrollView *ScrollView;

@property (strong , nonatomic) UIBarButtonItem *Collect;
@property (strong , nonatomic) UIBarButtonItem *share;

@end

@implementation BoyBooksDetailViewController

- (void)loadView
{
    
    self.navigationItem.title = @"图书详情";
    self.ScrollView = [[BoyBookScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.ScrollView;
    
    self.ScrollView.model = self.model;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    DBHandle *dbhandle = [DBHandle sharedDBHandle];
    [dbhandle openDB];
    [dbhandle createBoyBooks];
    
    BOOL result = [dbhandle searchWithBoynid:self.model.nid];
    
    if (result == 0) {
        self.navigationItem.rightBarButtonItems[0].title = @"收藏";
    }else{
        self.navigationItem.rightBarButtonItems[0].title = @"取消";
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.Collect = [[UIBarButtonItem alloc]initWithTitle:@"" style:(UIBarButtonItemStyleDone) target:self action:@selector(collectAction:)];
//    self.share = [[UIBarButtonItem alloc]initWithTitle:@"Share" style:(UIBarButtonItemStylePlain) target:self action:@selector(share:)];
    self.navigationItem.rightBarButtonItems = @[self.Collect];
    
    
}

- (void)setModel:(BoyBooksModel *)model{
    _model = model;
}

- (void)collectAction:(UIBarButtonItem *)sender
{
    DBHandle *dbhandle = [DBHandle sharedDBHandle];
    [dbhandle openDB];
    
    if ([sender.title isEqualToString:@"收藏"]) {
        NSArray *array = [dbhandle searBoyBooks];
        NSLog(@"%@",array);
        [dbhandle insertWithBoyBooksnid:self.model.nid Name:self.model.name classes:self.model.classes desc:self.model.desc lastChapterName:self.model.lastChapterName imgUrl:self.model.imgUrl author:self.model.author];
        sender.title = @"取消";
    }else{
        [dbhandle deleteWitBoynid:self.model.nid];
        sender.title = @"收藏";
    }
    
}


//- (void)share:(UIBarButtonItem *)sender
//{
//    [UMSocialData defaultData].extConfig.title = self.model.name;
//    [UMSocialData defaultData].extConfig.qqData.url = self.model.imgUrl;
//    [UMSocialSnsService presentSnsIconSheetView:self
//    appKey:@"57b1684d67e58e866a001321"
//    shareText:@"友盟社会化分享让您快速实现分享等社会化功能，http://umeng.com/social"
//    shareImage:[UIImage imageNamed:@"icon"]
//    shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone]
//                                       delegate:self];
//}

//-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
//{
//    //根据`responseCode`得到发送结果,如果分享成功
//    if(response.responseCode == UMSResponseCodeSuccess)
//    {
//        //得到分享到的平台名
//        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
//    }
//}



















@end
