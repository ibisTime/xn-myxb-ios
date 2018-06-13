//
//  BrandBuyVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BrandBuyVC.h"

//Manager
#import "AppConfig.h"
//Category
#import "UIButton+EnLargeEdge.h"
#import "UIView+Extension.h"
#import "NSString+Check.h"
#import "UIControl+Block.h"

//V
#import "TLTextField.h"
#import "TLTextView.h"
#import "ZHAddressChooseView.h"
//C
#import "ZHAddressChooseVC.h"
#import "ZHAddAddressVC.h"
#import "BrandOrderVC.h"
#import "PayOrderVC.h"

@interface BrandBuyVC ()

@property (nonatomic,strong) UIView *headerView;
//下单数量
@property (nonatomic, strong) TLTextField *numTF;
//下单说明
@property (nonatomic, strong) TLTextView *remarkTV;
//地址列表
@property (nonatomic,strong) NSMutableArray <ZHReceivingAddress *>*addressRoom;
//默认地址
@property (nonatomic,strong) ZHReceivingAddress *currentAddress;
//
@property (nonatomic,strong) ZHAddressChooseView *chooseView;

@property (nonatomic,strong)UILabel *priceLabel;


@end

@implementation BrandBuyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"下单";
    
    //根据有无地址创建UI
    [self getAddress];
}


//
- (UIView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, kScreenWidth, 90)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
    
}
//
- (ZHAddressChooseView *)chooseView {
    
    if (!_chooseView) {
        
        __weak typeof(self) weakself = self;
        //头部有个底 可以添加，有地址时的ui和无地址时的ui
        _chooseView = [[ZHAddressChooseView alloc] initWithFrame:self.headerView.bounds];
        _chooseView.chooseAddress = ^(){
            
            [weakself chooseAddress];
        };
    }
    return _chooseView;
    
}

- (void)initSubviews {
    
    //地址
    [self.view addSubview:self.headerView];
    //下单数量
    self.numTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 50)
                                          leftTitle:@"下单数量"
                                         titleWidth:100
                                        placeholder:@"请输入数量"];
    
    self.numTF.keyboardType = UIKeyboardTypeNumberPad;
    self.numTF.text = @"1";
    [self.view addSubview:self.numTF];
    
    self.priceLabel = [UILabel labelWithBackgroundColor:kWhiteColor textColor:kThemeColor font:15];
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥:%@",self.price];
    [self.numTF addSubview:self.priceLabel];
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.numTF.mas_right).with.offset(-30);
        make.top.equalTo(self.numTF.mas_top);
        make.bottom.equalTo(self.numTF.mas_bottom);
        make.width.equalTo(@100);
    }];
    
    //下单说明
    self.remarkTV = [[TLTextView alloc] initWithFrame:CGRectMake(0, self.numTF.yy + 10, kScreenWidth, 180)];
    
    self.remarkTV.placeholderLbl.origin = CGPointMake(15, 15);
    self.remarkTV.placeholderLbl.font = Font(13.0);
    self.remarkTV.textContainerInset = UIEdgeInsetsMake(17, 10, 0, 0);
    self.remarkTV.placholder = @"下单说明";
    
    [self.view addSubview:self.remarkTV];
    
    
    BaseWeakSelf;
    //顾问
    UIButton *chatBtn = [UIButton buttonWithTitle:@"加入购物车"
                                       titleColor:kTextColor
                                  backgroundColor:kWhiteColor
                                        titleFont:18.0];
    
    [chatBtn bk_addEventHandler:^(id sender) {
        //获取顾问手机号
        [self addToCar];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
//    [chatBtn setImage:kImage(@"顾问") forState:UIControlStateNormal];
    
    [self.view addSubview:chatBtn];
    [chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-kBottomInsetHeight);
        make.left.equalTo(self.view.mas_left);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(kScreenWidth/2);
    }];
    
    [chatBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];

    
    
    
    //确定下单
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"确定下单"
                                       titleColor:kWhiteColor
                                  backgroundColor:kThemeColor
                                        titleFont:18.0];
    
    [confirmBtn bk_addEventHandler:^(id sender) {
        [weakSelf confirmBuy];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
//    [confirmBtn setImage:kImage(@"顾问") forState:UIControlStateNormal];
    
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-kBottomInsetHeight);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(kScreenWidth/2);
    }];
    
    [confirmBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    
}

//#pragma mark- 有收获地址时的头部UI
- (void)setHaveAddressUI {
    
    if (self.headerView.subviews.count > 0) {
        
        [self.headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        [self.view addSubview:self.headerView];
    }
    [self.headerView addSubview:self.chooseView];
    
}

#pragma mark- 设置没有收货地址的UI
- (void)setNOAddressUI {
    
    //  [self.headerView.subviews performSelector:@selector(removeFromSuperview)];
    
    UIView *addressView = self.headerView;
    
    [self.view addSubview:addressView];
    
    UIImageView *noAddressImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9, 35, 35)];
    [addressView addSubview:noAddressImageV];
    
    //-==-//
    noAddressImageV.centerX = kScreenWidth/2.0;
    noAddressImageV.image = [UIImage imageNamed:@"添加收获地址"];
    
    //btn
    UIButton *addBtn = [UIButton buttonWithTitle:@"+ 添加" titleColor:kAppCustomMainColor backgroundColor:kClearColor titleFont:11.0 cornerRadius:3];
    
    addBtn.frame = CGRectMake(kScreenWidth/2.0 + 25, noAddressImageV.yy + 9, 58, 21);
    
    [addBtn setEnlargeEdge:20];
    
    [addBtn addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    
    [addBtn drawAroundLine:4
               lineSpacing:2
                 lineColor:kAppCustomMainColor];
    
    [addressView addSubview:addBtn];
    
    //
    UILabel *hintLbl = [UILabel labelWithFrame:CGRectMake(0, 0, kScreenWidth/2.0 + 3, addBtn.height) textAligment:NSTextAlignmentRight
                               backgroundColor:[UIColor whiteColor]
                                          font:Font(13)
                                     textColor:kTextColor];
    [addressView addSubview:hintLbl];
    hintLbl.text = @"还没有收货地址";
    hintLbl.centerY = addBtn.centerY;
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _headerView.width, 2)];
    [_headerView addSubview:line];
    line.y = _headerView.height - 2;
    line.image = [UIImage imageNamed:@"address_line"];
    
}

