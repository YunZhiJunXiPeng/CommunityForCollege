//
//  CalculateTool.h
//  UI_lesson_12 cell自适应高度
//
//  Created by 夏夕空 on 16/6/15.
//  Copyright © 2016年 郭佳. All rights reserved.
//

#import <Foundation/Foundation.h>
// 需要用到UIImageView
#import <UIKit/UIKit.h>
@interface CalculateTool : NSObject

// 计算文本的高度
+ (CGFloat)heightForLableText:(NSString*)text ForTextSize:(CGFloat)size;

// 计算图片高度
+ (CGFloat)heightForImage:(NSString *)imageName;

+ (CGFloat)widthForLableText:(NSString*)text ForTextSize:(CGFloat)size;

@end
