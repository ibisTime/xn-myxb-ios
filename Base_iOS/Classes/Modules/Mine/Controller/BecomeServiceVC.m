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
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic , copy)NSString *payMoney;

@end

@implementation BecomeServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"签约";
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectZero]; //初始化大小并自动释放
    
    self.textView.textColor = [UIColor blackColor];//设置textview里面的字体颜色
    
    self.textView.font = [UIFont fontWithName:@"Arial" size:18.0];//设置字体名字和字体大小
    
//    self.textView.delegate = self;//设置它的委托方法
    
    self.textView.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
    
    
    
    
    self.textView.returnKeyType = UIReturnKeyDefault;//返回键的类型
    
    self.textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    
    self.textView.scrollEnabled = YES;//是否可以拖动
    
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    
    [self.view addSubview: self.textView];//加入到整个页面中
    
    UIButton *agree = [UIButton buttonWithTitle:@"我已知晓,开始支付" titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:18.0];
    [agree bk_addEventHandler:^(id sender) {
        TopUpVC *pay = [[TopUpVC alloc]init];
        pay.isPayExperts = YES;
        pay.deductAmount = self.payMoney;
//        pay.datacode = self.order.code;
        [self.navigationController pushViewController:pay animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agree];
    [agree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-kBottomInsetHeight);
        make.height.mas_equalTo(50);
        
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.bottom.equalTo(agree.mas_top);
    }];
    //获取门槛费
    [self requestMoney];
    
    [self requestContract];
}
- (void)requestContract
{
    TLNetworking *http = [TLNetworking new];
    http.code = @"805917";
    http.showView = self.view;
    
    if ([[TLUser user].kind isEqualToString:kUserTypeBeautyGuide])
    {
        http.parameters[@"ckey"] = @"FWS_CONTRACT";

    }
    else
    {
        http.parameters[@"ckey"] = @"JXS_CONTRACT";

    }
    
    [http postWithSuccess:^(id responseObject) {
        NSLog(@"--->%@",responseObject);
        self.textView.text = responseObject[@"data"][@"remark"];
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestMoney
{
    TLNetworking *http = [TLNetworking new];
    http.code = @"805917";
    http.showView = self.view;
    
    if ([[TLUser user].kind isEqualToString:kUserTypeBeautyGuide])
    {
        http.parameters[@"ckey"] = @"SG_MD_PAY_AMOUNT";
        
    }
    else
    {
        http.parameters[@"ckey"] = @"SG_MRY_PAY_AMOUNT";
        
    }
    
    [http postWithSuccess:^(id responseObject) {
        self.payMoney = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"cvalue"]];
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
