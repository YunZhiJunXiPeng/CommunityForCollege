//
//  personalViewController.m
//  Community-for-college
//
//  Created by 夏夕空 on 16/8/23.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "personalViewController.h"
#import "PersonalTableViewCell.h"

@interface personalViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView*tableView;
@property (strong,nonatomic) NSMutableArray*dataArray1;
@property (strong,nonatomic) NSMutableArray*dataArray2;
@end

@implementation personalViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"详细资料";
    
     _dataArray1 = @[@[@"开发人员",@"性别",@"团队名程",@"团队年龄",@"项目名称"],@[@"职业",@"公司",@"所在地",@"故乡",@"版本"]].mutableCopy;
    _dataArray2 = @[@[@"梁海洋、郭佳、彭鑫、张志博",@"男",@"NewBee",@"1岁",@"大学社区"],@[@"iOS开发工程师",@"NewBee",@"Beijing - 北京",@"China",@"-1.0"]].mutableCopy;
    UITableView*tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStyleGrouped)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView = tableView;
    
    [tableView registerClass:[PersonalTableViewCell class] forCellReuseIdentifier:@"identifier"];
    [self.view addSubview:tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray1.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray1[section] count];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    NSArray*array = _dataArray1[indexPath.section];
    cell.label1.text = array[indexPath.row];
    cell.label1.font = [UIFont systemFontOfSize:16];
    cell.label2.text = _dataArray2[indexPath.section][indexPath.row];
    cell.label2.font = [UIFont systemFontOfSize:14];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}











- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
