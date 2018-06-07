//
//  TreeMaoVC.m
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/6.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TreeMaoVC.h"

@interface TreeMaoVC ()

@end

@implementation TreeMaoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"网络图谱";
    
    [self requestTreeMap];
}
- (void)requestTreeMap
{
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"805146";
    http.parameters[@"userId"] = [TLUser user].userId;
   
    
    [http postWithSuccess:^(id responseObject) {
        
        
    } failure:^(NSError *error) {
        
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
