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
    NSString *panoramaID=@"B101-20150506000018";
    ZHDPanoSource * zhdPanoSource=[[ZHDPanoSource alloc] init];
    zhdPanoSource.panoramaUrl=@"http://www.szmuseum.com/0pano/DigitalMusBaseServices";
    [self.mrxcPanoView initWithDataSource:zhdPanoSource];
    [self.mrxcPanoView locPanoByPanoID:panoramaID];
}



- (IBAction)segmentChanged:(UISegmentedControl*)segmentedControl {
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
        {

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
@end
