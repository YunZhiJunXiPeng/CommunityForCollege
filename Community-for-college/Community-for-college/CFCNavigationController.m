//
//  CFCNavigationController.m
//  Community-for-college
//
//  Created by lanou3g on 16/8/17.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "CFCNavigationController.h"

@interface CFCNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation CFCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    重设左按钮文字的frame，向右滑失效，通过代理让他有效
    self.interactivePopGestureRecognizer.delegate = self;
    
}
/**  重写push方法的目的 ： 拦截所有push进来的子控制器
 viewController push进来的子控制器
 */

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count > 0) {//如果viewController不是最早push进来的自控制器
        
        UIButton *backbutton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [backbutton setImage:[UIImage imageNamed:@"返回"] forState:(UIControlStateNormal)];
        [backbutton setImage:[UIImage imageNamed:@"backHighLight"] forState:(UIControlStateHighlighted)];
//        [backbutton setTitle:@"返回" forState:(UIControlStateNormal)];
        [backbutton setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        [backbutton setTitleColor:[UIColor redColor] forState:(UIControlStateHighlighted)];
        [backbutton sizeToFit];
        //        这句代码在sizeToFit后面
        backbutton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        [backbutton addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backbutton];
        
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    //    设置所有控制器，在push
    [super pushViewController:viewController animated:animated];
    
    
}
- (void)back{
    [self popViewControllerAnimated:YES];
}



#pragma mark------UIGestureRecognizerDelegate

//手势识别器对象会调用这个代理方法来决定手势是否有效

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{

    
    //    手势只要不是在主控制器的时候，就有效
    return self.childViewControllers.count > 1;
}

@end
