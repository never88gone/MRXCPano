//
//  ViewController.m
//  MrxcPano
//
//  Created by never88gone on 16/3/22.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import "ViewController.h"
#import "ZHDPanoSource.h"
#import "TXPanoSource.h"
@interface ViewController ()
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = CGRectMake(0, 0, UI_CURRENT_SCREEN_WIDTH, UI_CURRENT_SCREEN_HEIGHT);
    MrxcPanoView*  mrxcPanoView=[[MrxcPanoView alloc] initWithFrame:frame];
    [self.view addSubview:mrxcPanoView];
//    NSString *panoramaSite=@"";
    NSString *panoramaID=@"10141050150728115613700";
//    ZHDPanoSource * zhdPanoSource=[[ZHDPanoSource alloc] init];
//    zhdPanoSource.panoramaUrl=panoramaSite;
//    [mrxcPanoView initWithDataSource:zhdPanoSource];
    TXPanoSource* txPanoSource=[[TXPanoSource alloc] init];
    [mrxcPanoView initWithDataSource:txPanoSource];
    [mrxcPanoView locPanoByPanoID:panoramaID];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
