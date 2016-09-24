//
//  BoyBooksModel.h
//  Community-for-college
//
//  Created by lanou3g on 16/8/16.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoyBooksModel : NSObject
//书名
@property (copy , nonatomic) NSString *name;
//分类
@property (copy , nonatomic) NSString *classes;
//详情
@property (copy , nonatomic) NSString *desc;
//完本感言文字
@property (copy , nonatomic) NSString *lastChapterName;
//图片
@property (copy , nonatomic) NSString *imgUrl;
//作者
@property (copy , nonatomic) NSString *author;

@property (copy , nonatomic) NSString *nid;
@end
