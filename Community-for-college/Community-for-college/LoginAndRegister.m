//
//  LoginAndRegister.m
//  Community-for-college
//
//  Created by 夏夕空 on 16/8/20.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "LoginAndRegister.h"
#import "NSObject+alertView.h"
@interface LoginAndRegister ()

@end

@implementation LoginAndRegister

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
    UIButton*backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [backButton setImage:[UIImage imageNamed:@"返回"] forState:(UIControlStateNormal)];
    [backButton addTarget:self action:@selector(backButton:) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationController.navigationBar.barTintColor  = [UIColor colorWithRed:245.0/255 green:88.0/255 blue:135.0/255 alpha:1];
}

- (void)backButton:(UIButton*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Login:(UIButton *)sender {
    
    BOOL result = NO;
    NSUserDefaults*user = [NSUserDefaults standardUserDefaults];
    NSArray*array = [user objectForKey:@"userArray"];
    int i = 0;
    for (NSDictionary*dic in array) {
        
        NSString*userName = dic[[NSString stringWithFormat:@"userName%d",i]];
        NSString*passWord = dic[[NSString stringWithFormat:@"passWord%d",i]];
        if ([userName isEqualToString:_userName.text] && [passWord isEqualToString:_passWord.text]) {
            NSUserDefaults*user = [NSUserDefaults standardUserDefaults];
            [user setObject:userName forKey:@"name"];
            [user setObject:passWord forKey:@"passWord"];
            [user synchronize];
            result = YES;
        }
        i ++;
    }
    if (result) {
        UIAlertController*controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"恭喜你！登陆成功啦！！" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction*action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
//            [[DataBaseHandel sharedDataBaseHandel] creatContext];
//            NSLog(@"%@",NSHomeDirectory());
        }];
        [controller addAction:action];
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        
        UIAlertController*controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名或密码错误" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction*action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
        [controller addAction:action];
        [self presentViewController:controller animated:YES completion:nil];
    }
    

}

- (IBAction)register:(UIButton *)sender {
    NSUserDefaults*user = [NSUserDefaults standardUserDefaults];
    //    NSArray*insert = [NSArray array];
    //    [user setObject:insert forKey:@"userArray"];
    NSArray*oldArray = [user objectForKey:@"userArray"];
    
    NSMutableArray*mutableArray = [NSMutableArray arrayWithArray:oldArray];
    NSString*userName = _userName.text;
    NSString*passWord = _passWord.text;
    int i = 0;
    BOOL same = NO;
    for (NSDictionary*dic in mutableArray) {
        if ([_userName.text isEqualToString:dic[[NSString stringWithFormat:@"userName%d",i]]]) {
            same = YES;
        }
        i ++;
    }
    
    if (same) {
        UIAlertController*controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"此用户名称已被占用！！" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction*action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
        [controller addAction:action];
        [self presentViewController:controller animated:YES completion:nil];
    }else  if(_userName.text.length == 0 || _passWord.text.length == 0){
        [NSObject alterString:@"用户名或密码不能为空！"];
    }else if (_passWord.text.length < 6){
        [NSObject alterString:@"密码过于简单请重新输入"];
    }else
       {
        NSInteger number = oldArray.count;
        NSString*userNameKey = [NSString stringWithFormat:@"userName%ld",number];
        NSString*passWordKey = [NSString stringWithFormat:@"passWord%ld",number];
        NSDictionary*dic = @{userNameKey:userName,passWordKey:passWord};
        [mutableArray addObject:dic];
        NSArray*userArray = [NSArray arrayWithArray:mutableArray];
        
        [user setObject:userArray forKey:@"userArray"];
 
        UIAlertController*controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"注册成功" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction*action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
        [controller addAction:action];
        [self presentViewController:controller animated:YES completion:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    }

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
