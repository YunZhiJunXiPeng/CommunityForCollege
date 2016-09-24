//
//  CalculateTool.m
//  UI_lesson_12 cell自适应高度
//
//  Created by 夏夕空 on 16/6/15.
//  Copyright © 2016年 郭佳. All rights reserved.
//

#import "CalculateTool.h"

@implementation CalculateTool

+ (CGFloat)heightForLableText:(NSString*)text ForTextSize:(CGFloat)size
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake([ UIScreen mainScreen].bounds.size.width,2000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size] } context:nil];
    return rect.size.height;
}


+ (CGFloat)widthForLableText:(NSString*)text ForTextSize:(CGFloat)size
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(1000,25) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size] } context:nil];
    return rect.size.width;
}



+ (CGFloat)heightForImage:(NSString *)imageName
{
    if (imageName) {
        UIImage*image = [UIImage imageNamed:imageName];
//        图片的宽和高
        CGFloat width  = image.size.width;
        CGFloat height = image.size.height;
        
        return height/width * ([UIScreen mainScreen].bounds.size.width);
    }
    return 0;
}

@end
