//
//  BecomeServiceVC.m
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/13.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BecomeServiceVC.h"
#import "UIControl+Block.h"
#import "TopUpVC.h"

@interface BecomeServiceVC ()

@end

@implementation BecomeServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"签约";
    
    UIButton *agree = [UIButton buttonWithTitle:@"我已知晓,开始支付" titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:18.0];
    [agree bk_addEventHandler:^(id sender) {
        TopUpVC *pay = [[TopUpVC alloc]init];
        pay.isPayExperts = YES;
        pay.deductAmount = @"1000";
//        pay.datacode = self.order.code;
        [self.navigationController pushViewController:pay animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agree];
    [agree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-kBottomInsetHeight);
        make.height.mas_equalTo(50);
        
    }];
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
