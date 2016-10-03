//
//  Toast.h
//  EPOS
//
//  Created by never88gone on 16/4/20.
//  Copyright © 2016年 mrxc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FuncDefine.h"
#import "MBProgressHUD.h"
@interface Toast : NSObject
AS_SINGLETON(Toast);
-(void)showToastMessage:(NSString*)message View:(UIView*)view;
-(void)showProgress:(UIView*)view;
-(void)dismissProgress:(UIView*)view;
@end
