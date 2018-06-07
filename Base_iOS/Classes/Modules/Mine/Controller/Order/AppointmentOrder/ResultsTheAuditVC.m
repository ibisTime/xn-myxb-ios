//
//  ResultsTheAuditVC.m
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/7.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ResultsTheAuditVC.h"
//Macro
#import "AppMacro.h"
//Category
#import "NSString+Date.h"
#import "NSString+Check.h"
#import "NSNumber+Extension.h"
#import "UIControl+Block.h"
#import "TLUploadManager.h"
//V
#import "OrderParamCell.h"
#import "ResultsTheAuditCell.h"
#import "TLProgressHUD.h"

#import "TLImagePicker.h"
@interface ResultsTheAuditVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) TLTableView *tableView;
@property (nonatomic, strong) TLImagePicker *imagePicker;
@property (nonatomic , strong)UIImageView *goodIV;
@property (nonatomic , copy) NSString *photoKey;


@end

@implementation ResultsTheAuditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"成果审核";
    [self initTableView];
    
    
    UIButton *agree = [UIButton buttonWithTitle:@"通过" titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:18.0];
    [agree bk_addEventHandler:^(id sender) {
        
        [self requeShenHeWith:@"1"];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agree];
    [agree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-kBottomInsetHeight - 10);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo((kScreenWidth - 40) / 2 );
        
    }];
    
    UIButton *notAgree = [UIButton buttonWithTitle:@"通过" titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:18.0];
    [notAgree bk_addEventHandler:^(id sender) {
        
        [self requeShenHeWith:@"0"];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:notAgree];
    [notAgree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(agree.mas_right).with.offset(10);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-kBottomInsetHeight - 10);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo((kScreenWidth - 40) / 2);
        
    }];

    
    agree.layer.cornerRadius = 6;
    notAgree.layer.cornerRadius = 6;
}
#pragma mark - Init

