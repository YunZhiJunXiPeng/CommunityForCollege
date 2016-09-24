//
//  HeroCollectionView.m
//  Community-for-college
//
//  Created by 卖女孩的小火柴 on 16/8/28.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "HeroCollectionView.h"
#import "HeroModel.h"

@interface HeroCollectionView ()

@property (nonatomic,strong)HeroCollectionView *heroCollectionView;
@end

@implementation HeroCollectionView

- (NSMutableArray*)heroDataArray
{
    if (!_heroDataArray) {
        _heroDataArray = [NSMutableArray array];
        
    }
    return _heroDataArray;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        //注册cell
        [self.heroCollectionView registerClass:[HeroCollectionView class] forCellWithReuseIdentifier:@"heroCell"];
        
        [self reloadHeroData];
    }
    return self;
}

- (void)reloadHeroData
{
    NSString *heroStr = @"http://ossweb-img.qq.com/upload/qqtalk/lol_hero/hero_list.js";
    NSURL *heroURL = [NSURL URLWithString:heroStr];
    NSURLSession *heroSession = [NSURLSession sharedSession];
    NSURLSessionTask *heroTask = [heroSession dataTaskWithURL:heroURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
            for (NSDictionary *dict in array) {
                HeroModel *HModel = [HeroModel new];
                [HModel setValuesForKeysWithDictionary:dict];
                [self.heroDataArray addObject:HModel];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadData];
            });
 
            }
                }];
    [heroTask resume];
}

@end
