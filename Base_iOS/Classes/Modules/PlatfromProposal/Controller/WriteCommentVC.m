//
//  WriteCommentVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "WriteCommentVC.h"
//V
#import "TLTextView.h"
#import "MovieAddComment.h"

@interface WriteCommentVC ()
//topView
@property (nonatomic, strong) BaseView *topView;
//建议
@property (nonatomic, strong) TLTextView *commentTV;
//
@property (nonatomic, strong) MovieAddComment *starView;
@end

@implementation WriteCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"撰写建议";
    //
    [self initSubview];
}

#pragma mark - Init
- (void)initSubview {
    
    self.topView = [[BaseView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 105)];
    
    self.topView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:self.topView];
    //
    MovieAddComment *commentView = [[MovieAddComment alloc] init];
    
    commentView.frame = CGRectMake(0, 15, 130, 40);
    commentView.centerX = kScreenWidth/2.0;
    
    [self.topView addSubview:commentView];
    self.starView = commentView;
    //使用效果
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor2
                                                    font:15.0];
    
    textLbl.frame = CGRectMake(0,commentView.yy + 15, kScreenWidth, kFontHeight(15.0));
    textLbl.textAlignment = NSTextAlignmentCenter;
    textLbl.text = @"轻点星星来评分";
    
    [self.topView addSubview:textLbl];
    
    //建议
    self.commentTV = [[TLTextView alloc] initWithFrame:CGRectMake(0, self.topView.yy + 10, kScreenWidth, 180)];
    
    self.commentTV.placeholderLbl.origin = CGPointMake(15, 15);
    self.commentTV.placeholderLbl.font = Font(13.0);
    self.commentTV.textContainerInset = UIEdgeInsetsMake(17, 10, 0, 0);
    self.commentTV.placholder = @"建议(选填)";
    
    [self.view addSubview:self.commentTV];
    //发布按钮
    UIButton *commentBtn = [UIButton buttonWithTitle:@"发送"
                                          titleColor:kWhiteColor
                                     backgroundColor:kThemeColor
                                           titleFont:16.0
                                        cornerRadius:5];
    commentBtn.frame = CGRectMake(15, self.commentTV.yy + 35, kScreenWidth - 30, 44);
    [commentBtn addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commentBtn];
}

#pragma mark - Events
- (void)sendComment {
    
    if (self.starView.count == -1) {
        
        [TLAlert alertWithInfo:@"轻点星星来评分"];
        return ;
    }
    
    [self.view endEditing:YES];

    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805400";
    http.parameters[@"commenter"] = [TLUser user].userId;
    http.parameters[@"score"] = [NSString stringWithFormat:@"%ld", self.starView.count];
    http.parameters[@"content"] = self.commentTV.text;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *code = responseObject[@"data"][@"code"];
        
        if ([code containsString:@"filter"]) {
            
            [TLAlert alertWithInfo:[NSString stringWithFormat:@"建议成功, 您的建议包含敏感字符,我们将进行审核"]];
            
            [self.navigationController popViewControllerAnimated:YES];

            return ;
        }
        
        [TLAlert alertWithSucces:[NSString stringWithFormat:@"%@成功", @"建议"]];

        if (_commentSuccess) {
            
            _commentSuccess();
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
