//
//  IntegralGoodDetailVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "IntegralGoodDetailVC.h"

//Macro
//Framework
//Category
#import "UIControl+Block.h"
#import "NSString+Check.h"
//Extension
//M
#import "ZHReceivingAddress.h"
//V
#import "IntegralGoodHeaderView.h"
#import "DetailWebView.h"
#import "IntegralExchangeView.h"
//C
#import "ZHAddressChooseVC.h"
#import "TLUserLoginVC.h"
#import "NavigationController.h"
#import "IntegralOrderVC.h"

@interface IntegralGoodDetailVC ()
//
@property (nonatomic, strong) IntegralGoodHeaderView *headerView;
//
@property (nonatomic, strong) IntegralModel *good;
//
@property (nonatomic, strong) UIView *contentView;
//产品名称
@property (nonatomic, strong) UILabel *nameLbl;
//图文详情
@property (nonatomic, strong) DetailWebView *detailWebView;
//
@property (nonatomic, strong) UIView *bottomView;
//兑换
@property (nonatomic, strong) IntegralExchangeView *exchangeView;
//
@property (nonatomic,strong) ZHReceivingAddress *currentAddress;

@end

@implementation IntegralGoodDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品详情";
    
    //获取产品详情
    [self requestGoodDetail];
}

#pragma mark - Init
- (void)initHeaderView {
    //ScrollView
    self.bgSV.frame = CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - (60 + kBottomInsetHeight));
    
    [self.view addSubview:self.bgSV];
    //Header
    self.headerView = [[IntegralGoodHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    
    self.headerView.good = self.good;
    
    [self.bgSV addSubview:self.headerView];
}

- (void)initContentView {
    
    BaseWeakSelf;
    
    CGFloat leftMargin = 15;
    //
    self.contentView = [[UIView alloc] init];
    
    self.contentView.backgroundColor = kWhiteColor;
    
    [self.bgSV addSubview:self.contentView];
    //text
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    textLbl.text = @"商品名称";
    
    [self.contentView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(leftMargin));
        make.top.equalTo(@30);
    }];
    //产品名称
    self.nameLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor clearColor]
                                      font:Font(15.0)
                                 textColor:kTextColor];
    
    self.nameLbl.numberOfLines = 0;
    self.nameLbl.text = [NSString stringWithFormat:@"【 %@ 】", self.good.name];
    
    [self.contentView addSubview:self.nameLbl];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(textLbl.mas_left).offset(-5);
        make.top.equalTo(textLbl.mas_bottom).offset(11);
    }];
    //图文详情
    self.detailWebView = [[DetailWebView alloc] initWithFrame:CGRectMake(0, self.headerView.yy + 90, kScreenWidth, 40)];
    
    [self.detailWebView loadWebWithString:_good.desc];
    
    self.detailWebView.webViewBlock = ^(CGFloat height) {
        
        [weakSelf setSubViewLayoutWithHeight:height];
    };
    
    [self.contentView addSubview:self.detailWebView];
}

- (void)initBottomView {
    
    CGFloat viewH = 60 + kBottomInsetHeight;
    //
    self.bottomView = [[UIView alloc] init];
    
    self.bottomView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.equalTo(@0);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@(viewH));
    }];
    
    //我要兑换
    UIButton *exchangeBtn = [UIButton buttonWithTitle:@"我要兑换"
                                           titleColor:kWhiteColor
                                      backgroundColor:kThemeColor
                                            titleFont:16.0
                                         cornerRadius:7.5];
    
    [exchangeBtn addTarget:self action:@selector(exchange) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:exchangeBtn];
    [exchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@8);
        make.left.equalTo(@15);
        make.height.equalTo(@(44));
        make.width.equalTo(@(kScreenWidth - 30));
    }];
}

/**
 调整视图高度
 */
