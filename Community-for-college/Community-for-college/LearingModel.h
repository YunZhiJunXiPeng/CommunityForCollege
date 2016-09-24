//
//  LearingModel.h
//  EnglishiLearing
//
//  Created by 卖女孩的小火柴 on 16/8/19.
//  Copyright © 2016年 梁海洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LearingModel : NSObject

//id
@property (nonatomic,copy)NSString *ID;
//image(数组中存放了一个url)
@property (nonatomic,strong)NSArray *image;
//startTime201608190000
@property (nonatomic,copy)NSString *startTime;
//标题
@property (nonatomic,copy)NSString *title;
//type
@property (nonatomic,copy)NSString *type;
//获得的赞
@property (nonatomic,assign)NSInteger like;
//视频的接口
@property (nonatomic,copy)NSString *videourl;
//总时间
@property (nonatomic,assign)NSInteger endTime;
@end
