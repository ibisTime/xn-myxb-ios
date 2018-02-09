//
//  InviteVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/7.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "InviteVC.h"

//Macro
//Framework
//Category
#import "UIBarButtonItem+convience.h"
//Extension
//M
//V
//C
@interface InviteVC ()

@end

@implementation InviteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"邀请好友";
    
    [self setBarButtonItem];

}
#pragma mark - Init
- (void)setBarButtonItem {
    
    //取消按钮
    [UIBarButtonItem addLeftItemWithImageName:kCancelIcon frame:CGRectMake(-30, 0, 80, 44) vc:self action:@selector(back)];
}

#pragma mark - Events

- (void)back {
    
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
