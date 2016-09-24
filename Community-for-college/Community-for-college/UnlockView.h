//
//  UnlockView.h
//  连线解锁Demo
//
//  Created by 卖女孩的小火柴 on 16/7/17.
//  Copyright © 2016年 梁海洋. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UnlockView;
@protocol UnlockViewDelegate <NSObject>

- (void)UnlockView:(UnlockView *)unlockView
       getPassword:(NSString*)UnlockPassword;

@end

@interface UnlockView : UIView


@property (nonatomic,assign)id<UnlockViewDelegate>delegate;

@end
