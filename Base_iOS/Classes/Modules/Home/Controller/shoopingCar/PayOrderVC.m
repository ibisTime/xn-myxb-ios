//
//  PayOrderVC.m
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/4.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PayOrderVC.h"
#import "UIControl+Block.h"
#import "BrandOrderVC.h"
@interface PayOrderVC ()
@property (nonatomic , strong)UIButton *xiaobangJuanBtn;
@property (nonatomic , strong)UIButton *xiaobangBtn;
@property (nonatomic , assign)BOOL isFirst;
@end

@implementation PayOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isFirst = YES;
    self.title = @"支付";
    [self creatUpclass];
    [self initSubviews];
}
- (void)creatUpclass
{
    UILabel *payTpteLabel = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor2
                                                font:14.0];
    payTpteLabel.numberOfLines = 0;
    payTpteLabel.text = @"支付方式";
    payTpteLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:payTpteLabel];
    
    [payTpteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.right.equalTo(@10);
        make.height.mas_equalTo(15);
    }];
    
    UIView *lineview = [[UIView alloc]init];
    lineview.backgroundColor = kSilverGreyColor;
    [self.view addSubview:lineview];
    
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(payTpteLabel.mas_bottom).with.offset(10);
        make.height.mas_equalTo(.5);
    }];
    
    
    UIImageView *oneimage = [[UIImageView alloc]init];
    oneimage.image = kImage(@"积分");
    [self.view addSubview:oneimage];
    
    [oneimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(lineview.mas_bottom).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    UILabel *xiaobangLable = [UILabel labelWithBackgroundColor:kClearColor textColor:[UIColor blackColor] font:17];
    xiaobangLable.text = [NSString stringWithFormat:@"销帮币(%@)",[TLUser user].rmbamount];
    [self.view addSubview:xiaobangLable];
    [xiaobangLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oneimage.mas_right).with.offset(5);
        make.centerY.equalTo(oneimage.mas_centerY);
        make.height.equalTo(@18);
    }];
    
    UIImageView *twoimage = [[UIImageView alloc]init];
    twoimage.image = kImage(@"积分");
    [self.view addSubview:twoimage];
    
    [twoimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(oneimage.mas_bottom).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    
    UILabel *xiaobangJuanLable = [UILabel labelWithBackgroundColor:kClearColor textColor:[UIColor blackColor] font:17];
    xiaobangJuanLable.text = [NSString stringWithFormat:@"销帮卷(%@)",[TLUser user].jfamount];
    [self.view addSubview:xiaobangJuanLable];
    [xiaobangJuanLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(twoimage.mas_right).with.offset(5);
        make.centerY.equalTo(twoimage.mas_centerY);
        make.height.equalTo(@18);
    }];
    
    
    
    self.xiaobangBtn = [UIButton buttonWithTitle:@""
                                       titleColor:kThemeColor
                                  backgroundColor:kClearColor
                                        titleFont:14.0];
    
    [self.xiaobangBtn bk_addEventHandler:^(id sender) {
        [self.xiaobangBtn setImage:kImage(@"选中YES") forState:UIControlStateNormal];
        [self.xiaobangJuanBtn setImage:kImage(@"未选中NO") forState:UIControlStateNormal];

    } forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:self.xiaobangBtn];
    [self.xiaobangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(oneimage.mas_centerY);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        self.isFirst = YES;
    }];
    [self.xiaobangBtn setImage:kImage(@"选中YES") forState:UIControlStateNormal];
    
    
    
    self.xiaobangJuanBtn = [UIButton buttonWithTitle:@""
                                           titleColor:kThemeColor
                                      backgroundColor:kClearColor
                                            titleFont:14.0];
    
    [self.xiaobangJuanBtn bk_addEventHandler:^(id sender) {
        [self.xiaobangJuanBtn setImage:kImage(@"选中YES") forState:UIControlStateNormal];
        [self.xiaobangBtn setImage:kImage(@"未选中NO") forState:UIControlStateNormal];
        self.isFirst = NO;

    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.xiaobangJuanBtn setImage:kImage(@"未选中NO") forState:UIControlStateNormal];

    
    [self.view addSubview:self.xiaobangJuanBtn];
    [self.xiaobangJuanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(twoimage.mas_centerY);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    

    
}
- (void)initSubviews {
    BaseWeakSelf;
    
    
    //顾问
    UIButton *chatBtn = [UIButton buttonWithTitle:self.priceText
                                       titleColor:kThemeColor
                                  backgroundColor:kWhiteColor
                                        titleFont:14.0];
    
    [chatBtn bk_addEventHandler:^(id sender) {
        //获取顾问手机号
        //        [self addToCar];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    //    [chatBtn setImage:kImage(@"顾问") forState:UIControlStateNormal];
    
    [self.view addSubview:chatBtn];
    [chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-kBottomInsetHeight);
        make.left.equalTo(self.view.mas_left);
        make.height.mas_equalTo(50);
        make.right.equalTo(self.view.mas_right).with.offset(-kScreenWidth/3);
    }];
    
    [chatBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    
    
    
    
    //确定下单
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"确定支付"
                                          titleColor:kWhiteColor
                                     backgroundColor:kThemeColor
                                           titleFont:18.0];
    
    [confirmBtn bk_addEventHandler:^(id sender) {
        
        [self payMoney];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    //    [confirmBtn setImage:kImage(@"顾问") forState:UIControlStateNormal];
    
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-kBottomInsetHeight);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(chatBtn.mas_right);
    }];
    
    [confirmBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    
   
    
}
- (void)payMoney
{
    BaseWeakSelf;
    //查询是否有收货地址
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805272";
    http.parameters[@"code"] = self.datacode;
    http.parameters[@"payType"] = self.isFirst ? @"1" : @"0";
    http.showView = self.view;
    [http postWithSuccess:^(id responseObject) {
        [TLAlert alertWithSucces:@"支付成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            BrandOrderVC *orderVC = [BrandOrderVC new];
            
            [weakSelf.navigationController pushViewController:orderVC animated:YES];
        });

        
       
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