- (void)initTableView {
    
    TLTableView *tableView = [TLTableView tableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kBottomInsetHeight - 50 - 10)
                                                    delegate:self
                                                  dataSource:self];
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@""];

    [self.view addSubview:tableView];
    
    self.tableView = tableView;
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        return 5;
    }
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
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
        
        
        textArr = @[[NSString stringWithFormat:@"预约%@", [self.order getUserType]], @"预约开始时间", @"预约天数", @"预约排班时间", @"预约排班天数", @"状态"];
        contentArr = @[name, startDate, day, planDate, planDay, status];
        
        if (indexPath.row == 5) {
            
            cell.contentLbl.textColor = kThemeColor;
        }
        
        cell.textLbl.text = textArr[indexPath.row];
        cell.contentLbl.text = contentArr[indexPath.row];
        [cell.contentLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@110);
            make.centerY.equalTo(@0);
        }];
        
        return cell;
    }
    else
    {
        static NSString *orderDetailCellId = @"ResultsTheAuditCell";

        ResultsTheAuditCell *Cell = [tableView dequeueReusableCellWithIdentifier:orderDetailCellId];
        if (!Cell) {
            Cell = [[ResultsTheAuditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderDetailCellId];
        }
        
        if (indexPath.row == 0) {
            Cell.textTF.leftLbl.text = @"开始时间";
            Cell.textTF.text = [self.order.realDatetime convertToDetailDate];
        }
        else if (indexPath.row == 1)
        {
            Cell.textTF.leftLbl.text = @"工作天数";
            Cell.textTF.rightLbl.text = @"天";
            Cell.textTF.text = self.order.realDays;

        }
        else if (indexPath.row == 2)
        {
            Cell.textTF.leftLbl.text = @"见客户数";
            Cell.textTF.rightLbl.text = @"人";
            Cell.textTF.text = self.order.clientNumber;

        }
        else if (indexPath.row == 3)
        {
            Cell.textTF.leftLbl.text = @"成交客户数";
            Cell.textTF.rightLbl.text = @"人";
            Cell.textTF.text = self.order.sucNumber;

        }
        else if (indexPath.row == 4)
        {
            Cell.textTF.leftLbl.text = @"销售业绩";
            Cell.textTF.rightLbl.text = @"¥";
            NSNumber *amount = [NSNumber numberWithFloat:[self.order.saleAmount floatValue]];
            Cell.textTF.text = [amount  convertToRealMoney];

        }
        
        return Cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        return 50;
    }
    return 0.00001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        UIView *headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        headerview.backgroundColor = [UIColor whiteColor];
        UIView *lineview = [[UIView alloc]init];
        lineview.backgroundColor = kThemeColor;
        [headerview addSubview:lineview];
        
        [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.centerY.equalTo(headerview.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(5, 18));
        }];
        
        UILabel *titleLABEL = [UILabel labelWithTitle:@"成果信息" frame:CGRectZero];
        titleLABEL.textColor = [UIColor blackColor];
        titleLABEL.font = [UIFont systemFontOfSize:18];
        titleLABEL.textAlignment = NSTextAlignmentLeft;
        [headerview addSubview:titleLABEL];
        
        [titleLABEL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lineview.mas_right).with.offset(5);
            make.top.bottom.equalTo(@0);
            make.right.equalTo(headerview.mas_right);
        }];
        
        return headerview;
    }
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 1) {
        return 130;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        UIView *footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        footview.backgroundColor = [UIColor whiteColor];
        
        
        UILabel *titleLable = [UILabel labelWithBackgroundColor:kClearColor textColor:[UIColor blackColor] font:15];
        titleLable.text = @"成果确认函";
        [footview addSubview:titleLable];
        [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.top.equalTo(@0);
            make.height.mas_equalTo(50);
        }];
        
        self.goodIV = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        self.goodIV.contentMode = UIViewContentModeScaleAspectFill;
        self.goodIV.userInteractionEnabled = YES;
        self.goodIV.clipsToBounds = YES;
        self.goodIV.image = GOOD_PLACEHOLDER_SMALL;
        [footview addSubview:self.goodIV];
        
        [self.goodIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@120);
            make.top.equalTo(@17);
            make.size.mas_equalTo(CGSizeMake(100, 100));
            
        }];
        UITapGestureRecognizer *tapGR2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAddImage)];
        
        [self.goodIV addGestureRecognizer:tapGR2];
        
        return footview;
    }
    return [UIView new];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)selectAddImage
{
    [self.imagePicker picker];
}
- (TLImagePicker *)imagePicker {
    
    if (!_imagePicker) {
        
        BaseWeakSelf;
        
        _imagePicker = [[TLImagePicker alloc] initWithVC:self];
        
        _imagePicker.allowsEditing = NO;
        _imagePicker.clipHeight = kScreenWidth;
        
        _imagePicker.pickFinish = ^(UIImage *photo, NSDictionary *info){
            
            UIImage *image = info == nil ? photo: info[@"UIImagePickerControllerOriginalImage"];
            
            NSData *imgData = UIImageJPEGRepresentation(image, 0.1);
            
            //进行上传
            [TLProgressHUD show];

            TLUploadManager *manager = [TLUploadManager manager];
            
            manager.imgData = imgData;
            manager.image = image;
            
            [manager getTokenShowView:weakSelf.view succes:^(NSString *key) {
                
                [TLProgressHUD dismiss];
                weakSelf.goodIV.image = image;
                weakSelf.photoKey = key;
            } failure:^(NSError *error) {
                
            }];
        };
    }
    
    return _imagePicker;
}

- (void)requeShenHeWith:(NSString *)type
{
    if (self.photoKey.length == 0) {
        [TLAlert alertWithMsg:@"请选择成果确认函"];
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805517";
    http.parameters[@"approveResult"] = type;
    http.parameters[@"code"] = self.order.code;
    http.parameters[@"pdf"] = self.photoKey;
    
    [http postWithSuccess:^(id responseObject) {
        [TLAlert alertWithSucces:@"操作成功"];
        NSMutableArray *arry = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [arry removeObjectAtIndex:arry.count - 2];
        self.navigationController.viewControllers = arry;
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];

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