- (void)setSubViewLayoutWithHeight:(CGFloat)height {
    
    self.detailWebView.webView.scrollView.height = height;
    [self.detailWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.top.equalTo(self.nameLbl.mas_bottom).offset(20);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@(height));
    }];
    
    [self.bgSV layoutIfNeeded];
    
    self.contentView.frame = CGRectMake(0, self.headerView.yy, kScreenWidth, self.detailWebView.yy + 24);
    self.bgSV.contentSize = CGSizeMake(kScreenWidth, self.contentView.yy);
}

- (IntegralExchangeView *)exchangeView {
    
    BaseWeakSelf;
    
    if (!_exchangeView) {
        
        _exchangeView = [[IntegralExchangeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        _exchangeView.exchangeBlock = ^(ExchangeTyep type) {
            
            [weakSelf exchangeEventsWithType:type];
            
        };
        
        [self.view addSubview:_exchangeView];
    }
    return _exchangeView;
}

#pragma mark - Events

/**
 兑换
 */
- (void)exchange {
    
    BaseWeakSelf;
    
    if (![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
        
        loginVC.loginSuccess = ^(){
            
            [weakSelf exchange];
        };
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        
        return;
    }
    
    [self.exchangeView show];
}

- (void)exchangeEventsWithType:(ExchangeTyep)type {
    
    BaseWeakSelf;
    
    switch (type) {
        case ExchangeTyepExchange:
        {
            //兑换产品
            [self exchangeGood];
            
        }break;
            
        case ExchangeTyepSelectAddress:
        {
            
            ZHAddressChooseVC *chooseVC = [[ZHAddressChooseVC alloc] init];
            //    chooseVC.addressRoom = self.addressRoom;
            //            chooseVC.selectedAddrCode = self.currentAddress.code;
            
            chooseVC.chooseAddress = ^(ZHReceivingAddress *addr){
                
                weakSelf.currentAddress = addr;
                [weakSelf setHeaderAddress:addr];
                
            };
            
            [self.navigationController pushViewController:chooseVC animated:YES];
        }break;
            
        default:
            break;
    }
}

- (void)setHeaderAddress:(ZHReceivingAddress *)address {
    
    [self.exchangeView show];
    
    self.exchangeView.nameTF.text = [NSString stringWithFormat:@"%@",address.addressee];
    self.exchangeView.mobileTF.text = [NSString stringWithFormat:@"%@",address.mobile];
    self.exchangeView.addressTF.text = [NSString stringWithFormat:@"%@%@%@%@",address.province,address.city, address.district, address.detailAddress];
}

#pragma mark - Data
- (void)requestGoodDetail {
    
    //    BaseWeakSelf;
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805286";
    http.parameters[@"code"] = self.code;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.good = [IntegralModel mj_objectWithKeyValues:responseObject[@"data"]];
        //头部
        [self initHeaderView];
        //图文详情
        [self initContentView];
        //
        [self initBottomView];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)exchangeGood {
    
    BaseWeakSelf;
    
    
    if (![self.exchangeView.addressTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请选择收货地址"];
        return;
    }
    
    if (![self.exchangeView.nameTF.text valid]) {
        [TLAlert alertWithInfo:@"请输入正确的中文姓名"];
        return;
    }
    
    if (![self.exchangeView.mobileTF.text isPhoneNum]) {
        [TLAlert alertWithInfo:@"请输入正确的手机号码"];
        return;
    }
    
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805290";
    http.showView = self.view;
    http.parameters[@"productCode"] = self.code;
    http.parameters[@"applyUser"] = [TLUser user].userId;
    http.parameters[@"quantity"] = @"1";
    http.parameters[@"reAddress"] = self.exchangeView.addressTF.text;
    http.parameters[@"reMobile"] = self.exchangeView.mobileTF.text;
    http.parameters[@"receiver"] = self.exchangeView.nameTF.text;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"兑换成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            IntegralOrderVC *orderVC = [IntegralOrderVC new];
            
            [weakSelf.navigationController pushViewController:orderVC animated:YES];
        });
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
