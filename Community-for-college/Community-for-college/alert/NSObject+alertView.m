//
//  NSObject+alertView.m
//  IM_text
//
//  Created by 杨少锋 on 16/6/27.
//  Copyright © 2016年 杨少锋. All rights reserved.
//

#import "NSObject+alertView.h"
#import <UIKit/UIKit.h>

@implementation NSObject (alertView)

// 提示
+ (void)alterString:(NSString *)msg {
    // 判断一下当前线程,
    if ([NSThread isMainThread]) { // 主线程
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        });
    }
}


@end
