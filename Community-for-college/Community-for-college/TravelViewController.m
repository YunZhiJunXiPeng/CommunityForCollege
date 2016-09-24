

#import "TravelViewController.h"
#import "TravelCollectionViewCell.h"
#import "TravelModel.h"
#import <UIImageView+WebCache.h>
#import "NewsViewController.h"
#import "TwoLevelViewController.h"
#import "HeaderCollectionReusableView.h"
#import "CalculateTool.h"
#import "CityDetailViewController.h"

@interface TravelViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong,nonatomic) NSMutableArray*dataArray;
@property (strong,nonatomic) UICollectionView*collectionView;

@property (strong,nonatomic) UILabel*titleLabel;
@property (assign,nonatomic) NSInteger buttonTag;

@end


@implementation TravelViewController

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray =  [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   self.navigationItem.title = @"去哪儿";
    self.view.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:188.0/255.0 blue:227.0/255.0 alpha:1];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:245.0/255 green:88.0/255 blue:135.0/255 alpha:1];
     NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:[self createCollectionView]];

}


//  返回顶部
- (void)loopingAlignment{
    [self.collectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}



//  数据请求方法
- (void)requestIndex:(NSInteger)index{
    if (_dataArray != nil) {
        [_dataArray removeAllObjects];
    }
    NSURL *url = [NSURL URLWithString:@"http://open.qyer.com/qyer/footprint/continent_list?client_id=qyer_ios&client_secret=cd254439208ab658ddf9&count=20&page=1&track_app_channel=App%2520Store&track_app_version=7.0.1&track_device_info=iPhone7%2C2&track_deviceid=83903AA6-652F-4E34-ACFC-960F4C061376&track_os=ios%25209.3.3&v=1"];
    NSURLSession*session =  [NSURLSession sharedSession];
    NSURLSessionTask*task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
         if (error == nil) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        NSArray*array = dic[@"data"];
//        取出亚洲
        NSDictionary*dict = array[index];

        NSArray*hotCountry = dict[@"hot_country"];
        for (NSDictionary*dictionary in hotCountry) {
            TravelModel*model = [TravelModel new];
            [model setValuesForKeysWithDictionary:dictionary];
            [self.dataArray addObject:model];
        }
        NSArray*countrys = dict[@"country"];
        for (NSDictionary*country in countrys) {
            TravelModel*model = [TravelModel new];
            [model setValuesForKeysWithDictionary:country];
            [self.dataArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
           _titleLabel.text = [NSString stringWithFormat:@"%@热门目的地",dict[@"cnname"]];
            [_collectionView reloadData];
            [self loopingAlignment];
        });
            }
    }];
    [task resume];
}



- (UICollectionView*)createCollectionView{
    //    设置布局对象
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    //    设置item大小
    flowLayout.itemSize = CGSizeMake((self.view.bounds.size.width - 40)/2, (self.view.bounds.size.width - 40)*0.75);
    //    设置行间距
    flowLayout.minimumLineSpacing = 16;
    //    设置列间距
    flowLayout.minimumInteritemSpacing = 10;
    //    设置滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //    设置每个分区的边缘位置(上左下右）
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    //    设置增补视图的size
  flowLayout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, self.view.frame.size.height*270/667);
    flowLayout.footerReferenceSize = CGSizeMake(self.view.bounds.size.width, 30);
    
    //    创建UICollectionView
    UICollectionView*collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 100) collectionViewLayout:flowLayout];
    collectionView.bounces = NO;
    //    设置背景颜色
    collectionView.backgroundColor =  [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1];
    //    设置代理
    collectionView.delegate = self;
    //    设置数据源
    collectionView.dataSource = self;

    
