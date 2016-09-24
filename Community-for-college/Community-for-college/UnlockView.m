//
//  UnlockView.m
//  连线解锁Demo
//
//  Created by 卖女孩的小火柴 on 16/7/17.
//  Copyright © 2016年 梁海洋. All rights reserved.
//

#define SELFWIDTH self.frame.size.width
#define SELFHEIGHT self.frame.size.height
#import "UnlockView.h"

@interface UnlockView ()

//先定义几个属性
{
    //    判断开始是否选中了一个点
    BOOL _isSelectStartPoint;
    //    判断起点坐标
    CGPoint _StartPoint;
    //    判断终止坐标
    CGPoint _endPoint;
    
}
//记录路径的数组
@property (nonatomic,strong)NSMutableArray *dataArray;
//定义一个零时路径变量  用来接收中间游走的路径，这个不能放在路径的数组中去
@property (nonatomic,strong)UIBezierPath *tempPath;
@property (nonatomic,strong)NSMutableArray *runningViews;
@end

@implementation UnlockView
//初始化View
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self RedrawView];
         NSLog(@"%f",self.bounds.size.width);
    }
    return self;
}

//给数组写个懒加载方法
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
//绘制9个链接的点
- (void)RedrawView
{
    
    self.frame = CGRectMake(0, 0, 414, 500);
//    定义绘制点的高
    CGFloat Height = 50;
//    定义绘制点的宽
    CGFloat Width = 50;
//    定义列间距
    CGFloat lineSpace = (self.bounds.size.width - 150) / 4.0;
//    定义行间距
    CGFloat columnSpace = (SELFHEIGHT - 280) / 4.0;
//    循环定义9个点
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            UIView *addView = [[UIView alloc]initWithFrame:(CGRectMake(lineSpace + (lineSpace + 50) * j, 100 + columnSpace + (50 + columnSpace) * i, Height, Width))];
            //设置tag值，待会解锁要用
            addView.tag = 1001 + i*3 + j;
//            NSLog(@"%ld",addView.tag);
//            设置View为圆型
            addView.layer.cornerRadius = Height / 2;
            addView.backgroundColor = [UIColor cyanColor];
            [self addSubview:addView];
        }
    }
}

- (void)drawRect:(CGRect)rect
{
//    绘制所有路径
    for (UIBezierPath *bezierPath in self.dataArray) {
        bezierPath.lineWidth = 5;
        [bezierPath stroke];
    }
    //绘制临时路径
    self.tempPath.lineWidth = 5;
    [self.tempPath stroke];
}

//触摸开始的时候获取一个起始的点
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    首先清除dataArray的数据，这样就能满足再次点击的时候清除之前的链接路径了
    [self.dataArray removeAllObjects];
//    NSLog(@"lala");
//    让九个圆圈恢复原来的状态
    for (UIView *subView in self.subviews) {
//        开启交互
        subView.backgroundColor = [UIColor cyanColor];
        subView.userInteractionEnabled = 1;
        
    }
//    获取接触的第一个点
    _StartPoint = [touches.anyObject locationInView:self];
//    遍历一下看看起始点是否在九个圆圈的范围内
    for (UIView *subView in self.subviews) {
        if (CGRectContainsPoint(subView.frame, _StartPoint)) {
//            如果在九个圆圈范围内，更改颜色，表示选中状态
            subView.backgroundColor = [UIColor purpleColor];
//            记录一下，开始点已经确定
            _isSelectStartPoint = 1;
//            更改开始点的坐标
            _StartPoint = subView.center;
//            选中之后，取消用户交互
            subView.userInteractionEnabled = 0;
            
            self.runningViews = [NSMutableArray arrayWithCapacity:0];
            [self.runningViews addObject:subView];
//            NSLog(@"%@",self.runningViews);
        }
    }
    
}

//在移动的过程中获取点，进行连线
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    获取移动伪终点（假设点击的该点即为终点）
    _endPoint = [touches.anyObject locationInView:self];
//    检查看看开始的圆圈有没有被选中
    if (_isSelectStartPoint) {
//        创建临时路径
        self.tempPath = [UIBezierPath bezierPath];
//        设置路径起点
        [self.tempPath moveToPoint:_StartPoint];
//        将临时终点与起点链接起来
        [self.tempPath addLineToPoint:_endPoint];
//        判断终点是否在九个圈里面
        for (UIView *subView in self.subviews) {
            if (CGRectContainsPoint(subView.frame, _endPoint) && subView.userInteractionEnabled) {
//                改变颜色并关闭交互
                subView.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/256.0 green:(arc4random()%255)/256.0 blue:(arc4random()%255)/256.0 alpha:1];
                
                subView.userInteractionEnabled = 0;
                [self.runningViews addObject:subView];
                
//                重新规划路径
                self.tempPath = [UIBezierPath bezierPath];
//                给出路径起点
                [self.tempPath moveToPoint:_StartPoint];
                //将节点的中心点作为结束点
                [self.tempPath addLineToPoint:subView.center];
//            将路径存放到数组中
                [self.dataArray addObject:self.tempPath];
//               为找下一个圆圈位置做准备
                _StartPoint = subView.center;
                subView.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/256.0 green:(arc4random()%255)/256.0 blue:(arc4random()%255)/256.0 alpha:1];
            }
        }
        
    }
    
    //渲染
    [self setNeedsDisplay];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //清空当前路径
    self.tempPath = nil;
    //关闭用户交互
    _isSelectStartPoint = 0;
    //渲染
    [self setNeedsDisplay];
    
//    创建一个字符常量，记录view的tag值
    NSMutableString *tagStr = [NSMutableString new];
//    遍历tag值
    for (UIView *tempView in self.runningViews) {
        [tagStr appendFormat:@"%ld",tempView.tag - 1000];
    }
   
    if (tagStr && ![tagStr isEqualToString:@""])
    {
        
        [self.delegate UnlockView:self getPassword:tagStr];
        
        NSLog(@"********%@",tagStr);
    }
}

@end
