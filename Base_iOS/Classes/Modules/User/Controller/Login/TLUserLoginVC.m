//
//  TLUserLoginVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLUserLoginVC.h"

//Macro
#import "APICodeMacro.h"
#import "AppMacro.h"
//Category
#import "NSString+Check.h"
#import "UIBarButtonItem+convience.h"
#import "UILabel+Extension.h"
//M
//#import "CurrencyModel.h"
//V
#import "TLTextField.h"
#import "TLPickerTextField.h"
//C
#import "BindMobileVC.h"
#import "TLUserForgetPwdVC.h"

#import "CurrencyModel.h"


@interface TLUserLoginVC ()

@property (nonatomic, strong) TLTextField *phoneTf;
@property (nonatomic, strong) TLTextField *pwdTf;
//角色类型
@property (nonatomic, strong) TLPickerTextField *userTypeTf;
//kind
@property (nonatomic, copy) NSString *kind;

@property (nonatomic, copy) NSString *verifyCode;

@property (nonatomic, copy) NSString *mobile;

@end

@implementation TLUserLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    
    [self setBarButtonItem];
    
    [self setUpUI];
    //登录成功回调
    [self setUpNotification];
    
}

#pragma mark - Init

- (void)setBarButtonItem {

    //取消按钮
    [UIBarButtonItem addLeftItemWithImageName:kCancelIcon frame:CGRectMake(-30, 0, 80, 44) vc:self action:@selector(back)];
}

- (void)setUpUI {
    
    BaseWeakSelf;
    
    self.view.backgroundColor = kBackgroundColor;
    
    CGFloat w = kScreenWidth;
    CGFloat h = ACCOUNT_HEIGHT;
    CGFloat count = 3;
    
    UIView *bgView = [[UIView alloc] init];
    
    bgView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@(10));
        make.left.equalTo(@0);
        make.height.equalTo(@(count*(h + 1)));
        make.width.equalTo(@(w));
    }];
    
    //账号
    TLTextField *phoneTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, 0, w, h)
                                                     leftIcon:@"手机"
                                                  placeholder:@"请输入手机号码"];
    [bgView addSubview:phoneTf];
    self.phoneTf = phoneTf;
    phoneTf.keyboardType = UIKeyboardTypeNumberPad;
    
    //密码
    TLTextField *pwdTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, phoneTf.yy + 1, w, h)
                                                   leftIcon:@"密码"
                                                placeholder:@"请输入密码"];
    pwdTf.secureTextEntry = YES;
    [bgView addSubview:pwdTf];
    self.pwdTf = pwdTf;
    
    NSArray *typeArr = @[@"经销商",
                         @"合伙人",
                         @"销售精英",
                         @"服务团队"];
    
    //角色类型
    TLPickerTextField *userTypeTf = [[TLPickerTextField alloc] initWithFrame:CGRectMake(0, pwdTf.yy + 1, w, h)
                                                                    leftIcon:@"角色"
                                                                 placeholder:@"请选择角色"];
    userTypeTf.tagNames = typeArr;
    userTypeTf.didSelectBlock = ^(NSInteger index) {
        
        weakSelf.userTypeTf.text = typeArr[index];
    };
    
    [bgView addSubview:userTypeTf];
    self.userTypeTf = userTypeTf;
    
    for (int i = 0; i < count; i++) {
        
        UIView *line = [[UIView alloc] init];
        
        line.backgroundColor = kLineColor;
        
        [bgView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@0.5);
            make.top.equalTo(@((i+1)*(h+1)));
            
        }];
    }
    
    //右箭头
    CGFloat arrowW = 6;
    CGFloat arrowH = 10;
    CGFloat rightMargin = 10;
    
    UIImageView *arrowIV = [[UIImageView alloc] initWithImage:kImage(@"更多-灰色")];
    
    arrowIV.frame = CGRectMake(self.userTypeTf.width - rightMargin - arrowW, 0, arrowW, arrowH);
    arrowIV.centerY = self.userTypeTf.height/2.0;
    
    [self.userTypeTf addSubview:arrowIV];
    //登录
    UIButton *loginBtn = [UIButton buttonWithTitle:@"登录" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:17.0 cornerRadius:5];
    [loginBtn addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(15));
        make.height.equalTo(@(h - 5));
        make.right.equalTo(@(-15));
        make.top.equalTo(bgView.mas_bottom).offset(28);
        
    }];
    
    //找回密码
    UIButton *forgetPwdBtn = [UIButton buttonWithTitle:@"找回密码?" titleColor:kTextColor2 backgroundColor:kClearColor titleFont:14.0];
    
    forgetPwdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [forgetPwdBtn addTarget:self action:@selector(findPwd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetPwdBtn];
    
    [forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(loginBtn.mas_right);
        make.top.equalTo(loginBtn.mas_bottom).offset(18);

    }];
    
}

