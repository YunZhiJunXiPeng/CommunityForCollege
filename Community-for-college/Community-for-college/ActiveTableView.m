//
//  ActiveTableView.m
//  Community-for-college
//
//  Created by lanou3g on 16/8/17.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "ActiveTableView.h"
#import "ActiveModel.h"

@implementation ActiveTableView

-(NSMutableArray *)activeArray{
    if (!_activeArray) {
        _activeArray = [NSMutableArray array];
    }
    return _activeArray;
}
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self request];
    }
    return self;
}

-(void)request{
    
    NSURL *url = [NSURL URLWithString:@"http://api.douban.com/v2/event/list?type=all&district=all&loc=108288&photo_cate=image&photo_count=1&start=3&day_type=future&apikey=062bcf31694a52d212836d943bdef876"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
            for (NSDictionary *dict in dic[@"events"]) {
                ActiveModel *model = [ActiveModel new];
                [model setValuesForKeysWithDictionary:dict];
                [self.activeArray addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadData];
            });
        }
    }];
    [task resume];
}
@end
