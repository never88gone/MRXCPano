//
//  Toast.m
//  EPOS
//
//  Created by never88gone on 16/4/20.
//  Copyright © 2016年 mrxc. All rights reserved.
//

#import "Toast.h"

@implementation Toast
DEF_SINGLETON(Toast)
-(void)showToastMessage:(NSString*)message View:(UIView*)view
{
    MBProgressHUD* progressHUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:progressHUD];
    progressHUD.label.text = message;
    //HUD.backgroundColor = [UIColor redColor];
    progressHUD.mode = MBProgressHUDModeText;
    progressHUD.offset=CGPointMake(0, 200.f);
    [progressHUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [progressHUD removeFromSuperview];
    }];
}
-(void)showProgress:(UIView*)view
{
    MBProgressHUD* mbProgress = [MBProgressHUD showHUDAddedTo:view animated:YES];
    mbProgress.mode = MBProgressHUDModeIndeterminate;
}
-(void)dismissProgress:(UIView*)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}
@end
