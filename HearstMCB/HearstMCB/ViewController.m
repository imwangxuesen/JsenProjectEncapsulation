//
//  ViewController.m
//  HearstMCB
//
//  Created by WangXuesen on 15/12/2.
//  Copyright © 2015年 hearst. All rights reserved.
//

#import "ViewController.h"
#import "JsenModel.h"
#import "JsenTabBarItem.h"
#import "JsenTabBarItemMgr.h"
#import "JsenTabBarItemAttribute.h"
@interface ViewController ()<JsenModelDelegate,JsenBaseModelDelegate>
@property (nonatomic , strong)JsenModel * jsenModel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
   JsenTabBarItem *item = [JsenTabBarItemMgr mgrTabBarItem:[[JsenTabBarItemAttribute alloc] initWithTitle:@"nihDDDao" imageNameForSel:@"img_avatar" imageNameForNor:@"img_avatar"] frame:CGRectMake(100, 100, 78, 40)];
    [item configBageNum:@"1"];
    [self.view addSubview:item];
    
    
    self.jsenModel = [[JsenModel alloc] init];
    self.jsenModel.modelDelegate = self;
    self.jsenModel.delegate = self;
    NSMutableDictionary *home_dict = [[NSMutableDictionary alloc] init];
    [home_dict setObject:@""       forKey:@"fromdateline"];
    [home_dict setObject:@""       forKey:@"todateline"];
    [home_dict setObject:@"0"     forKey:@"page"];
    [home_dict setObject:@"20"   forKey:@"perpage"];
    NSDictionary *params = @{
                             @"username":@"wangxuesen",
                             @"password":@"123456",
                             @"loginsubmit":@"ture"
                             };
    [self.jsenModel docallLoginRequest:params];
    [self.jsenModel docallHomeRequest:home_dict];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - JsenBaseModelDelegate
- (void)homeRequestStarted:(id)obj {
    
    JSENLOGINFO(@"home1 homeRequestStarted");
}

- (void)homeRequestCanceled:(JsenRequestResponseFailure *)jsenFail {
    
    JSENLOGINFO(@"home1 homeRequestCanceled");
}

- (void)homeRequestFailed:(JsenRequestResponseFailure *)jsenFail {
    
    JSENLOGINFO(@"home1 homeRequestFailed");
}

- (void)homeRequestFinished:(JsenRequestResponseSuccess *)suceess {
    JSENLOGINFO(@"home1 homeRequestFinished");
    
}

- (void)loginRequestStarted:(id)obj {
    
    JSENLOGINFO(@"login loginRequestStarted");
}

- (void)loginRequestCanceled:(JsenRequestResponseFailure *)jsenFail {
    JSENLOGINFO(@"login loginRequestCanceled");
    
}

- (void)loginRequestFailed:(JsenRequestResponseFailure *)jsenFail {

    JSENLOGINFO(@"login loginRequestFailed");
}

- (void)loginRequestFinished:(JsenRequestResponseSuccess *)suceess {
    NSDictionary *dic = (NSDictionary *)suceess.userInfo;
    NSDictionary *dat = dic[@"data"];
    NSDictionary *var = dat[@"Variables"];
    NSString *forhash = var[@"formhash"];

    
    JSENLOGINFO(@"login loginRequestFinished");
    [USER_DEFAULT setObject:forhash forKey:@"forhash"];
    [USER_DEFAULT synchronize];
    
    
    NSDictionary *paramsup = @{@"avatarsubmit":@"yes",
                               @"formhash":[USER_DEFAULT objectForKey:@"forhash"],
                               @"img_avatar":[UIImage imageNamed:@"img_avatar.png"],
                               };
    
    [self.jsenModel docallUploadHeaderRequest:paramsup];
}

@end
