//
//  AppointmentOrderDetailVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AppointmentOrderDetailVC.h"
//Macro
#import "AppMacro.h"
//Category
#import "NSString+Date.h"
#import "NSString+Check.h"
//V
#import "OrderParamCell.h"
//C
#import "NavigationController.h"
#import "BrandCommentVC.h"

#import "UIBarButtonItem+convience.h"

#import "ResultsEntryVC.h"
#import "ResultsTheAuditVC.h"
#import "TopUpVC.h"

@interface AppointmentOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) TLTableView *tableView;
//评论
@property (nonatomic, strong) UIButton *commentBtn;

@end

@implementation AppointmentOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"预约详情";
    

    [self requestOrderDeteil];
}
- (void)creatUI
{
    if ([self.order.status integerValue] == [kAppointmentOrderStatus_5 integerValue] || [self.order.status integerValue] == [kAppointmentOrderStatus_1 integerValue] || [self.order.status integerValue] == [kAppointmentOrderStatus_7 integerValue] || [self.order.status integerValue] == [kAppointmentOrderStatus_6 integerValue]) {
        
        NSString *titleStr ;
        if ([self.order.status integerValue] == [kAppointmentOrderStatus_5 integerValue]) {
            
            if ([[TLUser user].kind isEqualToString:kUserTypeBeautyGuide] || [[TLUser user].kind isEqualToString:kUserTypeExpert])
            {
                titleStr = @"成果录入";
                
            }
            
        }
        else if ([self.order.status integerValue] == [kAppointmentOrderStatus_1 integerValue])
        {
            if ([[TLUser user].kind isEqualToString:kUserTypeBeautyGuide] || [[TLUser user].kind isEqualToString:kUserTypeExpert])
            {
                titleStr = @"取消预约";
                
            }
        }
        else if ([self.order.status integerValue] == [kAppointmentOrderStatus_7 integerValue])
        {
            if ([self.kind isEqualToString:kUserTypeExpert]) {
                titleStr = @"支付";
                
            }
        }
        else if ([self.order.status integerValue] == [kAppointmentOrderStatus_6 integerValue])
        {
            if  ([[TLUser user].kind isEqualToString:kUserTypeSalon]){
                titleStr = @"成果审核";
            }
            
        }
        
        [UIBarButtonItem addRightItemWithTitle:titleStr titleColor:kWhiteColor frame:CGRectMake(0, 0, 70, 44) vc:self action:@selector(resultsEntry)];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}
- (void)requestOrderDeteil
{
    TLNetworking *http = [TLNetworking new];
    http.code = @"805521";
    http.parameters[@"code"] = self.order.code;
    http.showView = self.view;
    [http postWithSuccess:^(id responseObject) {
        NSLog(@"---->%@",responseObject);
        self.order = [AppointmentOrderModel mj_objectWithKeyValues:responseObject[@"data"]];
        [self creatUI];
        
        [self initTableView];
        //
        [self initEventsButton];
        
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark - Init

- (void)initTableView {
    
    [self.tableView reloadData];
    
}

- (TLTableView *)tableView
{
    if (!_tableView) {
        _tableView = [TLTableView tableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kBottomInsetHeight - 50)
                                                        delegate:self
                                                      dataSource:self];
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)initEventsButton {
    
    if (/*[self.order.isComment isEqualToString:@"0"] && */[self.order.status integerValue] == [kAppointmentOrderStatus_1 integerValue]|| [self.order.status integerValue] == [kAppointmentOrderStatus_2 integerValue] || [self.order.status integerValue] == [kAppointmentOrderStatus_4 integerValue]) {
        
        self.commentBtn.hidden = NO;
        
        if ([[TLUser user].kind isEqualToString:kUserTypeBeautyGuide] || [[TLUser user].kind isEqualToString:kUserTypeExpert]) {
            self.tableView.height = kSuperViewHeight - kTabBarHeight;
            
            [self.commentBtn setTitle:[self.order getStatusName] forState:UIControlStateNormal];
            if ([self.commentBtn.titleLabel.text isEqualToString:@"待接单"]) {
                [self.commentBtn setTitle:@"接单" forState:UIControlStateNormal];
            }
            else if ([self.commentBtn.titleLabel.text isEqualToString:@"待上门"])
            {
                [self.commentBtn setTitle:@"确认上门" forState:UIControlStateNormal];

            }
            else if ([self.commentBtn.titleLabel.text isEqualToString:@"待下课"])
            {
                [self.commentBtn setTitle:@"确认下课" forState:UIControlStateNormal];
                
            }
            
            
        }
        else
        {
            self.commentBtn.hidden = YES;
        }
        //评价
       
    }
    else
    {
        self.commentBtn.hidden = YES;

    }
}
- (UIButton *)commentBtn
{
    if (!_commentBtn) {
        CGFloat w = kScreenWidth;
        UIColor *bgColor = kAppCustomMainColor;
        UIColor *titleColor =  kWhiteColor;
        _commentBtn = [UIButton buttonWithTitle:[self.order getStatusName]
                                         titleColor:titleColor
                                    backgroundColor:bgColor
                                          titleFont:18.0];
        _commentBtn.frame = CGRectMake(30, self.tableView.yy, w - 60, 49);
        _commentBtn.layer.cornerRadius = 5;
        [_commentBtn addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_commentBtn];
    }
    return _commentBtn;
}
#pragma mark - Events
//评价
- (void)comment {

    
    //待接单
    if ([self.order.status integerValue] == [kAppointmentOrderStatus_1 integerValue]) {
        
        [self getorder];
    }
    //带上门
    else if ([self.order.status integerValue] == [kAppointmentOrderStatus_2 integerValue])
    {
        [self confirmVisit];
    }
    //带下课
    else if ([self.order.status integerValue] == [kAppointmentOrderStatus_4 integerValue])
    {
        [self overClass];
    }
    //待录入
    else if ([self.order.status integerValue] == [kAppointmentOrderStatus_5 integerValue])
    {
        
    }
    else if ([self.order.status integerValue] == [kAppointmentOrderStatus_7 integerValue])
    {
       
    }
    return;
    //对宝贝进行评价
    BrandCommentVC *commentVC = [[BrandCommentVC alloc] init];
    
    commentVC.code = self.order.code;
    commentVC.commentKind = self.order.type;
    commentVC.type = OrderCommentTypePerson;
    commentVC.placeholder = [NSString stringWithFormat:@"请对%@进行评论", [self.order getUserType]];
    
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:commentVC];
    
    [self presentViewController:nav animated:YES completion:nil];
}

//上门
- (void)confirmVisit {
    
    [TLAlert alertWithTitle:@"" msg:@"确认已上门?" confirmMsg:@"确认" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
        
    } confirm:^(UIAlertAction *action) {
        
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"805512";
        http.parameters[@"code"] = self.order.code;
        http.parameters[@"updater"] = [TLUser user].userId;
        //    http.parameters[@"token"] = [TLUser user].token;
        
        [http postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithSucces:@"上门成功"];
            
//            if (_overClassSuccess) {
//
//                _overClassSuccess();
//            }
            [self requestOrderDeteil];
//            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
}

- (void)overClass {
    
    [TLAlert alertWithTitle:@"" msg:@"确认已下课?" confirmMsg:@"确认" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
        
    } confirm:^(UIAlertAction *action) {
        
        TLNetworking *http = [TLNetworking new];
        
        http.code = @"805513";
        http.parameters[@"code"] = self.order.code;
        http.parameters[@"updater"] = [TLUser user].userId;
        
        [http postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithSucces:@"下课成功"];
            
//            if (_visitSuccess) {
//
//                _visitSuccess();
//            }
            [self requestOrderDeteil];
//            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            
        }];
    }];
}
- (void)getorder
{
    [TLAlert alertWithTitle:@"" msg:@"确认接单?" confirmMsg:@"确认" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
        
    } confirm:^(UIAlertAction *action) {
        
        TLNetworking *http = [TLNetworking new];
        
        http.code = @"805511";
        http.parameters[@"code"] = self.order.code;
        http.parameters[@"updater"] = [TLUser user].userId;
        http.parameters[@"owner"] = [TLUser user].userId;

        [http postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithSucces:@"接单成功"];
        
            [self requestOrderDeteil];
//            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            
        }];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

//    if ([self.order.status isEqualToString:kAppointmentOrderStatus_1] || [self.order.status isEqualToString:kAppointmentOrderStatus_2]) {
//
        return 4;
//    }
//    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *orderDetailCellId = @"OrderParamCell";
    OrderParamCell *cell = [tableView dequeueReusableCellWithIdentifier:orderDetailCellId];
    if (!cell) {
        
        cell = [[OrderParamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderDetailCellId];
    }
    
    AppointmentUser *user = self.order.user;
    //
    NSString *name = user.realName;
    STRING_NIL_NULL(name);
    //
    NSString *startDate = [self.order.appointDatetime convertDate];
    STRING_NIL_NULL(startDate);
    //
    NSString *day = [NSString stringWithFormat:@"%ld天", self.order.appointDays];
    STRING_NIL_NULL(day);
    //
    NSString *planDate = [self.order.planDatetime convertToDetailDate];
    STRING_NIL_NULL(planDate)
    //
    NSString *planDay = [NSString stringWithFormat:@"%ld天", self.order.planDays];
    STRING_NIL_NULL(planDay);
    //
    NSString *status = [self.order getStatusName];
    STRING_NIL_NULL(status)
    
    NSArray *textArr;
    NSArray *contentArr;
    
//    if ([self.order.status isEqualToString:kAppointmentOrderStatus_1] ||[self.order.status isEqualToString:kAppointmentOrderStatus_2]) {
    
        textArr = @[[NSString stringWithFormat:@"预约%@", [self.order getUserType]], @"预约开始时间", @"预约天数", @"状态"];
        contentArr = @[name, startDate, day, status];

        if (indexPath.row == 3) {
            
            cell.contentLbl.textColor = kThemeColor;
        }
        
//    } else {
//
//        textArr = @[[NSString stringWithFormat:@"预约%@", [self.order getUserType]], @"预约开始时间", @"预约天数", @"预约排班时间", @"预约排班天数", @"状态"];
//        contentArr = @[name, startDate, day, planDate, planDay, status];
//
//        if (indexPath.row == 5) {
//
//            cell.contentLbl.textColor = kThemeColor;
//        }
//    }
    
    cell.textLbl.text = textArr[indexPath.row];
    cell.contentLbl.text = contentArr[indexPath.row];
    [cell.contentLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@110);
        make.centerY.equalTo(@0);
    }];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.00001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}
