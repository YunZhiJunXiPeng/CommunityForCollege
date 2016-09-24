//
//  ListModel.h
//  Community-for-college
//
//  Created by 卖女孩的小火柴 on 16/8/15.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListModel : NSObject
@property(nonatomic,copy)NSString *docid;//用于拼接详情界面的URL
//@property(nonatomic,retain)NSString *arrayKey;//列表数组
@property(nonatomic,copy)NSString *title;//标题
@property(nonatomic,copy)NSString *imgsrc;//图片的URL
@property(nonatomic,copy)NSString *source;//数据来源
@property(nonatomic,copy)NSString *lmodify;//修改时间
@property(nonatomic,retain)NSArray *imgextra;//用来存放图片URL的数组
@property(nonatomic,retain)NSString *imgextra1;
@property(nonatomic,retain)NSString *imgextra2;
@end
