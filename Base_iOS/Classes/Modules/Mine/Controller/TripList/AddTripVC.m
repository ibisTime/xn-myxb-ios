//
//  AddTripVC.m
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/5.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AddTripVC.h"
#import "TLTextField.h"
#import "TLDatePicker.h"
#import "NSString+Date.h"
#import "TLPickerTextField.h"
#import "UIControl+Block.h"
@interface AddTripVC ()
//预约时间
@property (nonatomic, strong) TLTextField *starTF;
@property (nonatomic, strong) TLTextField *endTF;
@property (nonatomic, strong) TLPickerTextField *typeTF;

@property (nonatomic, strong) TLDatePicker *datePicker;
@property (nonatomic)BOOL isStar;
@property (nonatomic , copy)NSString *statTimer;
@property (nonatomic , copy)NSString *endTimer;

@end

@implementation AddTripVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新增行程";
    [self initSubviews];
}
- (void)initSubviews
{
    //预约时间
    CGFloat leftMargin = 0;
    CGFloat leftW = 120;
    CGFloat tfH = 50;
    CGFloat tfW = kScreenWidth;
    
    self.starTF = [[TLTextField alloc] initWithFrame:CGRectMake(leftMargin, 0, tfW, tfH) leftTitle:@"开始时间" titleWidth:leftW placeholder:@"请选择预约时间"];
    
    [self.view addSubview:self.starTF];
    //点击手势
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTime)];
    
    [self.starTF addGestureRecognizer:tapGR];
    
    //右箭头
    CGFloat arrowW = 6;
    CGFloat arrowH = 10;
    CGFloat rightMargin = 10;
    
    UIImageView *arrowIV = [[UIImageView alloc] initWithImage:kImage(@"更多-灰色")];
    
    arrowIV.frame = CGRectMake(tfW - rightMargin - arrowW, 0, arrowW, arrowH);
    arrowIV.centerY = tfH/2.0;
    
    [self.starTF addSubview:arrowIV];
    
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.starTF.frame), kScreenWidth, .5)];
    lineview.backgroundColor = kSilverGreyColor;
    [self.view addSubview:lineview];
    
    self.endTF = [[TLTextField alloc] initWithFrame:CGRectMake(leftMargin, CGRectGetMaxY(lineview.frame), tfW, tfH) leftTitle:@"结束时间" titleWidth:leftW placeholder:@"请选择结束时间"];
    
    [self.view addSubview:self.endTF];
    //点击手势
    UITapGestureRecognizer *tapGR2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTimeend)];
    
    [self.endTF addGestureRecognizer:tapGR2];
    
    UIImageView *arrowIV2 = [[UIImageView alloc] initWithImage:kImage(@"更多-灰色")];
    
    arrowIV2.frame = CGRectMake(tfW - rightMargin - arrowW, 0, arrowW, arrowH);
    arrowIV2.centerY = tfH/2.0;
    
    [self.endTF addSubview:arrowIV2];
    
    BaseWeakSelf;
    self.typeTF = [[TLPickerTextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.endTF.frame) + 10, kScreenWidth, tfH)
                                                      leftTitle:@"类型"
                                                     titleWidth:leftW
                                                    placeholder:@"请选择类型"];
    self.typeTF.tagNames = @[@"可预约",@"可调配时间"];
    
    self.typeTF.leftLbl.font = Font(14.0);
    self.typeTF.didSelectBlock = ^(NSInteger index) {
        
//        [weakSelf selectStyleWithIndex:index];
        weakSelf.typeTF.text = index == 0 ? @"可预约" :@"可调配时间";
    };
    
    [self.view addSubview:self.typeTF];
    
    UIImageView *arrowIV3 = [[UIImageView alloc] initWithImage:kImage(@"更多-灰色")];
    
    arrowIV3.frame = CGRectMake(tfW - rightMargin - arrowW, 0, arrowW, arrowH);
    arrowIV3.centerY = tfH/2.0;
    
    [self.typeTF addSubview:arrowIV3];
    
    
    
    UIButton *addbtn = [UIButton buttonWithTitle:@"新增行程" titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:18.0];
    [addbtn bk_addEventHandler:^(id sender) {
        
        [self requestHttp];
        
    } forControlEvents:UIControlEventTouchUpInside];
    addbtn.layer.cornerRadius = 5;
    [self.view addSubview:addbtn];
    [addbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.height.mas_equalTo(50);
        make.top.equalTo(self.typeTF.mas_bottom).with.offset(40);
    }];
    
    if (self.tripModel.code.length != 0) {
        self.starTF.text = [self.tripModel.startDatetime convertDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.endTF.text = [self.tripModel.endDatetime convertDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        if ([self.tripModel.type integerValue] == 1) {
            self.typeTF.text = @"可预约";
        }
        else
        {
            self.typeTF.text = @"可调配时间";

        }
        [addbtn setTitle:@"确定修改" forState:UIControlStateNormal];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Events
- (void)selectTime {
    
    self.isStar = YES;
    [self.datePicker show];
    
}
- (void)selectTimeend
{
    self.isStar = NO;
    [self.datePicker show];
}

#pragma mark - LazyLoad
- (TLDatePicker *)datePicker {
    
    if (!_datePicker) {
        
        BaseWeakSelf;
        
        _datePicker = [TLDatePicker new];
        _datePicker.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        
        [_datePicker setConfirmAction:^(NSDate *date) {
            
            
            NSString *timer = [NSString stringFromDate:date formatter:@"yyyy-MM-dd HH:mm:ss"];
            if (weakSelf.isStar) {
                weakSelf.starTF.text = timer;
                weakSelf.statTimer = timer;
            }
            else
            {
                weakSelf.endTimer =timer;
                weakSelf.endTF.text = timer;
            }
            
            
        }];
    }
    return _datePicker;
}

- (void)requestHttp
{
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.parameters[@"endDatetime"] = self.endTF.text;
    http.parameters[@"startDatetime"] = self.starTF.text;
    http.parameters[@"updater"] = [TLUser user].userId;
    http.parameters[@"userId"] = [TLUser user].userId;
    if ([self.typeTF.text isEqualToString:@"可预约"]) {
        http.parameters[@"type"] = @(1);

    }
    else
    {
        http.parameters[@"type"] = @(2);

    }

    if (self.tripModel.code.length != 0) {
        http.code = @"805502";
        http.parameters[@"code"] = self.tripModel.code;


    }
    else
    {
        http.code = @"805500";

    }
    
    
    [http postWithSuccess:^(id responseObject) {
        if (self.tripModel.code.length != 0) {
            [TLAlert alertWithSucces:@"修改成功"];

        }
        else
        {
            [TLAlert alertWithSucces:@"添加成功"];

        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        
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
