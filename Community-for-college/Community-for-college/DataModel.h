//
//  DataModel.h
//  Community-for-college
//
//  Created by 卖女孩的小火柴 on 16/8/15.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject<NSCoding>
@property(nonatomic,copy)NSString *body;//详情
@property(nonatomic,retain)NSArray *img;//文章中插入的图片
@property(nonatomic,copy)NSString *title;//标题
@property(nonatomic,copy)NSString *ptime;//上传时间
@property(nonatomic,copy)NSString *source;//资料来源
@property(nonatomic,copy)NSString *item;
@end
