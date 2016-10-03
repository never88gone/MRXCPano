//
//  BaseVC.m
//  EPOS
//
//  Created by never88gone on 16/4/20.
//  Copyright © 2016年 mrxc. All rights reserved.
//

#import "BaseVC.h"
#import "ShareColor.h"

@implementation BaseVC


-(void)viewDidLoad
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
//    改变后需要及时刷新的调用
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self.navigationController.navigationBar setBarTintColor:[ShareColor mainColor]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[ShareColor whiteColor]}];

    UIButton *leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage*  leftNormalImage = [UIImage imageNamed:@"返回"];
    leftbtn.frame = CGRectMake(0, 0, leftNormalImage.size.width*20/leftNormalImage.size.height, 20);
    [leftbtn setFont:[UIFont systemFontOfSize:12]];
    [leftbtn setTitleColor:[ShareColor mainColor] forState:UIControlStateNormal];
    SEL   leftSelector = @selector(leftBtnClicked:);
    [leftbtn addTarget:self action:leftSelector forControlEvents:UIControlEventTouchUpInside];
    
    [leftbtn setBackgroundImage:leftNormalImage forState:UIControlStateNormal];
    self.leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
    self.navigationItem.leftBarButtonItem= self.leftBtnItem;
    if (![self showLeftItem]) {
        self.navigationItem.leftBarButtonItem=nil;
    }
   
    
    UIButton *rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbtn.frame = CGRectMake(0, 0, 40, 20);
    [rightbtn setFont:[UIFont systemFontOfSize:14]];
    [rightbtn setTitleColor:[ShareColor mainColor] forState:UIControlStateNormal];
    SEL   rightSelector = @selector(rightBtnClicked:);
    [rightbtn addTarget:self action:rightSelector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
    self.navigationItem.rightBarButtonItem= rightBtnItem;
    if (![self showRightItem]) {
        self.navigationItem.rightBarButtonItem=nil;
    }
     self.navigationItem.title=[self navtitle];
    [super viewDidLoad];
}
#pragma 标题栏的管理

- (void)leftBtnClicked:(id)sender
{
    [self disMissVC];
}
- (void)rightBtnClicked:(id)sender
{
   
}
-(void)setLeftItemHidden:(BOOL)isHidden
{
    if (isHidden==true) {
        self.navigationItem.leftBarButtonItem=nil;
    }else
    {
        self.navigationItem.leftBarButtonItem=self.leftBtnItem;
    }
}
//是否显示左侧按钮
-(Boolean)showLeftItem
{
    return true;
}
//是否显示右侧按钮
-(Boolean)showRightItem
{
    return false;
}
//标题栏的问题
-(NSString*)navtitle
{
    return @"";
}
//设置左侧导航栏按钮
-(void)setLeftItemImage:(UIImage*)leftImage
{
    UIButton* leftBtn=self.navigationItem.leftBarButtonItem.customView;
    [leftBtn setBackgroundImage:leftImage forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, leftImage.size.width*20/leftImage.size.height, 20);
}
//设置右侧导航栏按钮
-(void)setRightItemImage:(UIImage*)rightImage
{
    UIButton* rightBtn=self.navigationItem.rightBarButtonItem.customView;
    [rightBtn setBackgroundImage:rightImage forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, rightImage.size.width*20/rightImage.size.height, 20);
}

//设置左侧导航栏按钮
-(void)setLeftItemText:(NSString*)leftText
{
    UIButton* leftBtn=self.navigationItem.leftBarButtonItem.customView;
    [leftBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [leftBtn setTitle:leftText forState:UIControlStateNormal];
}
//设置右侧导航栏按钮
-(void)setRightItemText:(NSString*)rightText
{
    UIButton* rightBtn=self.navigationItem.rightBarButtonItem.customView;
    [rightBtn setFont:[UIFont systemFontOfSize:17.0f]];
    [rightBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [rightBtn setTitle:rightText forState:UIControlStateNormal];
}

//设置标题栏的文字，当标题栏的文字需要改变的时候调用
-(void)setNavItemTitle:(NSString*)title
{
    self.navigationItem.title=title;
}

#pragma route
-(void) preToVC:(NSString*)vcName WithParam:(NSDictionary*) externData
{
    Class class = NSClassFromString(vcName);
    BaseVC *vc = [[class alloc] initWithNibName:nil bundle:nil];
    vc.hidesBottomBarWhenPushed=YES;
    vc.externData=externData;
    vc.baseVCBackDelegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) disMissVC
{
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.baseVCBackDelegate respondsToSelector:@selector(vcBackWithData:)]) {
        [self.baseVCBackDelegate vcBackWithData:[self.backExternData copy]];
    }
  

}
#pragma progress
-(void) showProgress
{
    [[Toast sharedInstance] showProgress:self.view];
}
//关闭当前页面加载进度
-(void) dismissProgress
{
     [[Toast sharedInstance] dismissProgress:self.view];
}
#pragma Toast
-(void)showToastMessage:(NSString*)message View:(UIView*)view
{
    [[Toast sharedInstance] showToastMessage:message View:view];
}

#pragma mark - Orientations
- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

@end
