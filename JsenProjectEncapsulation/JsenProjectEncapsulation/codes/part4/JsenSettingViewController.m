//
//  JsenSettingViewController.m
//  HearstMCB
//
//  Created by WangXuesen on 15/12/11.
//  Copyright © 2015年 hearst. All rights reserved.
//

#import "JsenSettingViewController.h"
#import "UINavigationBar+Expansion.h"
#import "JsenTitleView.h"
#import "JsenTabBarControllerMgr.h"
#import "PingInvertTransition.h"
#import <objc/runtime.h>
@interface JsenSettingViewController()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>
@property(nonatomic , strong)UIPercentDrivenInteractiveTransition *percentTransiton;
@end

@implementation JsenSettingViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    JsenTitleView * view =  [JsenTitleView imageName:nil imageUrl:@"https://github.com/imwangxuesen/JsenProjectEncapsulation/blob/master/resource/jsen_titleview_remote.JPG?raw=true" title:@"Jsen_Wang" type:JsenTitleViewTypeTitleAndImage];
    self.navigationItem.titleView = view;
    
    //侧向边缘拖拽手势
    UIScreenEdgePanGestureRecognizer * edgeGes = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePan:)];
    edgeGes.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgeGes];
    
    //items
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleDone target:self action:@selector(leftItemClicked:)];
    NSArray *lefts = @[
                        left,
                        ];
    [self.navigationItem setLeftBarButtonItems:lefts animated:YES];
    
    //tableview
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    table.dataSource = self;
    table.delegate   = self;
    [self.view addSubview:table];
    [table reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar jsen_setBackgroundColor:[UIColor grayColor]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar jsen_reset];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jsen"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"jsen"];
    }
    [cell.textLabel setText:[NSString stringWithFormat:@"%ld",indexPath.section]];
    return cell;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 60;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 30;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0) {
        if (offsetY >= 44) {
            [self setNavigationBarTransformProgress:1];
            [[JsenTabBarControllerMgr shareMgr] hidenWithAnimation:YES];
        } else {
            [self setNavigationBarTransformProgress:(offsetY / 44)];
        }
    } else {
        [self setNavigationBarTransformProgress:0];
        [[JsenTabBarControllerMgr shareMgr] showWithAnimation:YES];
        
    }
}

#pragma mark - Private Method
- (void)setNavigationBarTransformProgress:(CGFloat)progress
{
    [self.navigationController.navigationBar jsen_setTranslationY:(-44 * progress)];
    [self.navigationController.navigationBar jsen_setElementsAlpha:(1-progress)];
}

- (void)leftItemClicked:(UIBarButtonItem *)item {
    if (self.navigationController.viewControllers[0] != self){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
#pragma mark - 转场动画
- (void)edgePan:(UIPanGestureRecognizer *)recognizer {
    CGFloat per = [recognizer translationInView:self.view].x / (self.view.bounds.size.width);
    per = MIN(1.0,(MAX(0.0, per)));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _percentTransiton  = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
    } else if(recognizer.state == UIGestureRecognizerStateChanged) {
        [_percentTransiton updateInteractiveTransition:per];
    } else if(recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateEnded) {
        if (per > 0.3) {
            [_percentTransiton finishInteractiveTransition];
        } else {
            [_percentTransiton cancelInteractiveTransition];
        }
        _percentTransiton = nil;
    }
}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    
    return _percentTransiton;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  {
    if (operation == UINavigationControllerOperationPop) {
        PingInvertTransition *pingInvert = [PingInvertTransition new];
        return pingInvert;
    }else{
        return nil;
    }
    
}


@end
