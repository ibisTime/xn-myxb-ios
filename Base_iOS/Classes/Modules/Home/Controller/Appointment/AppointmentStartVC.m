//
//  AppointmentStartVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AppointmentStartVC.h"
//Category
#import "UIBarButtonItem+convience.h"
#import "NSString+Check.h"
#import "NSString+Date.h"
//V
#import "TLTextView.h"
#import "TLTextField.h"
#import "TLDatePicker.h"
//C
#import "AppointmentOrderVC.h"

@interface AppointmentStartVC ()
//预约时间
@property (nonatomic, strong) TLTextField *timeTF;
@property (nonatomic, strong) TLDatePicker *datePicker;
//预约天数
@property (nonatomic, strong) TLTextField *dayTF;
//预约
@property (nonatomic, strong) TLTextView *appointmentTV;
//当前选择的时间
@property (nonatomic, strong) NSDate *currentDate;

@end

@implementation AppointmentStartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    [self initSubviews];
}

#pragma mark - LazyLoad
- (TLDatePicker *)datePicker {
    
    if (!_datePicker) {
        
        BaseWeakSelf;
        
        _datePicker = [TLDatePicker new];
        _datePicker.datePicker.datePickerMode = UIDatePickerModeDateAndTime;

        [_datePicker setConfirmAction:^(NSDate *date) {
            
            weakSelf.timeTF.text = [NSString stringFromDate:date formatter:@"yyyy-MM-dd HH:mm"];
            weakSelf.currentDate = date;
        }];
    }
    return _datePicker;
}

#pragma mark - Init
- (void)initSubviews {
    //预约时间
    CGFloat leftMargin = 0;
    CGFloat leftW = 120;
    CGFloat tfH = 50;
    CGFloat tfW = kScreenWidth;
    self.timeTF = [[TLTextField alloc] initWithFrame:CGRectMake(leftMargin, 0, tfW, tfH) leftTitle:@"开始时间" titleWidth:leftW placeholder:@"请选择预约时间"];
    
    [self.view addSubview:self.timeTF];
    //点击手势
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTime)];
    
    [self.timeTF addGestureRecognizer:tapGR];
    //右箭头
    CGFloat arrowW = 6;
    CGFloat arrowH = 10;
    CGFloat rightMargin = 10;
    
    UIImageView *arrowIV = [[UIImageView alloc] initWithImage:kImage(@"更多-灰色")];
    
    arrowIV.frame = CGRectMake(tfW - rightMargin - arrowW, 0, arrowW, arrowH);
    arrowIV.centerY = tfH/2.0;
    
    [self.timeTF addSubview:arrowIV];
    
    //预约天数
    self.dayTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.timeTF.yy + 10, kScreenWidth, 50)
                                          leftTitle:@"预约天数"
                                         titleWidth:100
                                        placeholder:@"请输入预约天数"];
    
    self.dayTF.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.view addSubview:self.dayTF];
    //预约
    self.appointmentTV = [[TLTextView alloc] initWithFrame:CGRectMake(0, self.dayTF.yy + 10, kScreenWidth, 180)];
    
    self.appointmentTV.placeholderLbl.origin = CGPointMake(15, 15);
    self.appointmentTV.placeholderLbl.font = Font(13.0);
    self.appointmentTV.textContainerInset = UIEdgeInsetsMake(17, 10, 0, 0);
    self.appointmentTV.placholder = @"请填写预约说明(选填)";
    
    [self.view addSubview:self.appointmentTV];
    //预约
    UIButton *appointmentBtn = [UIButton buttonWithTitle:@"预约"
                                          titleColor:kWhiteColor
                                     backgroundColor:kThemeColor
                                           titleFont:18.0
                                        cornerRadius:7.5];
    appointmentBtn.frame = CGRectMake(15, self.appointmentTV.yy + 40, kScreenWidth - 30, 44);
    
    [appointmentBtn addTarget:self action:@selector(appointment) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:appointmentBtn];
}

#pragma mark - Events
- (void)selectTime {
    
    [self.datePicker show];
    
}

- (void)appointment {
    
    if (![self.timeTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请选择预约时间"];
        return ;
    }
    
    if (![self.dayTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入预约天数"];
        return ;
    }
    
    [self.view endEditing:YES];

    TLNetworking *http = [TLNetworking new];
    
    http.showView = self.view;
    http.code = @"805510";
    http.parameters[@"applyUser"] = [TLUser user].userId;
    http.parameters[@"applyNote"] = self.appointmentTV.text;
    http.parameters[@"appointDatetime"] = [NSString stringFromDate:self.currentDate formatter:@"yyyy-MM-dd HH:mm:ss"];
    http.parameters[@"appointDays"] = self.dayTF.text;
    http.parameters[@"owner"] = self.code;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:[NSString stringWithFormat:@"%@成功", self.titleStr]];
        
        AppointmentOrderVC *orderVC = [AppointmentOrderVC new];
        
        [self.navigationController pushViewController:orderVC animated:YES];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
