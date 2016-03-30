//
//  MrxcPanoView.m
//  MrxcPano
//
//  Created by never88gone on 16/3/23.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import "MrxcPanoView.h"

@implementation MrxcPanoView
@synthesize panoramaID=_panoramaID;
@synthesize plView=_plView;
@synthesize panoramaData=_panoramaData;
@synthesize adjacentPano=_adjacentPano;
@synthesize isAdjacentStatus=_isAdjacentStatus;
@synthesize ptype=_ptype;
@synthesize handPanoYaw=_handPanoYaw;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self != nil){
        _plView = [[PLView alloc]initWithFrame:frame];
        _plView.translatesAutoresizingMaskIntoConstraints = NO;
        _plView.isDeviceOrientationEnabled = NO;
        _plView.isAccelerometerEnabled = NO;
        _plView.isScrollingEnabled = NO;
        _plView.isInertiaEnabled = NO;
        _plView.delegate = self;
        [self addSubview:_plView];
    }
    return self;
}
-(void)initWithDataSource:(PanoDataSourceBase* )dataSourcebase
{
    self.dataSource=dataSourcebase;
    [self.plView initWithPanoType:[dataSourcebase getPanoramaType]];
}
-(void)locPanoByPanoID:(NSString*)panoID
{
    self.panoramaID=panoID;
    self.panoramaData.imageID=panoID;
    [[MRXCPanoramaRequest achievePanoramaRequest] achievePanoByID:self DataSource:self.dataSource  PanoID:self.panoramaID];
}

-(void)locPanoByLon:(float)lon Lat:(float)lat Tolerance:(float)tolerance
{
    [[MRXCPanoramaRequest achievePanoramaRequest]  achievePanoByLonLat:self DataSource:self.dataSource  Lon:lon Lat:lat Tolerance:tolerance];
}
- (NSInteger)cubeFaceIndex:(NSInteger)tileIndex{
    switch (tileIndex) {
        case 1:
            return 1;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 0;
            break;
        case 4:
            return 2;
            break;
        case 5:
            return 4;
            break;
        case 6:
            return 5;
            break;
        default:
            break;
    }
    return 0;
}
- (void)requestPanoTileByID:(int)face{
    MRXCPanoramaRequestData *data = nil;
    for(int row = 0; row < 2; row ++){
        for(int col = 0; col < 2; col ++){
            data = [MRXCPanoramaRequestData panoramaRequestData:self.panoramaID level:_PANORAMA_LEVEL_ face:face row:row col:col];
            [[MRXCPanoramaRequest achievePanoramaRequest] achievePanoTileByID:self DataSource:self.dataSource PanoramaRequestData:data];
        }
    }
}
#pragma mark -
#pragma mark - MRXCPanoramaRequestProtocol
- (void)achievePanoByLonLatResponse:(NSString *)response success:(BOOL)success info:(NSDictionary *)dict{
    if(success == false){
        return;
    }
    self.panoramaData = [MRXCPanoramaData createPanoramaIDData:response];
    self.panoramaID = self.panoramaData.imageID;
    //准备获取缩略图
    [[MRXCPanoramaRequest achievePanoramaRequest]achievePanoThumbnailByID:self DataSource:self.dataSource  PanoID:self.panoramaData.imageID];
    
}

