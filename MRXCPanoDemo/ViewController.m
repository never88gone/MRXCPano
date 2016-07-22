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
@interface ViewController ()
@property(nonatomic,strong)   MrxcPanoView*  mrxcPanoView;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = CGRectMake(0, 0, UI_CURRENT_SCREEN_WIDTH, UI_CURRENT_SCREEN_HEIGHT);
    self.mrxcPanoView=[[MrxcPanoView alloc] initWithFrame:frame];
    [self.view addSubview:self.mrxcPanoView];
    self.panoTypeSegment.selectedSegmentIndex=1;
    [self.view bringSubviewToFront:self.panoTypeSegment];
    NSString* filePath=[self copyDBData];
    NSString *panoramaID=@"000000001-01-20130702033058609";
    LocalCubePanoSource* localCubePanoSource=[[LocalCubePanoSource alloc] init];
    localCubePanoSource.filePath=filePath;
    [self.mrxcPanoView initWithDataSource:localCubePanoSource];
    [self.mrxcPanoView locPanoByPanoID:panoramaID];
}



- (IBAction)segmentChanged:(UISegmentedControl*)segmentedControl {
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
        {
            NSString* filePath=[self copyDBData];
            NSString *panoramaID=@"000000001-01-20130702033058609";
            LocalCubePanoSource* localCubePanoSource=[[LocalCubePanoSource alloc] init];
            localCubePanoSource.filePath=filePath;
            [self.mrxcPanoView initWithDataSource:localCubePanoSource];
            [self.mrxcPanoView locPanoByPanoID:panoramaID];
        }
            break;
    case 1:
        {
            NSString *panoramaID=@"B101-20150506000018";
            ZHDPanoSource * zhdPanoSource=[[ZHDPanoSource alloc] init];
            zhdPanoSource.panoramaUrl=@"http://www.szmuseum.com/0pano/DigitalMusBaseServices";
            [self.mrxcPanoView initWithDataSource:zhdPanoSource];
            [self.mrxcPanoView locPanoByPanoID:panoramaID];
        }
        break;
    case 2:
        {
            NSString *panoramaID=@"10141217150929133814400";
            TXPanoSource* txPanoSource=[[TXPanoSource alloc] init];
            [self.mrxcPanoView initWithDataSource:txPanoSource];
            [self.mrxcPanoView locPanoByPanoID:panoramaID];
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