- (void)setUpNotification {

    //登录成功之后，给予回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:kUserLoginNotification object:nil];

}

#pragma mark - Events

- (void)back {
    
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//登录成功
- (void)login {

    //获取腾讯云IM签名、账号并登录
//    [[ChatManager sharedManager] loginIM];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotification object:nil];

    [self dismissViewControllerAnimated:YES completion:nil];

    if (self.loginSuccess) {

        self.loginSuccess();
    }

}

- (void)findPwd {
    
    TLUserForgetPwdVC *vc = [[TLUserForgetPwdVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)goLogin {
    
    NSString *kind = @"";

    switch (_userTypeTf.selectIndex) {
        case 0:
        {
            kind = kUserTypeSalon;
        }break;
            
        case 1:
        {
//            kind = kUserTypeLecturer;
            kind = kUserTypePartner;
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
    
    self.kind = kind;
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:@"请输入正确的手机号"];
        
        return;
    }
    
    if (!(self.pwdTf.text &&self.pwdTf.text.length > 5)) {
        
        [TLAlert alertWithInfo:@"请输入6位以上密码"];
        return;
    }
    
    if (self.userTypeTf.text.length == 0) {
        
        [TLAlert alertWithInfo:@"请选择角色"];
        return ;
    }
    
    [self.view endEditing:YES];

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_LOGIN_CODE;
    
    http.parameters[@"loginName"] = self.phoneTf.text;
    http.parameters[@"loginPwd"] = self.pwdTf.text;
    http.parameters[@"kind"] = kind;

    [http postWithSuccess:^(id responseObject) {
        
        [self requesUserInfoWithResponseObject:responseObject];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)requesUserInfoWithResponseObject:(id)responseObject {
    
    NSString *token = responseObject[@"data"][@"token"];
    NSString *userId = responseObject[@"data"][@"userId"];
    
    //保存用户账号和密码
    [TLUser user].kind = self.kind;
    [[TLUser user] saveUserName:self.phoneTf.text pwd:self.pwdTf.text];
    
    //1.获取用户信息
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_INFO;
    http.parameters[@"userId"] = userId;
    http.parameters[@"token"] = token;
    [http postWithSuccess:^(id responseObject) {
        
        NSDictionary *userInfo = responseObject[@"data"];
        
        [TLUser user].userId = userId;
        [TLUser user].token = token;
        
        //保存用户信息
        [[TLUser user] saveUserInfo:userInfo];
        //初始化用户信息
        [[TLUser user] setUserInfoWithDict:userInfo];
        //获取人民币和积分账户
        [[TLUser user] requestAccountNumberWith:@"CNY"];
        [[TLUser user] requestAccountNumberWith:@"JF"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN_AGAIN" object:nil];


        
    } failure:^(NSError *error) {
        
        
    }];
    
}

//#pragma mark - 账户
//- (void)requestAccountNumberWith:(NSString *)type {
//
//    //获取人民币和积分账户
//    TLNetworking *http = [TLNetworking new];
//    http.code = @"802503";
//    http.parameters[@"currency"] = type;
//    http.parameters[@"userId"] = [TLUser user].userId;
//
//    [http postWithSuccess:^(id responseObject) {
//
//        NSArray <CurrencyModel *> *arr = [CurrencyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
//
//        [arr enumerateObjectsUsingBlock:^(CurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//            if ([obj.currency isEqualToString:@"JF"]) {
//
//                [TLUser user].jfAccountNumber = [obj.amount convertToRealMoney];
//
//            } else if ([obj.currency isEqualToString:@"CNY"]) {
//
//                [TLUser user].rmbAccountNumber = [obj.amount convertToRealMoney];
//            }
//
//        }];
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotification object:nil];
//
//    } failure:^(NSError *error) {
//
//
//    }];
//}

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,
     [self logSet:tags], alias];
    
    NSLog(@"TagsAlias回调:%@", callbackString);
}

- (NSString *)logSet:(NSSet *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

@end
