

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "RequstHandle.h"
#import "HeadlineTableViewController.h"
#import "DataModel.h"
#import <AVFoundation/AVFoundation.h>
#import "HeaderOfNews.h"
#import "CommonHandle.h"
#import "AppDelegate.h"
//解锁
#import "UnLockLoginViewController.h"

@interface DetailViewController ()<RequestHandleDelegat,UIGestureRecognizerDelegate,UIWebViewDelegate>
@property (nonatomic,retain)UIButton *returnBT;
@property (nonatomic,retain)UIButton *shareBT;
@property (nonatomic,retain)UIButton *collectBT;
@property (nonatomic,retain)UIView *myView;
@property (nonatomic,copy)NSString *whichURL;
@property (nonatomic,retain)UIView *myView1;
@property (nonatomic,retain)UISlider *wordSlider;

@property (nonatomic)BOOL isNO;
@property (nonatomic)BOOL isAction;
@property (nonatomic,retain)UIButton *changeBT;
@property (nonatomic,retain)UIImageView *backImage;
@property (nonatomic,copy)NSString *str1;

//记录黑夜模式的bool值
@property (nonatomic,strong)NSString *strNight;
@property (nonatomic,strong)NSUserDefaults *userdefault;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 布局View
    [self layoutView];
    // 布局bottomButton
    
    [self layoutBar];
    // 手势
    [self creatRecognizers];
    
    self.isAction = YES;  // 判断轻拍事件
//    UIButton *lbtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,24,30)];
////    [lbtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//    lbtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [lbtn addTarget:self action:@selector(onClickBack) forControlEvents:UIControlEventTouchUpInside];
//    [lbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:lbtn];
    
    
    [self requestData];
}

//返回新闻列表页面
- (void)onClickBack{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


//自适应高度布局
-(void)layoutView
{
    self.backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, SCREEN.size.width, SCREEN.size.height)];
    _backImage.image = [UIImage imageNamed:kBackImage];
    _backImage.alpha = 0.2;
    [self.view addSubview:_backImage];
    
    //详情页面的小标题
    UIView *littleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 30)];
    littleView.backgroundColor = [UIColor whiteColor];
    //报道媒体
    self.mySource = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN.size.width/2-110, 5, 150, 20)];
    _mySource.textAlignment = NSTextAlignmentLeft;
    self.myTime = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN.size.width/2+30, 5, 150, 20)];
    //时间
    _myTime.textAlignment = NSTextAlignmentLeft;
    _mySource.font = [UIFont systemFontOfSize:13];
    _myTime.font = [UIFont systemFontOfSize:13];
    
    [littleView addSubview:_mySource];
    [littleView addSubview:_myTime];
    [self.view addSubview:littleView];
    
    
    self.myDetail = [[UIWebView alloc] initWithFrame:CGRectMake(0, 25, SCREEN.size.width, SCREEN.size.height-80)];
    self.myDetail.backgroundColor = [UIColor cyanColor];
    _myDetail.opaque = NO;
    _myDetail.scrollView.bounces = NO;
    _myDetail.delegate = self;
    _myDetail.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_myDetail];
    
    [self.navigationItem setHidesBackButton:TRUE animated:NO];
 
    
    
    //自定义bar
    [self layoutBar];
    
    //自定义navigationBar
    [self layoutNavigationBar];
    
    
    
    self.myView1 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN.size.width -44, -260, 35, 200)];
    _myView1.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:0.9];
    _myView1.layer.cornerRadius = 15;
    [self.view addSubview:_myView1];
    
    

    // 布局slider
    [self layoutSliders];
}


// 布局slider
-(void)layoutSliders
{
    Slide = [[UISlider alloc]initWithFrame:(CGRectMake(-47, 65, 130, 80))];
    [Slide addTarget:self action:@selector(SlideChange) forControlEvents:(UIControlEventValueChanged)];
    //竖直放置slider的方法
    Slide.transform = CGAffineTransformMakeRotation(1.57079633);
    Slide.maximumValue = 180.0f;
    Slide.minimumValue = 50.0f;
    Slide.value = 100;
    [_myView1 addSubview:Slide];
}

