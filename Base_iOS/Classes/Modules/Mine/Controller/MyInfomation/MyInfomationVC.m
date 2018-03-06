//
//  MyInfomationVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "MyInfomationVC.h"
//Macro
#import "AppMacro.h"
//Framework
//Category
#import "UIBarButtonItem+convience.h"
#import "NSString+Check.h"
//Extension
//M
#import "DataDictionaryModel.h"
#import "MyInfomationModel.h"
//V
#import "TLTextField.h"
#import "TLPickerTextField.h"
#import "TLTextView.h"
//C

@interface MyInfomationVC ()
//姓名
@property (nonatomic, strong) TLTextField *nameTF;
//专长领域
@property (nonatomic, strong) TLTextField *expertiseTF;
//广告语
@property (nonatomic, strong) TLTextField *sloginTF;
//授课风格
@property (nonatomic, strong) TLPickerTextField *stylePicker;
//个人简介
@property (nonatomic, strong) TLTextView *introduceTV;
@property (nonatomic, strong) BaseView *introduceView;
//风格列表
@property (nonatomic, strong) NSMutableArray *styles;
@property (nonatomic, strong)  NSArray <DataDictionaryModel *>*data;
//资料
@property (nonatomic, strong) MyInfomationModel *infomation;
//选择的风格
@property (nonatomic) NSMutableString *style;
@property (nonatomic) NSMutableString *styleID;

@end

@implementation MyInfomationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的资料";
    
    self.styles = [NSMutableArray arrayWithObject:@"清空选择"];
    self.style = [NSMutableString stringWithString:@""];
    self.styleID = [NSMutableString stringWithString:@""];
    
    [self initSubviews];
    //获取风格数据
    [self requestStyleList];
}

#pragma mark - Init
- (void)initSubviews {
    
    BaseWeakSelf;
    
    CGFloat h = 50;
    CGFloat leftMargin = 15;
    CGFloat titleWidth = 80;
    CGFloat count = 4;
    
    self.bgSV.frame = CGRectMake(0, 0, kScreenWidth, kSuperViewHeight);
    
    [self.view addSubview:self.bgSV];
    
    
    //姓名
    self.nameTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, h)
                                           leftTitle:@"姓名" titleWidth:titleWidth placeholder:@"输入名字"];
    
    self.nameTF.leftLbl.font = Font(14.0);
    
    [self.bgSV addSubview:self.nameTF];
    
    //专长领域
    self.expertiseTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.nameTF.yy, kScreenWidth, h)
                                           leftTitle:@"专长领域" titleWidth:titleWidth placeholder:@"请简单填写你擅长的领域"];
    
    self.expertiseTF.leftLbl.font = Font(14.0);
    
    [self.bgSV addSubview:self.expertiseTF];
    //广告语
    self.sloginTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.expertiseTF.yy, kScreenWidth, h)
                                                leftTitle:@"个性签名" titleWidth:titleWidth placeholder:@"请填写个性签名"];
    
    self.sloginTF.leftLbl.font = Font(14.0);
    
    [self.bgSV addSubview:self.sloginTF];
    //授课风格
    self.stylePicker = [[TLPickerTextField alloc] initWithFrame:CGRectMake(0, self.sloginTF.yy, kScreenWidth, h)
                                                      leftTitle:@"授课风格"
                                                     titleWidth:titleWidth
                                                    placeholder:@"请选择授课风格"];
    
    self.stylePicker.leftLbl.font = Font(14.0);
    self.stylePicker.didSelectBlock = ^(NSInteger index) {
        
        [weakSelf selectStyleWithIndex:index];
    };
    
    [self.bgSV addSubview:self.stylePicker];
    //右箭头
    CGFloat arrowW = 6;
    CGFloat arrowH = 10;
    CGFloat rightMargin = 10;
    
    UIImageView *arrowIV = [[UIImageView alloc] initWithImage:kImage(@"更多-灰色")];
    
    arrowIV.frame = CGRectMake(self.stylePicker.width - rightMargin - arrowW, 0, arrowW, arrowH);
    arrowIV.centerY = self.stylePicker.height/2.0;
    
    [self.stylePicker addSubview:arrowIV];
    
    //个人简介
    self.introduceView = [[BaseView alloc] initWithFrame:CGRectMake(0, self.stylePicker.yy + 1, kScreenWidth, 155)];
    
    self.introduceView.backgroundColor = kWhiteColor;
    
    [self.bgSV addSubview:self.introduceView];
    //
    UILabel *introduceLbl = [UILabel labelWithFrame:CGRectMake(leftMargin, leftMargin, 100, kFontHeight(14.0))
                                       textAligment:NSTextAlignmentLeft
                                    backgroundColor:kClearColor
                                               font:Font(14.0)
                                          textColor:kTextColor];
    
    introduceLbl.text = @"个人简介";
    
    [self.introduceView addSubview:introduceLbl];
    
    self.introduceTV = [[TLTextView alloc] initWithFrame:CGRectMake(0, introduceLbl.yy, kScreenWidth, 125)];
    
    self.introduceTV.placeholderLbl.origin = CGPointMake(15, 15);
    self.introduceTV.placeholderLbl.font = Font(14.0);
    self.introduceTV.textContainerInset = UIEdgeInsetsMake(17, 10, 0, 0);
    self.introduceTV.placholder = @"请介绍下你自己吧";
    
    [self.introduceView addSubview:self.introduceTV];
    
    //
    for (int i = 0; i < count; i++) {
        
        //line
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(leftMargin, (i+1)*h, kScreenWidth - leftMargin, 0.5)];
        
        line.backgroundColor = kLineColor;
        
        [self.bgSV addSubview:line];
    }
    
    //保存
    [UIBarButtonItem addRightItemWithTitle:@"保存"
                                titleColor:kWhiteColor
                                     frame:CGRectMake(0, 0, 40, 44)
                                        vc:self
                                    action:@selector(saveInfo)];
}