//    注册cell
    [collectionView registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [collectionView registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [collectionView registerClass:[TravelCollectionViewCell class] forCellWithReuseIdentifier:@"collection"];
    _collectionView = collectionView;
    
    UILabel*titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.view.frame.size.height*270/667*0.85  + 5, self.view.frame.size.width - 30, self.view.frame.size.height*270/667*0.15 - 10)];
    titleLabel.textColor = [UIColor colorWithRed:245.0/255 green:88.0/255 blue:135.0/255 alpha:1];
    titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel = titleLabel;
    [self.collectionView addSubview:titleLabel];
    [self createButton];
    
    return collectionView;
}



//  创建控制数据请求的 button
- (void)createButton{
    CGFloat Nwidth = [CalculateTool widthForLableText:@"北美洲" ForTextSize:14];
    UIButton*NorthAmerica  = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/5.8, self.view.frame.size.height*270/667*0.8*0.26, Nwidth, 32)];
    [NorthAmerica  setBackgroundImage:[UIImage imageNamed:@"花花"] forState:(UIControlStateNormal)];
     [NorthAmerica  setBackgroundImage:[UIImage imageNamed:@"会话框High"] forState:(UIControlStateSelected)];
    [NorthAmerica  setTitle:@"北美洲" forState:(UIControlStateNormal)];
    [NorthAmerica setTitleColor:[UIColor colorWithRed:245.0/255 green:88.0/255 blue:135.0/255 alpha:1]  forState:(UIControlStateNormal)];
    [NorthAmerica setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
    NorthAmerica.titleLabel.font = [UIFont systemFontOfSize:12];
    [NorthAmerica addTarget:self action:@selector(RequestData:) forControlEvents:(UIControlEventTouchUpInside)];
    NorthAmerica.titleEdgeInsets = UIEdgeInsetsMake(6,0, 10, 0);
    NorthAmerica.tag = 10001;
    [self.collectionView addSubview:NorthAmerica];
    
    
    CGFloat Awidth = [CalculateTool widthForLableText:@"亚洲" ForTextSize:15];
    UIButton*Asia  = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.77, self.view.frame.size.height*270/667*0.8*0.25, Awidth, 32)];
    [Asia  setBackgroundImage:[UIImage imageNamed:@"花花"] forState:(UIControlStateNormal)];
     [Asia  setBackgroundImage:[UIImage imageNamed:@"会话框High"] forState:(UIControlStateSelected)];
    [Asia  setTitle:@"亚洲" forState:(UIControlStateNormal)];
    [Asia setTitleColor:[UIColor colorWithRed:245.0/255 green:88.0/255 blue:135.0/255 alpha:1]  forState:(UIControlStateNormal)];
    [Asia setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
    Asia.titleLabel.font = [UIFont systemFontOfSize:12];
    [Asia addTarget:self action:@selector(RequestData:) forControlEvents:(UIControlEventTouchUpInside)];
    Asia.titleEdgeInsets = UIEdgeInsetsMake(6,0, 10, 0);
    Asia.tag = 10002;
    Asia.selected = YES;
     [self requestIndex:0];
    _buttonTag = Asia.tag;
    [self.collectionView addSubview:Asia];
    
    
    UIButton*Euroup  = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.55, self.view.frame.size.height*270/667*0.8*0.2, Awidth, 32)];
    [Euroup  setBackgroundImage:[UIImage imageNamed:@"花花"] forState:(UIControlStateNormal)];
     [Euroup  setBackgroundImage:[UIImage imageNamed:@"会话框High"] forState:(UIControlStateSelected)];
    [Euroup  setTitle:@"欧洲" forState:(UIControlStateNormal)];
    [Euroup setTitleColor:[UIColor colorWithRed:245.0/255 green:88.0/255 blue:135.0/255 alpha:1] forState:(UIControlStateNormal)];
    [Euroup setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
    Euroup.titleLabel.font = [UIFont systemFontOfSize:12];
    [Euroup addTarget:self action:@selector(RequestData:) forControlEvents:(UIControlEventTouchUpInside)];
    Euroup.titleEdgeInsets = UIEdgeInsetsMake(6,0, 10, 0);
    Euroup.tag = 10003;
    [self.collectionView addSubview:Euroup];
    
    
    UIButton*SouthAmerica  = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/3.6, self.view.frame.size.height*270/667*0.8 *0.65, Nwidth, 32)];
    [SouthAmerica  setBackgroundImage:[UIImage imageNamed:@"花花"] forState:(UIControlStateNormal)];
    [SouthAmerica  setBackgroundImage:[UIImage imageNamed:@"会话框High"] forState:(UIControlStateSelected)];
    [SouthAmerica  setTitle:@"南美洲" forState:(UIControlStateNormal)];
    [SouthAmerica setTitleColor:[UIColor colorWithRed:245.0/255 green:88.0/255 blue:135.0/255 alpha:1]  forState:(UIControlStateNormal)];
    [SouthAmerica setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
    SouthAmerica.titleLabel.font = [UIFont systemFontOfSize:12];
    [SouthAmerica addTarget:self action:@selector(RequestData:) forControlEvents:(UIControlEventTouchUpInside)];
    SouthAmerica.titleEdgeInsets = UIEdgeInsetsMake(6,0, 10, 0);
    SouthAmerica.tag = 10004;
    [self.collectionView addSubview:SouthAmerica];

    
    UIButton*Africa  = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.52, self.view.frame.size.height*270/667*0.8*0.5, Awidth, 32)];
    [Africa  setBackgroundImage:[UIImage imageNamed:@"花花"] forState:(UIControlStateNormal)];
    [Africa  setBackgroundImage:[UIImage imageNamed:@"会话框High"] forState:(UIControlStateSelected)];
    [Africa  setTitle:@"非洲" forState:(UIControlStateNormal)];
    [Africa setTitleColor:[UIColor colorWithRed:245.0/255 green:88.0/255 blue:135.0/255 alpha:1] forState:(UIControlStateNormal)];
    [Africa setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
    Africa.titleLabel.font = [UIFont systemFontOfSize:12];
    [Africa addTarget:self action:@selector(RequestData:) forControlEvents:(UIControlEventTouchUpInside)];
    Africa.titleEdgeInsets = UIEdgeInsetsMake(6,0, 10, 0);
    Africa.tag = 10005;
    [self.collectionView addSubview:Africa];
    
    
    UIButton*Oceania  = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.82, self.view.frame.size.height*270/667*0.8 *0.66, Nwidth, 32)];
    [Oceania  setBackgroundImage:[UIImage imageNamed:@"花花"] forState:(UIControlStateNormal)];
    [Oceania  setBackgroundImage:[UIImage imageNamed:@"会话框High"] forState:(UIControlStateSelected)];
    [Oceania  setTitle:@"大洋洲" forState:(UIControlStateNormal)];
    [Oceania setTitleColor:[UIColor colorWithRed:245.0/255 green:88.0/255 blue:135.0/255 alpha:1]  forState:(UIControlStateNormal)];
    [Oceania setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
    Oceania.titleLabel.font = [UIFont systemFontOfSize:12];
    [Oceania addTarget:self action:@selector(RequestData:) forControlEvents:(UIControlEventTouchUpInside)];
    Oceania.titleEdgeInsets = UIEdgeInsetsMake(6,0, 10, 0);
    Oceania.tag = 10006;
    [self.collectionView addSubview:Oceania];
    
    
    UIButton*Antarctica  = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.2, self.view.frame.size.height*270/667*0.8 *0.86, Nwidth, 32)];
    [Antarctica  setBackgroundImage:[UIImage imageNamed:@"花花"] forState:(UIControlStateNormal)];
    [Antarctica  setBackgroundImage:[UIImage imageNamed:@"会话框High"] forState:(UIControlStateSelected)];
    [Antarctica  setTitle:@"南极洲" forState:(UIControlStateNormal)];
    [Antarctica setTitleColor:[UIColor colorWithRed:245.0/255 green:88.0/255 blue:135.0/255 alpha:1]  forState:(UIControlStateNormal)];
    [Antarctica setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
    Antarctica.titleLabel.font = [UIFont systemFontOfSize:12];
    [Antarctica addTarget:self action:@selector(RequestData:) forControlEvents:(UIControlEventTouchUpInside)];
    Antarctica.titleEdgeInsets = UIEdgeInsetsMake(6,0, 10, 0);
    Antarctica.tag = 10007;
    [self.collectionView addSubview:Antarctica];
    
    
}