#pragma mark - 成果录入 || 取消预约 || 成果审核
- (void)resultsEntry
{
    if ([self.order.status integerValue] == [kAppointmentOrderStatus_5 integerValue]) {
        
        UIViewController *pushVC;
        
        if  ([[TLUser user].kind isEqualToString:kUserTypeBeautyGuide] || [[TLUser user].kind isEqualToString:kUserTypeExpert])
        {
            ResultsEntryVC *entryvc = [[ResultsEntryVC alloc]init];
            entryvc.chouseOrder = self.order;
            pushVC = entryvc;
        }
        
        [self.navigationController pushViewController:pushVC animated:YES];
    }
    else if ([self.order.status integerValue] == [kAppointmentOrderStatus_1 integerValue])
    {
        if ([[TLUser user].kind isEqualToString:kUserTypeBeautyGuide] ||[[TLUser user].kind isEqualToString:kUserTypeExpert] )
        {
            [TLAlert alertWithTitle:@"" msg:@"您确定要取消该预约单吗?" confirmMsg:@"确认" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
                
            } confirm:^(UIAlertAction *action) {
                
                TLNetworking *http = [TLNetworking new];
                
                http.code = @"805529";
                http.parameters[@"code"] = self.order.code;
                http.parameters[@"userId"] = [TLUser user].userId;
                
                [http postWithSuccess:^(id responseObject) {
                    
                    [TLAlert alertWithSucces:@"取消成功"];
                    
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                } failure:^(NSError *error) {
                    
                }];
            }];
        }
    }
    else if ([self.order.status integerValue] == [kAppointmentOrderStatus_7 integerValue])
    {
        if ([self.kind isEqualToString:kUserTypeExpert]) {
            TopUpVC *zhifu = [[TopUpVC alloc]init];
            zhifu.kind = self.kind;
            zhifu.code = self.order.code;
            zhifu.deductAmount = [self.order.deductAmount convertToRealMoney];
            zhifu.isPayExperts = YES;
            [self.navigationController pushViewController:zhifu animated:YES];

        }
    }
    else if ([self.order.status integerValue] == [kAppointmentOrderStatus_6 integerValue])
    {
        if  ([[TLUser user].kind isEqualToString:kUserTypeSalon]){
            ResultsTheAuditVC *auditVC = [[ResultsTheAuditVC alloc]init];
            auditVC.order = self.order;
            [self.navigationController pushViewController:auditVC animated:YES];

        }
    }

    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
