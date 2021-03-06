//
//  TLUserForgetPwdVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLUserForgetPwdVC.h"
//Macro
#import "APICodeMacro.h"
//Category
#import "NSString+Check.h"
//V
#import "CaptchaView.h"
#import "TLPickerTextField.h"

@interface TLUserForgetPwdVC ()

@property (nonatomic,strong) TLTextField *phoneTf;

@property (nonatomic,strong) TLTextField *pwdTf;

@property (nonatomic,strong) TLTextField *rePwdTf;

@property (nonatomic, strong) CaptchaView *captchaView;
//角色类型
@property (nonatomic, strong) TLPickerTextField *userTypeTf;

@end

@implementation TLUserForgetPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"找回密码";
    
    self.view.backgroundColor = kWhiteColor;
    
    [self initSubviews];
    
}

- (void)initSubviews {

    BaseWeakSelf;
    
    self.view.backgroundColor = kBackgroundColor;
    
    CGFloat margin = ACCOUNT_MARGIN;
    CGFloat w = kScreenWidth - 2*margin;
    CGFloat h = ACCOUNT_HEIGHT;
    CGFloat titleW = 100;
    
    CGFloat btnMargin = 15;
    //账号
    TLTextField *phoneTf = [[TLTextField alloc] initWithFrame:CGRectMake(margin, 10, w, h)
                                                    leftTitle:@"手机号"
                                                   titleWidth:titleW
                                                  placeholder:@"请输入手机号"];
    phoneTf.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:phoneTf];
    self.phoneTf = phoneTf;
    
    //验证码
    CaptchaView *captchaView = [[CaptchaView alloc] initWithFrame:CGRectMake(margin, phoneTf.yy + 1, w, h)];
    [captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:captchaView];
    
    self.captchaView = captchaView;
    
    //密码
    TLTextField *pwdTf = [[TLTextField alloc] initWithFrame:CGRectMake(margin, captchaView.yy + 10, w, h)
                                                  leftTitle:@"新密码"
                                                 titleWidth:titleW
                                                placeholder:@"请输入密码"];
    pwdTf.secureTextEntry = YES;
    
    [self.view addSubview:pwdTf];
    self.pwdTf = pwdTf;
    
    //re密码
    TLTextField *rePwdTf = [[TLTextField alloc] initWithFrame:CGRectMake(margin, pwdTf.yy + 1, w, h)
                                                    leftTitle:@"确认密码"
                                                   titleWidth:titleW
                                                  placeholder:@"确认密码"];
    rePwdTf.secureTextEntry = YES;
    [self.view addSubview:rePwdTf];
    self.rePwdTf = rePwdTf;
    
    NSArray *typeArr = @[@"美容院",
                         @"讲师",
                         @"专家",
                         @"美导"];
    
    //角色类型
    TLPickerTextField *userTypeTf = [[TLPickerTextField alloc] initWithFrame:CGRectMake(0, rePwdTf.yy + 1, w, h)
                                                                   leftTitle:@"选择角色"
                                                                  titleWidth:titleW
                                                                 placeholder:@"请选择角色"];
    userTypeTf.tagNames = typeArr;
    userTypeTf.didSelectBlock = ^(NSInteger index) {
        
        weakSelf.userTypeTf.text = typeArr[index];
    };
    
    [self.view addSubview:userTypeTf];
    self.userTypeTf = userTypeTf;
    
    //右箭头
    CGFloat arrowW = 6;
    CGFloat arrowH = 10;
    CGFloat rightMargin = 10;
    
    UIImageView *arrowIV = [[UIImageView alloc] initWithImage:kImage(@"更多-灰色")];
    
    arrowIV.frame = CGRectMake(self.userTypeTf.width - rightMargin - arrowW, 0, arrowW, arrowH);
    arrowIV.centerY = self.userTypeTf.height/2.0;
    
    [self.userTypeTf addSubview:arrowIV];
    
    for (int i = 0; i < 2; i++) {
        
        UIView *line = [[UIView alloc] init];
        
        line.backgroundColor = [UIColor lineColor];
        
        [self.view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(margin));
            make.right.equalTo(@0);
            make.height.equalTo(@0.5);
            make.top.equalTo(@(10 + h + i*(2*h + 10 + 1)));
            
        }];
    }
    
    //
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"确认" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:16.0 cornerRadius:5];
    
    [confirmBtn addTarget:self action:@selector(changePwd) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(btnMargin));
        make.width.equalTo(@(kScreenWidth - 2*btnMargin));
        make.height.equalTo(@(h - 5));
        make.top.equalTo(userTypeTf.mas_bottom).offset(40);
        
    }];
}

#pragma mark - Events
- (void)sendCaptcha {
    
    
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:@"请输入正确的手机号"];
        
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = CAPTCHA_CODE;
    http.parameters[@"bizType"] = USER_FIND_PWD_CODE;
    http.parameters[@"mobile"] = self.phoneTf.text;

    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"验证码已发送,请注意查收"];
        
        [self.captchaView.captchaBtn begin];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)changePwd {
    
    NSString *kind = @"";
    
    switch (_userTypeTf.selectIndex) {
        case 0:
        {
            kind = kUserTypeSalon;
        }break;
            
        case 1:
        {
            kind = kUserTypeLecturer;
        }break;
            
        case 2:
        {
            kind = kUserTypeExpert;
        }break;
            
        case 3:
        {
            kind = kUserTypeBeautyGuide;
        }break;
            
        default:
            break;
    }
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:@"请输入正确的手机号"];
        
        return;
    }
    
    if (!(self.captchaView.captchaTf.text && self.captchaView.captchaTf.text.length > 3)) {
        [TLAlert alertWithInfo:@"请输入正确的验证码"];
        
        return;
    }
    
    if (!(self.pwdTf.text &&self.pwdTf.text.length > 5)) {
        
        [TLAlert alertWithInfo:@"请输入6位以上密码"];
        return;
    }
    
    if (!(self.rePwdTf.text &&self.rePwdTf.text.length > 5)) {
        
        [TLAlert alertWithInfo:@"请输入6位以上密码"];
        return;
    }
    
    if (![self.pwdTf.text isEqualToString:self.rePwdTf.text]) {
        
        [TLAlert alertWithInfo:@"输入的密码不一致"];
        return;
        
    }
    
    if (self.userTypeTf.text.length == 0) {
        
        [TLAlert alertWithInfo:@"请选择角色"];
        return ;
    }
    
    [self.view endEditing:YES];

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_FIND_PWD_CODE;
    http.parameters[@"mobile"] = self.phoneTf.text;
    http.parameters[@"smsCaptcha"] = self.captchaView.captchaTf.text;
    http.parameters[@"newLoginPwd"] = self.pwdTf.text;
    http.parameters[@"kind"] = kind;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"找回成功"];
        
        //保存用户账号和密码
        [[TLUser user] saveUserName:self.phoneTf.text pwd:self.pwdTf.text];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
            
        });
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