//  判断点击的button 请求数据
- (void)RequestData:(UIButton*)sender{
    if (sender.tag != _buttonTag) {
        UIButton*button1 = [self.view viewWithTag:_buttonTag];
        if (_buttonTag != 0) {
            button1.selected = NO;
        }
        if (sender.tag == 10001) {
            [self requestIndex:2];
        }else if (sender.tag == 10002){
             [self requestIndex:0];
        }else if(sender.tag == 10003){
             [self requestIndex:1];
        }else if(sender.tag == 10004){
            [self requestIndex:3];
        }else if (sender.tag == 10006){
            [self requestIndex:4];
        }else if (sender.tag == 10005){
            [self requestIndex:5];
        }else if (sender.tag == 10007){
             [self requestIndex:6];
        }
        UIButton*button2 = [self.view viewWithTag:sender.tag];
        button2.selected = YES;
        _buttonTag = button2.tag;
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    NSLog(@"%ld",_dataArray.count);
    return _dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TravelCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collection" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
//    TravelModel*model  = [TravelModel new];
    cell.model = _dataArray[indexPath.row];

    return cell;
}

// 返回头脚视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        HeaderCollectionReusableView*headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        [headerView.WordImage sd_setImageWithURL:[NSURL URLWithString:@"http://www.wuyueart.com/uploads/allimg/140418/11-14041Q51R2b3.jpg"]];
        return headerView;
    }else{
        HeaderCollectionReusableView*footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
        return footer;
    }
    return nil;
}



