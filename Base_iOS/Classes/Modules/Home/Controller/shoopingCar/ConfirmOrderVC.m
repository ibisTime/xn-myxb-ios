//
//  ConfirmOrderVC.m
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/4.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ConfirmOrderVC.h"

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
#import "BrandListCell.h"

//model
#import "ZHReceivingAddress.h"

#import "ZHAddressChooseVC.h"

#import "PayOrderVC.h"


@interface ConfirmOrderVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIView *headerView;

//地址列表
@property (nonatomic,strong) NSMutableArray <ZHReceivingAddress *>*addressRoom;
//默认地址
@property (nonatomic,strong) ZHReceivingAddress *currentAddress;

@property (nonatomic,strong) ZHAddressChooseView *chooseView;
@property (nonatomic,strong)UITableView *tableview;

@property (nonatomic , copy)NSString *priceText;

//下单说明
@property (nonatomic, strong) TLTextView *remarkTV;
@end

@implementation ConfirmOrderVC

static NSString *identifierCell = @"BrandListCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"下单";
    
    float priceA = 0.00;

    for (ShopCarModel *model in self.brands) {
        
        if (model.isChouse) {
            priceA +=  [[model.product[@"price"]convertToRealMoney] floatValue] *[model.quantity integerValue];
            
        }
        
    }
    self.priceText = [NSString stringWithFormat:@"总计:%.2f",priceA];
    
    
    //根据有无地址创建UI
    [self getAddress];
}
#pragma mark - Init
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
#pragma mark - Init
- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        [_tableview registerClass:[BrandListCell class] forCellReuseIdentifier:identifierCell];

        [self.view addSubview:_tableview];
    }
    return _tableview;
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
- (void)initSubviews {
    BaseWeakSelf;
    
    [self.view addSubview:self.headerView];

    
    
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
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(confirmBtn.mas_top);
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
        
        self.tableview.tableHeaderView = self.headerView;

        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)setHeaderAddress:(ZHReceivingAddress *)address {
    
    [self setHaveAddressUI];
    
    self.chooseView.nameLbl.text = [NSString stringWithFormat:@"收货人：%@",address.addressee];
    self.chooseView.mobileLbl.text = [NSString stringWithFormat:@"%@",address.mobile];
    self.chooseView.addressLbl.text = [NSString stringWithFormat:@"收货地址：%@%@%@·%@",address.province,address.city, address.district, address.detailAddress];
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

#pragma mark = UITableviewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.brands.count;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        BrandListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.shopModel = self.brands[indexPath.row];
        
        return cell;
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 140;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //下单说明
    self.remarkTV = [[TLTextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
    
    self.remarkTV.placeholderLbl.origin = CGPointMake(15, 15);
    self.remarkTV.placeholderLbl.font = Font(13.0);
    self.remarkTV.textContainerInset = UIEdgeInsetsMake(17, 10, 0, 0);
    self.remarkTV.placholder = @"下单说明";
    return self.remarkTV;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 180;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Events
- (void)confirmBuy {
    
    BaseWeakSelf;
    
    if (!self.currentAddress) {
        
        [TLAlert alertWithInfo:@"请选择收货地址"];
        return;
    }
    NSMutableArray *codeArry = [NSMutableArray arrayWithCapacity:0];
    for (ShopCarModel *model in self.brands) {
        
        [codeArry addObject:model.code];
        
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"805271";
    http.parameters[@"cartCodeList"] = codeArry;
    
    http.parameters[@"receiver"] = self.currentAddress.addressee;
    http.parameters[@"reAddress"] = self.currentAddress.totalAddress;
    http.parameters[@"reMobile"] = self.currentAddress.mobile;
    
    http.parameters[@"applyUser"] = [TLUser user].userId;
    
    //根据收货地址
    NSString *note = [self.remarkTV.text valid] ? self.remarkTV.text: @"无";
    
    http.parameters[@"applyNote"] = note;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"下单成功"];
        
        NSString *datacode = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            PayOrderVC *payorderVC = [PayOrderVC new];
            payorderVC.priceText = self.priceText;
            payorderVC.datacode = datacode;
            [weakSelf.navigationController pushViewController:payorderVC animated:YES];
        });
        
        
    } failure:^(NSError *error) {
        
    }];
    
    return;
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