//自定义navigationBar  用于加font和night模式
-(void)layoutNavigationBar
{
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(lineAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

//调节字体
-(void)lineAction:(UIBarButtonItem *)button
{
    if (_isNO) {
        [UIView beginAnimations:@"animat" context:nil];
        //设置时间
        [UIView setAnimationDuration:0.8f];
        self.myView1.transform = CGAffineTransformMakeTranslation(0, 266);
        self.myView1.transform = CGAffineTransformScale(self.myView1.transform, 1.01, 1.01);
        [UIView commitAnimations];
        _isNO = NO;
    }else{
        [UIView beginAnimations:@"animat" context:nil];
        [UIView setAnimationDuration:0.8f];
        self.myView1.transform = CGAffineTransformMakeTranslation(0, -266);
        self.myView1.transform = CGAffineTransformScale(self.myView1.transform, 0.01, 1.01);
        [UIView commitAnimations];
        _isNO = YES;
    }
}


//字体设置
-(void)SlideChange
{
    NSString* str1 =[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'",Slide.value];
    [_myDetail stringByEvaluatingJavaScriptFromString:str1];
//    NSLog(@"%@",str1);
    
}

#pragma mark ------ 跳转进界面首先判断是否为夜间模式 ------  
- (void)viewWillAppear:(BOOL)animated
{
    _userdefault = [NSUserDefaults standardUserDefaults];
    [self changeNight];
}
- (void)changeNight
{
    _strNight = [_userdefault objectForKey:@"style"];
    if (_strNight == nil) {
        [_changeBT setBackgroundImage:[UIImage imageNamed:@"night"] forState:UIControlStateNormal];
       
        [_userdefault setObject:@"LOVE"forKey:@"style"];
        [_userdefault synchronize];
        

    }
    
    else
    {
        [_changeBT setBackgroundImage:[UIImage imageNamed:@"sun"] forState:UIControlStateNormal];
        
        
        
        [_userdefault removeObjectForKey:@"style"];
        [_userdefault synchronize];
        
        
    }

}

//改变字体颜色
- (void)changeTextColor
{
    
    _strNight = [_userdefault objectForKey:@"style"];
    if (_strNight == nil) {
        [_changeBT setBackgroundImage:[UIImage imageNamed:@"night"] forState:UIControlStateNormal];
        NSString* str1 =[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'black'"];
        NSString *str2 = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.background='#ffffff'"];
        [_userdefault setObject:@"LOVE"forKey:@"style"];
        [_userdefault synchronize];
        
        [_myDetail stringByEvaluatingJavaScriptFromString:str1];
        [_myDetail stringByEvaluatingJavaScriptFromString:str2];
    }

    else
    {
        [_changeBT setBackgroundImage:[UIImage imageNamed:@"sun.png"] forState:UIControlStateNormal];
        NSString* str1 =[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'gray'"];
        NSString *str2 = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.background='#2E2E2E'"];
        
        
        [_userdefault removeObjectForKey:@"style"];
        [_userdefault synchronize];
        
        [_myDetail stringByEvaluatingJavaScriptFromString:str1];
        [_myDetail stringByEvaluatingJavaScriptFromString:str2];

    }
    
}

#pragma mark - 请求数据
-(void)whichDetailView
{
    if ([CommonHandle shareHandle].tableViewTag == 100)
    {
        self.whichURL = kHeadLineDetailURL;
        
    }else if ([CommonHandle shareHandle].tableViewTag == 101)
    {
        self.whichURL = kInformationDetailURL;
        
    }else if ([CommonHandle shareHandle].tableViewTag == 102)
    {
        self.whichURL = kPhoneDetailURL;
        
    }else if ([CommonHandle shareHandle].tableViewTag == 103)
    {
        self.whichURL = kGameDetailURL;
        
    }
    
}

-(void)requestData
{
    [self whichDetailView];
    
    NSString *str1 = [NSString stringWithFormat:self.whichURL,_str];
    NSLog(@"-----------%@",_str);
    [[RequstHandle alloc]initWithURLString:str1 paraString:nil metod:@"GET" delegate:self];
}

-(void)requestHandle:(RequstHandle *)requesthandle didSucceedWithData:(NSMutableData *)data
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSDictionary *dic1 = [dic valueForKey:_str];
    self.allDetail = [[DataModel alloc]init];
    [_allDetail setValuesForKeysWithDictionary:dic1];
//    NSLog(@"==========%@",_allDetail.img);
    NSLog(@"==========%d",_allDetail.img.count);
    NSString *str = [_allDetail.ptime substringWithRange:NSMakeRange(5, 11)];
    for (int i = 0; i < _allDetail.img.count; i++) {
        NSString *str1 = [_allDetail.img[i] valueForKey:@"src"];
        NSString *str2 = [NSString stringWithFormat:@"<p><img src=\"%@\" style=\" width:%.fpx; \"/></p>", str1,[UIScreen mainScreen].bounds.size.width-20];
        NSString *str3 = [NSString stringWithFormat:@"<!--IMG#%d-->", i];
        _allDetail.body = [_allDetail.body stringByReplacingOccurrencesOfString:str3 withString:str2];
    }
    
    self.myDetail.scrollView.contentSize =CGSizeMake(SCREEN.size.width, SCREEN.size.height - 80);
    self.myDetail.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.title = _allDetail.title;
    _mySource.text = _allDetail.source;
    _myTime.text = str;
    
    [self.myDetail loadHTMLString:_allDetail.body baseURL:nil];

    
}

- (void)requestHandle:(RequstHandle *)requsetHandle failWithError:(NSError *)error
{
    NSLog(@"请求失败");
}



#pragma mark - 手势操作

// 手势
-(void) creatRecognizers
{
    //用户交互
    self.myDetail.userInteractionEnabled = YES;
    
    //********************  添加轻拍手势  *******************
    
    //手势冲突 服从代理 禁止系统点击事件  实现自己的
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_Action)];
    [self.myDetail addGestureRecognizer:singleTap];//这个可以加到任何控件上,比如你只想响应WebView，我正好填满整个屏幕
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    
    
    [self.myDetail addGestureRecognizer:singleTap];
    
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
// 1 轻拍手势
-(void)tap_Action
{
    NSLog(@"我被点了");
    
        if (_isAction) {
            
//            设置时间
            [UIView beginAnimations:@"animat" context:nil];
            [UIView setAnimationDuration:0.6f];
            self.myView.transform = CGAffineTransformMakeTranslation(0, -106);
            self.myView.transform = CGAffineTransformScale(self.myView.transform, 1.01, 1.01);
            [UIView commitAnimations];
            [self.myView setHidden:NO];
            
            [UIView animateWithDuration:1 animations:^{
                self.myView.alpha = 1.0;
                _isAction = NO;
            }];
            
            
            // 提交动画
            [UIView commitAnimations];
        }else{
            
            //设置时间
//            [UIView beginAnimations:@"animat" context:nil];
//            [UIView setAnimationDuration:0.6f];
//            self.myView.transform = CGAffineTransformMakeTranslation(0, 64);
//            self.myView.transform = CGAffineTransformScale(self.myView.transform, 1.01, 1.01);
//            [UIView commitAnimations];
//            [self.myView setHidden:YES];
//            _isAction = YES;
            
            [UIView animateWithDuration:1 animations:^{
                self.myView.alpha = 0;
                _isAction = YES;
            }];
            
        }
 
    
}


#pragma mark - bottomButton
//自定义bar BottomButton
-(void)layoutBar
{
    
    
    self.myView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN.size.height - 0, SCREEN.size.width, 44)];
    [_myView setBackgroundColor:[UIColor whiteColor]];
    [self.view insertSubview:self.myView aboveSubview:self.myDetail];
    
    [self.myView setHidden:YES];
    self.returnBT = [UIButton buttonWithType:UIButtonTypeSystem];
    _returnBT.frame =CGRectMake(SCREEN.size.width/4 -47, 7, 25, 25);
    //  _returnBT.backgroundColor = [UIColor greenColor];
    UIImage *backImage = [[UIImage imageNamed:@"back.png"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    [_returnBT setImage:backImage forState:UIControlStateNormal];
    [_returnBT addTarget:self action:@selector(backViewController) forControlEvents:(UIControlEventTouchUpInside)];

    [_myView addSubview:_returnBT];
    
    self.shareBT = [UIButton buttonWithType:UIButtonTypeSystem];
    _shareBT.frame =CGRectMake(SCREEN.size.width/4*3 -65, 8, 22, 22);
    
    UIImage *shareImage = [[UIImage imageNamed:@"night.png"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    [_shareBT setImage:shareImage forState:UIControlStateNormal];
    [_shareBT addTarget:self action:@selector(changeTextColor) forControlEvents:(UIControlEventTouchUpInside)];

    [_myView addSubview:_shareBT];
    
    self.collectBT = [UIButton buttonWithType:UIButtonTypeSystem];
    _collectBT.frame =CGRectMake(SCREEN.size.width-60, 7, 25, 25);
   
    UIImage *collectImage = [[UIImage imageNamed:@"collection.png"]imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];//禁止渲染
    [_collectBT setImage:collectImage forState:UIControlStateNormal];
    [_myView addSubview:_collectBT];
    
}
//返回按钮
- (void)backViewController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



#pragma mark - 分享
//-(void)shareAction
//{
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:@"5538d89367e58ebaa00030a5"
//                                      shareText:@"友盟社会化分享让您快速实现分享等社会化功能，http://umeng.com/social"
//                                     shareImage:[UIImage imageNamed:@"icon"]
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,nil]
//                                       delegate:self];
//}
//
//-(BOOL)isDirectShareInIconActionSheet
//{
//    return YES;
//}
//
//-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
//{
//    if (response.responseCode == UMSResponseCodeSuccess) {
//        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
//    }
//}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
