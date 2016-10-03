//
//  BaseVC.h
//  EPOS
//
//  Created by never88gone on 16/4/20.
//  Copyright © 2016年 mrxc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Toast.h"
@protocol BaseVCBackDelegate <NSObject>

-(void)vcBackWithData:(NSDictionary*)externData;

@end

@interface BaseVC : UIViewController<BaseVCBackDelegate>
@property(nonatomic,strong) NSDictionary*  externData;
@property(nonatomic,strong) NSDictionary*  backExternData;
@property(nonatomic,weak) id<BaseVCBackDelegate>  baseVCBackDelegate;

@property(nonatomic,strong) UIBarButtonItem *leftBtnItem;
//跳转到指定名称的VC，并且传入参数
-(void) preToVC:(NSString*)vcName WithParam:(NSDictionary*) externData;
//关闭当前页面
-(void) disMissVC;
//显示当前页面加载进度
-(void) showProgress;
//关闭当前页面加载进度
-(void) dismissProgress;

-(void)showToastMessage:(NSString*)message View:(UIView*)view;

//设置标题栏的文字，当标题栏的文字需要改变的时候调用
-(void)setNavItemTitle:(NSString*)title;
-(void)setLeftItemImage:(UIImage*)leftImage;
//设置右侧导航栏按钮
-(void)setRightItemImage:(UIImage*)rightImage;
//设置左侧导航栏按钮
-(void)setLeftItemText:(NSString*)leftText;
//设置右侧导航栏按钮
-(void)setRightItemText:(NSString*)rightText;

-(void)setLeftItemHidden:(BOOL)isHidden;
@end