#pragma mark - Events
- (void)confirmBuy {
    
    BaseWeakSelf;
    
    if (!self.currentAddress) {
        
        [TLAlert alertWithInfo:@"请选择收货地址"];
        return;
    }
    
    
    if ([self.numTF.text isEqualToString:@"0"]) {
        
        [TLAlert alertWithInfo:@"请输入正确的下单数量"];
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"805270";
    http.parameters[@"productCode"] = self.code;
    
    http.parameters[@"quantity"] = self.numTF.text;
    
    http.parameters[@"receiver"] = self.currentAddress.addressee;
    http.parameters[@"reAddress"] = self.currentAddress.totalAddress;
    http.parameters[@"reMobile"] = self.currentAddress.mobile;
    
    http.parameters[@"applyUser"] = [TLUser user].userId;
//    http.parameters[@"companyCode"] = [AppConfig config].companyCode;
//    http.parameters[@"systemCode"] = [AppConfig config].systemCode;
    
    //根据收货地址
    NSString *note = [self.remarkTV.text valid] ? self.remarkTV.text: @"无";
    
    http.parameters[@"applyNote"] = note;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *str = @"";
        if ([[TLUser user].kind isEqualToString:kUserTypePartner]) {
            str = @"下单成功";
        }
        else
        {
            str = @"下单成功, 平台将对你的订单进行审核";
        }
        
        
        [TLAlert alertWithSucces:str];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            PayOrderVC *payorder = [[PayOrderVC alloc]init];
            payorder.datacode = responseObject[@"data"];
            payorder.priceText = [NSString stringWithFormat:@"支付金额:¥%@",self.price];
            [self.navigationController pushViewController:payorder animated:YES];
            
//            BrandOrderVC *orderVC = [BrandOrderVC new];
//            
//            [weakSelf.navigationController pushViewController:orderVC animated:YES];
        });
        
    } failure:^(NSError *error) {
        
    }];
    
    return;
}
- (void)addToCar
{
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805290";
    http.showView = self.view;
    http.parameters[@"productCode"] = self.code;
    http.parameters[@"quantity"] = self.numTF.text;
    http.parameters[@"userId"] = [TLUser user].userId;

   
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"操作成功"];
        
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - Data
- (void)getAddress {
    
    //查询是否有收货地址
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805165";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"isDefault"] = @"1"; //是否为默认收货地址
    
    [http postWithSuccess:^(id responseObject) {
        
        [self initSubviews];

        NSArray *adderssRoom = responseObject[@"data"];
        
        if (adderssRoom.count > 0) { //有收获地址
            
            self.addressRoom = [ZHReceivingAddress tl_objectArrayWithDictionaryArray:adderssRoom];
            //给一个默认地址
            self.currentAddress = self.addressRoom[0];
            self.currentAddress.isSelected = YES;
            
            [self setHeaderAddress:self.currentAddress];
            
            
        } else { //没有收货地址，展示没有的UI
            
            self.addressRoom = [NSMutableArray array];
            
            [self.headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            [self setNOAddressUI];
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)setHeaderAddress:(ZHReceivingAddress *)address {
    
    [self setHaveAddressUI];
    
    self.chooseView.nameLbl.text = [NSString stringWithFormat:@"收货人：%@",address.addressee];
    self.chooseView.mobileLbl.text = [NSString stringWithFormat:@"%@",address.mobile];
    self.chooseView.addressLbl.text = [NSString stringWithFormat:@"收货地址：%@%@%@·%@",address.province,address.city, address.district, address.detailAddress];
}

#pragma mark- 前往地址
- (void)chooseAddress {
    
    BaseWeakSelf;
    
    ZHAddressChooseVC *chooseVC = [[ZHAddressChooseVC alloc] init];
    //    chooseVC.addressRoom = self.addressRoom;
    chooseVC.selectedAddrCode = self.currentAddress.code;
    
    chooseVC.chooseAddress = ^(ZHReceivingAddress *addr){
        
        weakSelf.currentAddress = addr;
        [weakSelf setHeaderAddress:addr];
        
    };
    
    [self.navigationController pushViewController:chooseVC animated:YES];
}

#pragma mark- 原来无地址，现在添加地址
- (void)addAddress {
    
    BaseWeakSelf;
    
    ZHAddAddressVC *addressVC = [[ZHAddAddressVC alloc] init];
    
    addressVC.addressType = AddressTypeAdd;
    
    addressVC.addAddress = ^(ZHReceivingAddress *address){
        
        //原来无地址, 现在又地址
        weakSelf.currentAddress = address;
        [weakSelf setHeaderAddress:address];
        [weakSelf.addressRoom addObject:address];
    };
    [self.navigationController pushViewController:addressVC animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
