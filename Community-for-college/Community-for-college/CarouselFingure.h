//
//  ViewController.m
//  UI_les_6_封装轮播图
//
//  Created by 电竞李易峰 on 16/6/6.
//  Copyright © 2016年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CarouselFingure;

@protocol CarouselFingureDelegate <NSObject>

@optional

//carouselFingure当前轮播图   index:被点击的轮播图对应的下标
- (void)carouselFingureDidCarousel:(CarouselFingure *)carouselFingure atIndex:(NSUInteger)index;

@end


@interface CarouselFingure : UIView

///图片数组
@property (strong , nonatomic)NSArray *imagesArray;

///时间间隔
@property (assign , nonatomic)NSTimeInterval duration;

///当前下标
@property (assign , nonatomic)NSUInteger currentIndex;

///代理对象
@property (strong , nonatomic)id<CarouselFingureDelegate> delegate;



@end
