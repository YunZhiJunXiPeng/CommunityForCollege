//
//  HeroModel.h
//  Community-for-college
//
//  Created by 卖女孩的小火柴 on 16/8/28.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeroModel : NSObject

//英雄名称
@property (nonatomic,copy)NSString *name;
//英雄别称
@property (nonatomic,copy)NSString *nick;
//英雄属性
@property (nonatomic,copy)NSString *tag1;
@property (nonatomic,copy)NSString *tag2;
@property (nonatomic,copy)NSString *tag3;
//id
@property (nonatomic,copy)NSString *id;


//详情页面
// 英文名字,图片拼接使用
@property (strong,nonatomic) NSString *en_name;
//金币
@property (nonatomic,assign)NSInteger coin;
//价格
@property (nonatomic,assign)NSInteger money;
//背景故事
@property (nonatomic,copy)NSString *story;
//最强对手
@property (nonatomic,copy)NSString *opponent_reason1;
@property (nonatomic,copy)NSString *opponent_reason2;
//最佳搭档
@property (nonatomic,copy)NSString *partner_reason1;
@property (nonatomic,copy)NSString *partner_reason2;
//组织
@property (nonatomic,copy)NSString *group;
//英雄难度，攻，法，防，操作
@property (nonatomic,copy)NSString *attack;
@property (nonatomic,copy)NSString *magic;
@property (nonatomic,copy)NSString *defense;
@property (nonatomic,copy)NSString *difficulty;

@end
