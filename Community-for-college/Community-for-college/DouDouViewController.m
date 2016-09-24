

#import "DouDouViewController.h"
#import <UIImageView+WebCache.h>

//游戏视频
#import "GameCollectionViewCell.h"
#import "GameCollectionView.h"
#import "GameModel.h"
#import "GameVideoViewController.h"

//英雄简介
#import "HeroModel.h"
#import "HeroCollectionViewCell.h"
#import "HeroCollectionView.h"
#import "HeroDetailsViewController.h"

@interface DouDouViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(strong , nonatomic)UIScrollView *DouDouScroll;
@property (nonatomic,strong)UISegmentedControl *segment;
@property(strong , nonatomic)GameCollectionView *GameView;
@property(strong , nonatomic)HeroCollectionView *heroView;
@end
#define KWidth self.view.frame.size.width
#define KHeigth self.view.frame.size.height

@implementation DouDouViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    self.navigationItem.title = @"打豆豆";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:245.0/255 green:88.0/255 blue:135.0/255 alpha:1];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KWidth, 30)];
    [self.view addSubview:view];
    self.navigationController.navigationBar.translucent = NO;
    
//  初始化游戏视频页面
 
    UICollectionViewFlowLayout *GameflowLayout = [[UICollectionViewFlowLayout alloc] init];
    [GameflowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    GameflowLayout.minimumInteritemSpacing = 10;
    GameflowLayout.minimumLineSpacing = 15;
    GameflowLayout.sectionInset = UIEdgeInsetsMake(10, 8, 10, 8);
    GameflowLayout.itemSize = CGSizeMake((KWidth-30)/2, KWidth/3 + 40);

    self.GameView=[[GameCollectionView alloc] initWithFrame:CGRectMake(0, 40, KWidth, KHeigth - 152) collectionViewLayout:GameflowLayout];
    //设置背景颜色
    self.GameView.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:216 / 255.0 blue:240 / 255.0 alpha:1.0];
    
    self.GameView.bounces = NO;//禁止弹跳
    self.GameView.delegate = self;
    self.GameView.dataSource = self;
    [self.GameView registerClass:[GameCollectionViewCell class] forCellWithReuseIdentifier:@"gameCell"];
    [self.view addSubview: _GameView];
    

//    初始化英雄简介colletionview
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.heroView=[[HeroCollectionView alloc] initWithFrame:CGRectMake(0, 40, KWidth, KHeigth - 140) collectionViewLayout:flowLayout];
    self.heroView.bounces = NO;
    self.heroView.dataSource=self;
    self.heroView.delegate=self;


    [self.heroView setBackgroundColor:[UIColor whiteColor]];

    flowLayout.minimumInteritemSpacing = 30;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 20, 50);
    flowLayout.itemSize = CGSizeMake((KWidth)/3 +20  , (KWidth - 30)/6 - 5);
    [self.heroView registerClass:[HeroCollectionViewCell class] forCellWithReuseIdentifier:@"heroCell"];
    [self.view addSubview:_heroView];
    
//    添加segment控制器
    NSArray *array = @[@"游戏视频",@"英雄简介"];


    _segment = [[UISegmentedControl alloc]initWithItems:array];
    _segment.frame =CGRectMake(10, 5, self.view.frame.size.width-20, 30);
    
    [_segment addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:(UIControlEventValueChanged)];
    /*
     这个是设置按下按钮时的颜色
     */
    _segment.tintColor = [UIColor colorWithRed:247.0/255.0 green:133.0/255.0 blue:193.0/255.0 alpha:1];
    _segment.selectedSegmentIndex = 0;//默认选中的按钮索引
    [self indexDidChangeForSegmentedControl:_segment];
    /*
     下面的代码实同正常状态和按下状态的属性控制,比如字体的大小和颜色等
     */
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12],NSFontAttributeName,[UIColor colorWithRed:247.0/255.0 green:133.0/255.0 blue:193.0/255.0 alpha:1], NSForegroundColorAttributeName,  nil];
    [_segment setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
    [_segment setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    [view addSubview:_segment];
    
   }

//根据segment的index切换视图
-(void)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender{
    NSInteger selecIndex = sender.selectedSegmentIndex;
 
    switch (selecIndex) {
        case 0:{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view insertSubview:_GameView belowSubview:sender];
                [self.GameView reloadData];
            });
        }
            break;
        case 1:{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view insertSubview:_heroView belowSubview:sender];
                [_heroView reloadData];
            });
        }
            break;
        default:
            break;
    }
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_segment.selectedSegmentIndex == 0){
        return self.GameView.dataArray.count;
    }else if (_segment.selectedSegmentIndex == 1) {
        return self.heroView.heroDataArray.count;
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
       if (self.segment.selectedSegmentIndex == 0){
        GameCollectionViewCell *cell = [_GameView dequeueReusableCellWithReuseIdentifier:@"gameCell" forIndexPath:indexPath];
        GameModel *model = self.GameView.dataArray[indexPath.row];
           cell.titleLabel.font = [UIFont systemFontOfSize:14];
           cell.titleLabel.text = model.title;
           [cell.gameImageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:nil];
        
        return cell;
       }
       else if (self.segment.selectedSegmentIndex == 1) {
           HeroCollectionViewCell *heroCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"heroCell" forIndexPath:indexPath];
         
           HeroModel *model = self.heroView.heroDataArray[indexPath.row];
           //别名
           heroCell.anotherNameLabel.text = model.nick;
           //名称
           heroCell.nameLabel.text = model.name;
           //英雄属性
           heroCell.propertyLabel.text = [NSString stringWithFormat:@"%@/%@",model.tag1,model.tag2];
           /*

           if ([model.tag3 isEqualToString:@""]) {
               
               heroCell.propertyLabel.text = [NSString stringWithFormat:@"%@/%@",model.tag1,model.tag2];
           }else
           {
               heroCell.propertyLabel.text = [NSString stringWithFormat:@"%@/%@/%@",model.tag1,model.tag2,model.tag3];
           }
           */
           
           //hero图片
           NSString *heroImageStr = [NSString stringWithFormat:@"http://111.202.85.42/dlied1.qq.com/qqtalk/lolApp/img/champion/%@.png?mkey=57c262e44e165a8e&f=1c58&c=0&p=.png",model.en_name];
           [heroCell.heroImageView sd_setImageWithURL:[NSURL URLWithString:heroImageStr]placeholderImage:nil];
           
           return heroCell;
       }

    return nil;
}
//cell的点击事件 跳转详情
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.segment.selectedSegmentIndex == 0) {
        GameVideoViewController *learningVVC = [GameVideoViewController new];
        GameModel *model = [GameModel new];
        model = self.GameView.dataArray[indexPath.row];
        learningVVC.videoURL = model.url;
//        learningVVC.videoModel.videourl = model.url;
        learningVVC.videoTitle = model.title;
        [self.navigationController pushViewController:learningVVC animated:YES];
    }
    else if (self.segment.selectedSegmentIndex == 1) {
        HeroDetailsViewController *detail = [HeroDetailsViewController new];
        HeroModel *model = self.heroView.heroDataArray[indexPath.row];
        detail.heroDetailsModel = model;
        NSLog(@"=========%@",detail.heroDetailsModel.tag1);
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
