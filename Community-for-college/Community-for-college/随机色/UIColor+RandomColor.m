//
//  UIColor+RandomColor.m
//  UI_lesson_2_2
//
//  Created by 夏夕空 on 16/5/31.
//  Copyright © 2016年 郭佳. All rights reserved.
//

#import "UIColor+RandomColor.h"

@implementation UIColor (RandomColor)
+ (UIColor*)randomColor{
    
        return [UIColor colorWithHue:arc4random()%254/255.0 saturation:arc4random()%254/255.0 brightness:arc4random()%254/255.0 alpha:1];
}
@end
