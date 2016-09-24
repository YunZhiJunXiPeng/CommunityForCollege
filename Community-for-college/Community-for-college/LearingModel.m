//
//  LearingModel.m
//  EnglishiLearing
//
//  Created by 卖女孩的小火柴 on 16/8/19.
//  Copyright © 2016年 梁海洋. All rights reserved.
//

#import "LearingModel.h"

@implementation LearingModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _ID = value;
    }
    
}

@end
