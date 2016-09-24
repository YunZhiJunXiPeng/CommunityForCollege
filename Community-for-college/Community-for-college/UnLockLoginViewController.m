//
//  UnLockLoginViewController.m
//  Community-for-college
//
//  Created by 卖女孩的小火柴 on 16/8/26.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "UnLockLoginViewController.h"
#import "UnlockView.h"
@interface UnLockLoginViewController ()<UnlockViewDelegate>

@property (nonatomic,strong)UnlockView *unLockLogin;

@end

@implementation UnLockLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _unLockLogin = [UnlockView new];
    self.unLockLogin.delegate = self;
    _unLockLogin.backgroundColor = [UIColor brownColor];
    self.view.backgroundColor = [UIColor cyanColor];
    [self.view insertSubview:_unLockLogin aboveSubview:self.view];
}

- (void)UnlockView:(UnlockView *)unlockView getPassword:(NSString *)UnlockPassword
{
    
    NSLog(@"%@",UnlockPassword);
    if ([UnlockPassword isEqualToString:@"159"]) {
        NSLog(@"哈哈，解锁了");
//        [self.unLockLogin removeFromSuperview];
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