#pragma mark - Events
- (void)saveInfo {
    
    if (![self.nameTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入姓名"];
        return;
    }
    
    if (![self.expertiseTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请简单填写你擅长的领域"];
        return;
    }
    
    if (![self.sloginTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请填写个性签名"];
        return;
    }
    
    if (![self.stylePicker.text valid]) {
        
        [TLAlert alertWithInfo:@"请选择授课风格"];
        return;
    }
    
    if (![self.introduceTV.text valid]) {
        
        [TLAlert alertWithInfo:@"请介绍下你自己吧"];
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805530";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"realName"] = self.nameTF.text;
    http.parameters[@"speciality"] = self.expertiseTF.text;
    http.parameters[@"slogan"] = self.sloginTF.text;
    http.parameters[@"description"] = self.introduceTV.text;
    http.parameters[@"style"] = self.styleID;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"保存成功"];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)selectStyleWithIndex:(NSInteger)index {
    
    BaseWeakSelf;
    
    if (index == 0) {
        
        self.stylePicker.text = @"";
        self.style = [NSMutableString stringWithString:@""];
        self.styleID = [NSMutableString stringWithString:@""];

    } else {
        
        [self.data enumerateObjectsUsingBlock:^(DataDictionaryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.dvalue isEqualToString:weakSelf.styles[index]]) {
                
                if (![self.style containsString:obj.dvalue]) {
                    
                    [self.style appendString:[NSString stringWithFormat:@"%@  ", obj.dvalue]];
                    [self.styleID appendString:[NSString stringWithFormat:@"%ld,", obj.ID]];

                }
            }
        }];
        
        self.stylePicker.text = self.style;
    }
}

#pragma mark - Data
/**
 根据userId查询最新的一条修改资料
 */
- (void)requestLastInfo {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805537";
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.infomation = [MyInfomationModel mj_objectWithKeyValues:responseObject[@"data"]];
        //姓名为空就跳过
        if (![self.infomation.realName valid]) {
            
            //第一次用户未填写数据时
            [self changeInfo];
            return ;
        }
        //姓名
        NSString *name = self.infomation.realName;
        STRING_NIL_NULL(name);
        self.nameTF.text = name;
        //专家领域
        NSString *speciality = self.infomation.speciality;
        STRING_NIL_NULL(speciality);
        self.expertiseTF.text = speciality;
        //广告语
        NSString *slogan = self.infomation.slogan;
        STRING_NIL_NULL(slogan);
        self.sloginTF.text = slogan;
        //授课风格
        NSArray *arr = [self.infomation.style componentsSeparatedByString:@","];
        [arr enumerateObjectsUsingBlock:^(NSString *  _Nonnull index, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self.data enumerateObjectsUsingBlock:^(DataDictionaryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([index isEqualToString:obj.dkey]) {
                    
                    [self.style appendString:[NSString stringWithFormat:@"%@  ", obj.dvalue]];
                }
            }];
        }];
        
        STRING_NIL_NULL(self.infomation.style);
        
        [self.styleID appendString:self.infomation.style];

        self.stylePicker.text = self.style;
        //个人简介
        NSString *introduce = self.infomation.desc;
        STRING_NIL_NULL(introduce);
        self.introduceTV.text = introduce;
        //状态
        switch ([self.infomation.status integerValue]) {
            case 1:
            {
                self.title = @"我的资料(待审核)";
                self.navigationItem.rightBarButtonItem = nil;
            }break;
                
            case 2:
            {
                self.title = @"我的资料(审核不通过)";
            }break;
                
            case 3:
            {
                self.title = @"我的资料";
            }break;
                
            default:
                break;
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestStyleList {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805906";
    http.parameters[@"parentKey"] = @"style";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.data = [DataDictionaryModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [self.data enumerateObjectsUsingBlock:^(DataDictionaryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self.styles addObject:obj.dvalue];
        }];
        
        self.stylePicker.tagNames = self.styles;
        //根据userId查询最新的一条修改资料
        [self requestLastInfo];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)changeInfo {
    
    //姓名
    NSString *name = [TLUser user].realName;
    STRING_NIL_NULL(name);
    self.nameTF.text = name;
    //专家领域
    NSString *speciality = [TLUser user].speciality;
    STRING_NIL_NULL(speciality);
    self.expertiseTF.text = speciality;
    //广告语
    NSString *slogan = [TLUser user].slogan;
    STRING_NIL_NULL(slogan);
    self.sloginTF.text = slogan;
    //授课风格
    NSArray *arr = [[TLUser user].style componentsSeparatedByString:@","];
    [arr enumerateObjectsUsingBlock:^(NSString *  _Nonnull index, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self.data enumerateObjectsUsingBlock:^(DataDictionaryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([index isEqualToString:obj.dkey]) {
                
                [self.style appendString:[NSString stringWithFormat:@"%@  ", obj.dvalue]];
            }
        }];
    }];
    
    STRING_NIL_NULL(self.infomation.style);
    
    [self.styleID appendString:self.infomation.style];
    
    self.stylePicker.text = self.style;
    //个人简介
    NSString *introduce = [TLUser user].introduce;
    STRING_NIL_NULL(introduce);
    self.introduceTV.text = introduce;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
