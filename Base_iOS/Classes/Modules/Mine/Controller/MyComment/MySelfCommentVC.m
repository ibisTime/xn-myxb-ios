//
//  MySelfCommentVC.m
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/11.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "MySelfCommentVC.h"

#import "MyCommentListVC.h"

@interface MySelfCommentVC ()

@end

@implementation MySelfCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我收到的评论";

    // Do any additional setup after loading the view.
    MyCommentListVC *comment = [[MyCommentListVC alloc]init];
    comment.isMySelf = YES;
    
    comment.view.frame = CGRectMake(0, 1, kScreenWidth, kSuperViewHeight);

    [self.view addSubview:comment.view];
    
    [self addChildViewController:comment];
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
