//
//  ViewController.m
//  UI_les_6_封装轮播图
//
//  Created by 电竞李易峰 on 16/6/6.
//  Copyright © 2016年 lanou3g. All rights reserved.
//

#import "CarouselFingure.h"
#import <UIImageView+WebCache.h>
@interface CarouselFingure ()<UIScrollViewDelegate>

@property (strong , nonatomic) UIScrollView * scrollView;
@property (strong , nonatomic) UIPageControl * pageControl;
@property (strong , nonatomic) NSTimer * timer;

@end

@implementation CarouselFingure

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        创建timer
        _timer = [[NSTimer alloc] init];
//        设置默认轮播切换等待时间
        _duration = 4;
    }
    return self;
}

#pragma mark --赋值方法--
- (void)setImagesArray:(NSArray *)imagesArray
{
    //    停止timer的操作
    [self.timer invalidate];
    self.timer = nil;
    
    _imagesArray = imagesArray;
    [self drawView];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.duration target:self selector:@selector(carouselFromTimer:) userInfo:self repeats:YES];
}

- (void)setDuration:(NSTimeInterval)duration
{
    [self.timer invalidate];
    self.timer = nil;
    _duration = duration;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:_duration target:self selector:@selector(carouselFromTimer:) userInfo:self repeats:YES];
}




- (UIScrollView *)scrollView
{
    if (_scrollView  == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.frame.size.width * self.imagesArray.count, self.frame.size.height);
        for (int i = 0; i < self.imagesArray.count; i++) {
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
//            用户交互开关
            imageView.userInteractionEnabled = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.imagesArray[i]]];
            imageView.tag = 1000 + i;
            //            添加手势
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [imageView addGestureRecognizer:tap];
            
            [_scrollView addSubview:imageView];
        }
    }
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.frame.size.width - 150, self.frame.size.height - 40, 150, 40)];
//        numberofpages与图片数量一致
        _pageControl.numberOfPages = self.imagesArray.count;
        _pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    }
    return _pageControl;
}

#pragma mark UI绘制
- (void)drawView
{
    //    将绘制好的视图添加在父视图上
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
}


#pragma mark --tap手势触发方法--
- (void)tapAction: (UITapGestureRecognizer *)tap
{
    NSUInteger index = tap.view.tag - 1000;
//    将当前的轮播图和当前轮播图下标传递给外界
    if (_delegate != nil && [_delegate respondsToSelector:@selector(carouselFingureDidCarousel:atIndex:)]) {
        [_delegate carouselFingureDidCarousel:self atIndex:index];
    }
}

#pragma mark --代理方法--
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    开始拖动，timer暂停
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.timer = nil;
//    根据人为拖拽来调整pageControl的当前页
    self.pageControl.currentPage = self.scrollView.contentOffset.x / self.frame.size.width;
//    修正当前下标
    self.currentIndex = self.pageControl.currentPage;
//    启动timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.duration target:self selector:@selector(carouselFromTimer:) userInfo:self repeats:YES];
}

#pragma mark --Timer驱动轮播方法--
- (void)carouselFromTimer:(id)sender
{
    self.currentIndex ++;
    if (self.currentIndex == self.imagesArray.count) {
        self.currentIndex = 0;
    }
    self.pageControl.currentPage = self.currentIndex;
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width * self.currentIndex, 0) animated:YES];
}



@end