- (void)achievePanoByIDResponse:(NSString *)response success:(BOOL)success info:(NSDictionary *)dict{
    if(success == false){
        return;
    }
    self.panoramaData = [self.dataSource getPanoramaDataByResponse:response];
    self.panoramaID = self.panoramaData.imageID;
    //准备获取缩略图
    [[MRXCPanoramaRequest achievePanoramaRequest] achievePanoThumbnailByID:self DataSource:self.dataSource  PanoID:self.panoramaData.imageID];
    
}
- (void)achievePanoThumbnailByIDResponse:(NSData *)response success:(BOOL)success info:(NSDictionary *)dict{
    self.isAdjacentStatus = false;
    [self.plView panoramaSwitchEnd];
    //    [self.plView stopAnimation];
    if(success == false){
        
    }
    //self.panoramaID = self.panoramaData.imageID;
    if(self.plView == nil){
        
    }
    else{
        //NSLog(@"remove Textures....[%d][%d]", [self.plView.textures count], self.plView.sceneElement.textures.count);
        for(PLTexture *texture in self.plView.sceneElement.textures){
            [texture deleteTexture];
        }
        [self.plView.textures removeAllObjects];
        [self.plView.sceneElement removeAllTextures];
        
        @try {
            for(PLSceneElement *element in self.plView.scene.elements){
                if(![element isKindOfClass:[PLArrow class]]){
                    continue;
                }
                if(element.textures.count == 1){
                    [[element.textures objectAtIndex:0] deleteTexture];
                    [element.textures removeAllObjects];
                }
                PLArrow *arrow = (PLArrow *)element;
                arrow.minPoint = CGPointMake(0.0, 0.0);
                arrow.maxPoint = CGPointMake(0.0, 0.0);
                arrow.isDelete = true;
            }
        }
        @catch (NSException *exception) {
            NSLog(@"NSException %@", exception);
        }
    }
    UIImage *image = [UIImage imageWithData:response];
    UIImage *rectImage = nil;
    PLTexture *texture = nil;
    if ([self.dataSource getPanoramaType]==PanoramaEnumCube) {
        PLCube *cube = (PLCube *)self.plView.sceneElement;
        if(self.ptype == ParnoramaTemp){
            cube.panoYaw = [self.panoramaData.yaw doubleValue] + 90.0f;
        }
        else{
            cube.panoYaw = [self.panoramaData.yaw doubleValue] + self.handPanoYaw;
        }
        if(cube.panoYaw > 360.0){
            cube.panoYaw = cube.panoYaw - 360.0;
        }
        if(cube.panoYaw < 0.0){
            cube.panoYaw = cube.panoYaw + 360.0;
        }
        if(cube.panoYaw > 180.0f){
            cube.panoYaw = 360.0f - cube.panoYaw;
        }
        else{
            cube.panoYaw = (-1)*cube.panoYaw;
        }
        rectImage = [MRXCPanoramaTool imageInRect:image x:0 y:0 width:_PANORAMA_THUMBNAIL_SIZE_ height:_PANORAMA_THUMBNAIL_SIZE_];
        texture = [PLTexture textureWithImage:rectImage];
        [texture setTexturePlace:0 row:0 col:0 face:kCubeBackFaceIndex];
        [self.plView addTexture:texture];
        
        rectImage = [MRXCPanoramaTool imageInRect:image x:128 y:0 width:_PANORAMA_THUMBNAIL_SIZE_ height:_PANORAMA_THUMBNAIL_SIZE_];
        texture = [PLTexture textureWithImage:rectImage];
        [texture setTexturePlace:0 row:0 col:0 face:kCubeRightFaceIndex];
        [self.plView addTexture:texture];
        
        rectImage = [MRXCPanoramaTool imageInRect:image x:256 y:0 width:_PANORAMA_THUMBNAIL_SIZE_ height:_PANORAMA_THUMBNAIL_SIZE_];
        texture = [PLTexture textureWithImage:rectImage];
        [texture setTexturePlace:0 row:0 col:0 face:kCubeFrontFaceIndex];
        [self.plView addTexture:texture];
        
        rectImage = [MRXCPanoramaTool imageInRect:image x:0 y:128 width:_PANORAMA_THUMBNAIL_SIZE_ height:_PANORAMA_THUMBNAIL_SIZE_];
        texture = [PLTexture textureWithImage:rectImage];
        [texture setTexturePlace:0 row:0 col:0 face:kCubeLeftFaceIndex];
        [self.plView addTexture:texture];
        
        rectImage = [MRXCPanoramaTool imageInRect:image x:128 y:128 width:_PANORAMA_THUMBNAIL_SIZE_ height:_PANORAMA_THUMBNAIL_SIZE_];
        texture = [PLTexture textureWithImage:rectImage];
        [texture setTexturePlace:0 row:0 col:0 face:kCubeTopFaceIndex];
        [self.plView addTexture:texture];
        
        rectImage = [MRXCPanoramaTool imageInRect:image x:256 y:128 width:_PANORAMA_THUMBNAIL_SIZE_ height:_PANORAMA_THUMBNAIL_SIZE_];
        texture = [PLTexture textureWithImage:rectImage];
        [texture setTexturePlace:0 row:0 col:0 face:kCubeBottomFaceIndex];
        //获取切片
        //这里稍做优化，通过panoYaw值计算出当前正对的face，优先获取图片
        int face1 = -1, face2 = -1;
        if(cube.panoYaw == 0.00){
            face1 = 3;
        }
        if(cube.panoYaw > 0.00 && cube.panoYaw <= 90.0){
            face1 = 3;
            face2 = 4;
        }
        if(cube.panoYaw > 90.0 && cube.panoYaw <= 180.0f){
            face1 = 4;
            face2 = 1;
        }
        if(cube.panoYaw >= -90.0 && cube.panoYaw < 0.0){
            face1 = 3;
            face2 = 2;
        }
        if(cube.panoYaw >= -180.0 && cube.panoYaw < -90.0){
            face1 = 2;
            face2 = 1;
        }
        if(face1 > 0){
            [self requestPanoTileByID:face1];
        }
        if(face2 > 0){
            [self requestPanoTileByID:face2];
        }
        for(int i = 1; i <= 6; i ++){
            if(i == face1 || i == face2){
                continue;
            }
            [self requestPanoTileByID:i];
        }
    }else if ([self.dataSource getPanoramaType]==PanoramaEnumPhere)
    {
        texture = [PLTexture textureWithImage:image];
        [self.plView addTexture:texture];
    }
    
    [self.plView addTexture:texture];
    [self.plView drawView];
    //准备获取临近站点
    [[MRXCPanoramaRequest achievePanoramaRequest] achieveAdjacentPano:self DataSource:self.dataSource  PanoID:self.panoramaID];
    
    
}
- (void)achievePanoTileByIDResponse:(NSData *)response success:(BOOL)success info:(NSDictionary *)dict{
    //    NSLog(@"achievePanoTileByIDResponse begin...");
    MRXCPanoramaRequestData *data = [dict objectForKey:@"panorama"];
    if(![self.panoramaID isEqualToString:data.panoramaID]){
        return;
    }
    NSString *key = [[NSString alloc]initWithFormat:@"%@-1-%ld-%ld-%ld-%ld", data.panoramaID, data.face, data.level, data.row, data.col];
    [[MRXCPanoramaRequest achievePanoramaRequest].pictureDictionary setObject:response forKey:key];
    
    PLTexture *texture = [PLTexture textureWithImage:[UIImage imageWithData:response]];
    [texture setTexturePlace:data.level row:data.row col:data.col face:[self cubeFaceIndex:data.face]];
    [self.plView addTexture:texture];
    [self.plView drawView];
}
- (void)achieveAdjacentPanoResponse:(NSArray *)response success:(BOOL)success info:(NSDictionary *)dict{
    if(success == false){
        return;
    }
    self.adjacentPano = response;
    //NSLog(@"achieveAdjacentPanoResponse......");
    for(int i = 0; i < self.adjacentPano.count; i++){
        MRXCAdjacentPanoData *pano = [self.adjacentPano objectAtIndex:i];
        PLArrow *arrow = [[PLArrow alloc]init];
        if(self.ptype == ParnoramaTemp){
            arrow.deviation = 0.0;
        }
        else if(self.ptype == ParnoramaStreet){
            //arrow.deviation = -90.0f + self.handPanoYaw;
            arrow.deviation = -90.0f + self.handPanoYaw;
        }
        arrow.angle = [pano.angle floatValue];
        arrow.isDelete = false;
        arrow.imageID = pano.dstImageID;
        UIImage *image = [UIImage imageNamed:@"箭头上.png"];
        if (image!=nil) {
            PLTexture *texture = [PLTexture textureWithImage:image];
            [arrow addTexture:texture];
            [self.plView.scene addElement:arrow];
        }
    }
    [self.plView.camera reset];
    [self.plView drawView];
}
- (BOOL)singleTouchEventPoint:(CGPoint)point{
    //    PLCamera *camera = self.plView.camera;
    //    PLCube *cube = (PLCube *)self.plView.sceneElement;
    if(self.isAdjacentStatus == true){
        return false;
    }
    PLArrow *arrow = nil;
    for(PLSceneElement *element  in self.plView.scene.elements){
        if(![element isKindOfClass:[PLArrow class]]){
            continue;
        }
        PLArrow *scenearrow = (PLArrow *)element;
        //        if(scenearrow.isDelete != true){
        //            NSLog(@"yaw %f angle %f cube %f", camera.yaw, scenearrow.angle*180.0f/3.14f, cube.panoYaw);
        //        }
        if(scenearrow.minPoint.x+20 < 0 || scenearrow.maxPoint.x+20 < 0){
            continue;
        }
        if(scenearrow.minPoint.y + 20 < 0 || scenearrow.maxPoint.y + 20 < 0){
            continue;
        }
        if(scenearrow.maxPoint.x > self.frame.size.width+20){
            continue;
        }
        if(scenearrow.minPoint.y > self.frame.size.height){
            continue;
        }
        if(scenearrow.isDelete == true){
            continue;
        }
        if(scenearrow.minPoint.x > point.x || scenearrow.maxPoint.x < point.x){
            continue;
        }
        if(scenearrow.minPoint.y > point.y || scenearrow.maxPoint.y < point.y){
            continue;
        }
        arrow = scenearrow;
        break;
    }
    if(arrow == nil){
        return false;
    }
    //NSLog(@"singleTouchEventPoint %f %f", point.x, point.y);
    for(PLSceneElement *element  in self.plView.scene.elements){
        if(![element isKindOfClass:[PLArrow class]]){
            continue;
        }
        //PLArrow *scenearrow = (PLArrow *)element;
        //NSLog(@"[%d]minPoint x y %f %f maxPoint x y %f %f", scenearrow.isDelete,scenearrow.minPoint.x, scenearrow.minPoint.y,scenearrow.maxPoint.x, scenearrow.maxPoint.y);
    }
    self.panoramaID = arrow.imageID;
    self.isAdjacentStatus = true;
    [self.plView panoramaSwitchBegan];
    [[MRXCPanoramaRequest achievePanoramaRequest] achievePanoByID:self DataSource:self.dataSource  PanoID:self.panoramaID];
    @synchronized(self){
        for(int i = 0; i < self.plView.scene.elements.count; i++){
            PLSceneElement *element = [self.plView.scene.elements objectAtIndex:i];
            if(![element isKindOfClass:[PLArrow class]]){
                continue;
            }
            PLArrow *arrow = (PLArrow *)element;
            if(arrow.isDelete == true){
                @try {
                    [self.plView.scene.elements removeObject:element];
                }
                @catch (NSException *exception) {
                    NSLog(@"NSException %@", exception);
                }
            }
        }
    }
    return true;
}
@end
