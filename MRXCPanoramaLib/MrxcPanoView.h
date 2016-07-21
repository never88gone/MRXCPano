//
//  MrxcPanoView.h
//  MrxcPano
//
//  Created by never88gone on 16/3/23.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRXCFuncDefine.h"
#import "PLView.h"
#import "PLView+Panorama.h"
#import "MRXCPanoramaStation.h"
#import "PanoDataSourceBase.h"
#define  _PANORAMA_THUMBNAIL_SIZE_  128.0
typedef NS_ENUM(NSInteger, ParnoramaType){
    ParnoramaStreet,
    ParnoramaTemp
};
@interface MrxcPanoView : UIView<PLViewBaseTouchEventProtocol>
/**
 *  全景的数据源
 */
@property(strong, nonatomic) id<PanoDataSourceBase> dataSource;
@property(strong, nonatomic)NSString *panoramaID;
@property(strong, nonatomic)PLView *plView;
@property(strong, nonatomic)MRXCPanoramaStation *panoramaData;
@property(strong, nonatomic)NSArray<MRXCPanoramaRoadLink*> *adjacentPano;
@property(assign, nonatomic)BOOL isAdjacentStatus;
@property(assign, nonatomic) ParnoramaType ptype;
@property(assign, nonatomic)double handPanoYaw;

-(void)initWithDataSource:(id<PanoDataSourceBase> )panoramaDataSourceProtocol;
/**
 *  根据ID定位全景
 *
 *  @param panoID 全景ID
 */
-(void)locPanoByPanoID:(NSString*)panoID;

/**
 *  根据经纬度定位全景
 *
 *  @param lon       经度
 *  @param lat       纬度
 *  @param tolerance 查询范围
 */
-(void)locPanoByLon:(float)lon Lat:(float)lat Tolerance:(float)tolerance;

@end
