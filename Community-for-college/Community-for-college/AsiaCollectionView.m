//
//  AsiaCollectionView.m
//  Community-for-college
//
//  Created by 夏夕空 on 16/8/16.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "AsiaCollectionView.h"
#import "TravelModel.h"

@interface AsiaCollectionView ()
@property (strong,nonatomic) NSMutableArray*dataArray;

@end

@implementation AsiaCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
    }
    return self;
}




- (void)request{
    NSURL *url = [NSURL URLWithString:@"http://open.qyer.com/qyer/footprint/continent_list?client_id=qyer_ios&client_secret=cd254439208ab658ddf9&count=20&page=1&track_app_channel=App%2520Store&track_app_version=7.0.1&track_device_info=iPhone7%2C2&track_deviceid=83903AA6-652F-4E34-ACFC-960F4C061376&track_os=ios%25209.3.3&v=1"];
    NSURLSession*session =  [NSURLSession sharedSession];
    NSURLSessionTask*task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        NSArray*array = dic[@"data"];
        //        取出亚洲
        NSDictionary*dict = array.firstObject;
        NSArray*hotCountry = dict[@"hot_country"];
        for (NSDictionary*dictionary in hotCountry) {
            TravelModel*model = [TravelModel new];
            [model setValuesForKeysWithDictionary:dictionary];
            [self.dataArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //            NSLog(@"%@",_dataArray.firstObject);
            [self reloadData];
        });
    }];
    [task resume];
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