#pragma mark --------------- 不使用segment
/*
- (void)setSegmentControl{
    NSArray*segmentArray = @[@"亚洲",@"欧洲",@"北美洲"];
    UISegmentedControl*segmentControl = [[UISegmentedControl alloc]initWithItems:segmentArray];
    segmentControl.frame = CGRectMake(20, 5, self.view.bounds.size.width - 40, 30);
    segmentControl.tintColor = [UIColor colorWithRed:247.0/255.0 green:133.0/255.0 blue:193.0/255.0 alpha:1];
    [self.view addSubview:segmentControl];
    segmentControl.selectedSegmentIndex = 0;
    [self requestIndex:0];
    [segmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:(UIControlEventValueChanged)];
}

- (void)segmentAction:(UISegmentedControl*)sender{
    NSInteger index = sender.selectedSegmentIndex;
    switch (index) {
        case 0:
             [self requestIndex:0];
//            [self.view insertSubview:_firstView belowSubview:sender];
            break;
        case 1:
            
            [self requestIndex:1];
//            [self.view insertSubview:_secondView belowSubview:sender];
            break;
        case 2:
            [self requestIndex:2];
            break;
        default:
            break;
    }
}
*/



//  CollectionView cell点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TravelModel*model = [TravelModel new];
    model = _dataArray[indexPath.row];
    if ([model.label isEqualToString:@"城市"]) {
        TwoLevelViewController*twoLevel = [TwoLevelViewController new];
        twoLevel.ID = model.id;
        twoLevel.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:twoLevel animated:YES];
    }else{
        CityDetailViewController*city = [CityDetailViewController new];
        city.ID = [NSString stringWithFormat:@"%ld",model.id];
        [self.navigationController pushViewController:city animated:YES];
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
