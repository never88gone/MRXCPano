//
//  ViewController.m
//  MrxcPano
//
//  Created by never88gone on 16/3/22.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import "ViewController.h"
#import "MrxcPanoView.h"
#import "TXPanoSource.h"
#import "MrxcPanoView.h"
#import "ZHDPanoSource.h"
#import "LocalCubePanoSource.h"
#import "KXMenu.h"
#import "AFURLSessionManager.h"
#import "MBProgressHUD.h"
#import "MRXCPanoSource.h"
@interface ViewController ()
@property(nonatomic,strong)   MrxcPanoView*  mrxcPanoView;
@property(nonatomic,weak) IBOutlet  UIButton*  btnMenu;

@property(nonatomic,strong) NSString *localpath;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = CGRectMake(0, 0, UI_CURRENT_SCREEN_WIDTH, UI_CURRENT_SCREEN_HEIGHT);
    self.mrxcPanoView=[[MrxcPanoView alloc] initWithFrame:frame];
    [self.view addSubview:self.mrxcPanoView];
    [self.view bringSubviewToFront:self.btnMenu];
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    self.localpath = [cachesPath stringByAppendingPathComponent:@"MRXC_IMAGE.db"];
    
    [self localTXPano];
}

- (IBAction)btnMenuClick:(UIButton*)sender
{
    KxMenuItem *txMenuItem=[KxMenuItem menuItem:@"腾讯全景" image:nil target:self action:@selector(localTXPano)];
    KxMenuItem *localMenuItem=[KxMenuItem menuItem:@"本地全景" image:nil target:self action:@selector(localCubePano)];
    KxMenuItem *zhdMenuItem=[KxMenuItem menuItem:@"海达全景" image:nil target:self action:@selector(localZHDPano)];
    KxMenuItem *mrxcMenuItem=[KxMenuItem menuItem:@"铭若星晨全景" image:nil target:self action:@selector(localZHDPano)];
    NSArray* menus=@[txMenuItem,localMenuItem,zhdMenuItem,mrxcMenuItem];
    [KxMenu showMenuInView:self.view fromRect:sender.frame menuItems:menus];
}

-(void)downLocalPanoData
{
    MBProgressHUD* mbProgressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:mbProgressHUD];
    mbProgressHUD.labelText = @"正在下载";
    
    //设置模式为进度框形的
    mbProgressHUD.mode = MBProgressHUDModeDeterminate;
    [mbProgressHUD showAnimated:YES];
    
    //远程地址
    NSURL *URL = [NSURL URLWithString:@"http://139.196.203.199:8084/data/MRXC_IMAGE.db"];
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //AFN3.0+基于封住URLSession的句柄
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //下载Task操作
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        // 回到主队列刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            // 设置进度条的百分比
            mbProgressHUD.progress=1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:self.localpath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [mbProgressHUD hideAnimated:true];
         [self localExistCubePano];
    }];
    [downloadTask resume];
    
}
-(void)localCubePano
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.localpath]) {
        [self localExistCubePano];
    }else
    {
        [self downLocalPanoData];
    }
}
-(void)localExistCubePano
{
    NSString *panoramaID=@"000000001-01-20130702033058609";
    LocalCubePanoSource* localCubePanoSource=[[LocalCubePanoSource alloc] init];
    localCubePanoSource.filePath=self.localpath;
    [self.mrxcPanoView initWithDataSource:localCubePanoSource];
    [self.mrxcPanoView locPanoByPanoID:panoramaID];
}

-(void)localZHDPano
{
    NSString *panoramaID=@"B101-20150506000018";
    ZHDPanoSource * zhdPanoSource=[[ZHDPanoSource alloc] init];
    zhdPanoSource.panoramaUrl=@"http://www.szmuseum.com/0pano/DigitalMusBaseServices";
    [self.mrxcPanoView initWithDataSource:zhdPanoSource];
    [self.mrxcPanoView locPanoByPanoID:panoramaID];
}
-(void)localTXPano
{
    NSString *panoramaID=@"10141217150929133814400";
    TXPanoSource* txPanoSource=[[TXPanoSource alloc] init];
    [self.mrxcPanoView initWithDataSource:txPanoSource];
    [self.mrxcPanoView locPanoByPanoID:panoramaID];
}
-(void)localMRXCPano
{
    NSString *panoramaID=@"000000001-01-20130702033058609";
    MRXCPanoSource * mrxcPanoSource=[[MRXCPanoSource alloc] init];
    mrxcPanoSource.panoramaUrl=@"http://139.196.203.199:8084/geoserver/";
    [self.mrxcPanoView initWithDataSource:mrxcPanoSource];
    [self.mrxcPanoView locPanoByPanoID:panoramaID];
}


- (IBAction)segmentChanged:(UISegmentedControl*)segmentedControl {
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
        {
            [self localCubePano];
        }
            break;
    case 1:
        {
            [self localZHDPano];
        }
        break;
    case 2:
        {
            [self localTXPano];
        }
        break;
    case 3:
        {
          
        }
        break;
        default:
            break;
    }
    
}

- (NSString*) copyDBData
{
    NSString * docPath = [[NSBundle mainBundle] pathForResource:@"MRXC_IMAGE" ofType:@"db"];
    NSString * appDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSString *appLib = [appDir stringByAppendingString:@"/Caches"];
    NSString* dataPath= [self copyMissingFile:docPath toPath:appLib];
    return dataPath;
}
- (NSString*)copyMissingFile:(NSString *)sourcePath toPath:(NSString *)toPath

{
    BOOL retVal = YES;
    NSString * finalLocation = [toPath stringByAppendingPathComponent:[sourcePath lastPathComponent]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:finalLocation])
    {
        retVal = [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:finalLocation error:NULL];
    }
    if (retVal) {
        return finalLocation;
    }else{
        return nil;
    }
}
@end
