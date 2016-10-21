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
#import "MRXCTXPanoSource.h"
#import "BDPanoSource.h"
#import "ShareColor.h"
@interface ViewController ()
@property(nonatomic,strong)   MrxcPanoView*  mrxcPanoView;
@property(nonatomic,weak) IBOutlet  UIButton*  btnTypeMenu;
@property(nonatomic,weak) IBOutlet  UIButton*  btnAboutMenu;

@property(nonatomic,strong) NSString *localpath;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnAboutMenu.layer.cornerRadius=5;
    self.btnTypeMenu.layer.cornerRadius=5;
    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    self.mrxcPanoView=[[MrxcPanoView alloc] initWithFrame:frame];
    [self.view addSubview:self.mrxcPanoView];
    [self.view bringSubviewToFront:self.btnTypeMenu];
    [self.view bringSubviewToFront:self.btnAboutMenu];
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    self.localpath = [cachesPath stringByAppendingPathComponent:@"MRXC_IMAGE.db"];
    
    [self  locationTXPano];
}
-(Boolean)showLeftItem
{
    return false;
}
-(Boolean)showRightItem
{
    return false;
}
-(NSString*)navtitle
{
    return @"铭若星晨全景";
}
- (IBAction)btnTypeMenuClick:(UIButton*)sender
{
    KxMenuItem *txMenuItem=[KxMenuItem menuItem:@"腾讯全景" image:nil target:self action:@selector( locationTXPano)];
    KxMenuItem * locationMenuItem=[KxMenuItem menuItem:@"本地全景" image:nil target:self action:@selector( locationCubePano)];
    KxMenuItem *zhdMenuItem=[KxMenuItem menuItem:@"海达全景" image:nil target:self action:@selector( locationZHDPano)];
    KxMenuItem *mrxcMenuItem=[KxMenuItem menuItem:@"铭若星晨全景" image:nil target:self action:@selector( locationZHDPano)];
    KxMenuItem *baiduMenuItem=[KxMenuItem menuItem:@"百度全景" image:nil target:self action:@selector( locationBaiduPano)];
    KxMenuItem *mrxcTXMenuItem=[KxMenuItem menuItem:@"铭若星晨腾讯全景" image:nil target:self action:@selector( locationBaiduPano)];
    KxMenuItem *googleMenuItem=[KxMenuItem menuItem:@"GOOGLE全景" image:nil target:self action:@selector( locationBaiduPano)];
    NSArray* menus=@[txMenuItem, locationMenuItem,zhdMenuItem,mrxcMenuItem,baiduMenuItem,mrxcTXMenuItem,googleMenuItem];
    [KxMenu setTintColor:[ShareColor mainColor]];
    [KxMenu showMenuInView:self.view fromRect:sender.frame menuItems:menus];
}
- (IBAction)btnAboutMenuClick:(UIButton*)sender
{
    KxMenuItem *aboutMenuItem=[KxMenuItem menuItem:@"关于我们" image:nil target:self action:@selector(goAboutUS)];
    KxMenuItem *contactMenuItem=[KxMenuItem menuItem:@"联系我们" image:nil target:self action:@selector(goContactUS)];
    NSArray* menus=@[aboutMenuItem,contactMenuItem];
    [KxMenu showMenuInView:self.view fromRect:sender.frame menuItems:menus];
}

-(void)downLocalPanoData
{
    MBProgressHUD* mbProgressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:mbProgressHUD];
    mbProgressHUD.label.text = @"正在下载";
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
         [self  locationExistCubePano];
    }];
    [downloadTask resume];
    
}

/**
 查看本地的六面体全景数据，没有数据从服务器上下载一份测试数据
 */
-(void) locationCubePano
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.localpath]) {
        [self  locationExistCubePano];
    }else
    {
        [self downLocalPanoData];
    }
}
/**
 查看本地的全景数据
 */
-(void) locationExistCubePano
{
    NSString *panoramaID=@"000000001-01-20130702033058609";
    LocalCubePanoSource* localCubePanoSource=[[LocalCubePanoSource alloc] init];
    localCubePanoSource.filePath=self.localpath;
    [self.mrxcPanoView initWithDataSource:localCubePanoSource];
    [self.mrxcPanoView locPanoByPanoID:panoramaID];
}
/**
 查看中海达的全景数据
 */
-(void) locationZHDPano
{
    NSString *panoramaID=@"B101-20150506000018";
    ZHDPanoSource * zhdPanoSource=[[ZHDPanoSource alloc] init];
    zhdPanoSource.panoramaUrl=@"http://www.szmuseum.com/0pano/DigitalMusBaseServices";
    [self.mrxcPanoView initWithDataSource:zhdPanoSource];
    [self.mrxcPanoView locPanoByPanoID:panoramaID];
}
/**
 查看腾讯的全景数据
 */
-(void) locationTXPano
{
    NSString *panoramaID=@"10141217150929133814400";
    TXPanoSource* txPanoSource=[[TXPanoSource alloc] init];
    [self.mrxcPanoView initWithDataSource:txPanoSource];
    [self.mrxcPanoView locPanoByPanoID:panoramaID];
}
/**
 查看本地的铭若星晨的全景数据
 */
-(void) locationMRXCPano
{
    NSString *panoramaID=@"000000001-01-20130702033058609";
    MRXCPanoSource * mrxcPanoSource=[[MRXCPanoSource alloc] init];
    mrxcPanoSource.panoramaUrl=@"http://139.196.203.199:8084/geoserver/";
    [self.mrxcPanoView initWithDataSource:mrxcPanoSource];
    [self.mrxcPanoView locPanoByPanoID:panoramaID];
}
/**
 查看本地的百度的全景数据
 */
-(void) locationBaiduPano
{
    NSString *panoramaID=@"02000200001407221216223508C";
    BDPanoSource * mrxcPanoSource=[[BDPanoSource alloc] init];
    [self.mrxcPanoView initWithDataSource:mrxcPanoSource];
    [self.mrxcPanoView locPanoByPanoID:panoramaID];
}
/**
 查看铭若星晨使用百度数据重新发布的全景数据
 */
-(void) locationMRXCTXPano
{
    NSString *panoramaID=@"000000001-01-20130702033058609";
    MRXCTXPanoSource * mrxcPanoSource=[[MRXCTXPanoSource alloc] init];
    mrxcPanoSource.panoramaUrl=@"http://139.196.203.199:8084/geoserver/";
    [self.mrxcPanoView initWithDataSource:mrxcPanoSource];
    [self.mrxcPanoView locPanoByPanoID:panoramaID];
}
/**
 查看本地的GOOGLE的全景数据
 */
-(void) locationGooglePano
{
    
}

/**
关于我们
 */
-(void)goAboutUS
{
    [self preToVC:@"MRXCAboutVC" WithParam:nil];
}
/**
 联系我们
 */
-(void)goContactUS
{
    [self preToVC:@"MRXCAboutVC" WithParam:nil];
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
