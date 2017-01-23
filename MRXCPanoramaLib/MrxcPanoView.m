//
//  MrxcPanoView.m
//  MrxcPano
//
//  Created by never88gone on 16/3/23.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import "MrxcPanoView.h"
#import "MRXCPanoramaRoadLink.h"
#import "MRXCPanoramaTool.h"
#import "UIImage+Sacle.h"

@implementation MrxcPanoView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self != nil){
        [self initUIWithFrame:frame];
    }
    return self;
}

-(void)initUIWithFrame:(CGRect)frame
{
    self.plView = [[PLView alloc]initWithFrame:frame];
    self.plView.translatesAutoresizingMaskIntoConstraints = NO;
    self.plView.isDeviceOrientationEnabled = NO;
    self.plView.isAccelerometerEnabled = NO;
    self.plView.isScrollingEnabled = NO;
    self.plView.isInertiaEnabled = NO;
    self.plView.delegate = self;
    [self addSubview:self.plView];
    
    self.curImageView= [[UIImageView alloc]initWithFrame:frame];
    self.curImageView.backgroundColor=[UIColor redColor];
    [self addSubview:self.curImageView];
    self.curImageView.hidden=true;
    [self bringSubviewToFront:self.curImageView];
}
-(void)initWithDataSource:(id<PanoDataSourceBase> )dataSourcebase
{
    self.dataSource=dataSourcebase;
    [self.plView initWithPanoType:[dataSourcebase getPanoramaType]];
}
-(void)getPanoTitleList
{
    //获取切片
    //这里稍做优化，通过panoYaw值计算出当前正对的face，优先获取图片
    if ([self.dataSource getPanoramaType]==PanoramaEnumCube) {
        PLCube *cube = (PLCube *)self.plView.sceneElement;
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
    }else
    {
        for (int row=0; row<=4; row++) {
            for (int col=0; col<=8; col++) {
                [self.dataSource getPanoTileByID:self.panoramaID level:0 face:0 row:row col:col CompletionBlock:^(id aResponseObject, NSError *anError) {
                    if (!anError) {
                        NSData* data =(NSData*)aResponseObject;
                        PLTexture *texture = [PLTexture textureWithImage:[UIImage imageWithData:data]];
                        [texture setTexturePlace:0 row:row col:col face:0];
                        [self.plView addTexture:texture];
                        [self.plView drawView];
                    }
                }];
            }
        }
    }
}
-(void) getRoadLinkStationS
{
    if ([self.dataSource respondsToSelector:@selector(getLinkStationS:CompletionBlock:)]) {
        WEAK_SELF;
        [self.dataSource getLinkStationS:self.panoramaID  CompletionBlock:^(id aResponseObject, NSError *anError) {
            STRONG_SELF;
            if (!anError) {
                NSArray<MRXCPanoramaRoadLink*>* panoramaStationList=aResponseObject;
                self.adjacentPano = panoramaStationList;
                for(int i = 0; i < self.adjacentPano.count; i++){
                    MRXCPanoramaRoadLink *pano = [self.adjacentPano objectAtIndex:i];
                    PLArrow *arrow = [[PLArrow alloc]init];
                    arrow.deviation = self.handPanoYaw;
                    arrow.angle = [pano.Angle floatValue];
                    arrow.isDelete = false;
                    arrow.imageID = pano.DstImageID;
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
        }];
    }
}

-(void) getPanoThumbnailDataAndRefresh
{
    if ([self.dataSource respondsToSelector:@selector(getPanoThumbnailByID:CompletionBlock:)]){
        WEAK_SELF;
        [self.dataSource  getPanoThumbnailByID:self.panoramaID CompletionBlock:^(id aResponseObject, NSError *anError) {
            STRONG_SELF;
            if (!anError) {
                self.isAdjacentStatus = false;
                [self.plView panoramaSwitchEnd];
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
                UIImage *image = nil;
                NSMutableArray* imageArray=[NSMutableArray array];
                
                if ([aResponseObject isKindOfClass:[NSData class]]) {
                    NSData* thumbnailData=(NSData*)aResponseObject;
                    UIImage *image = [UIImage imageWithData:thumbnailData];
                    UIImage *  leftRectImage = [MRXCPanoramaTool imageInRect:image x:0 y:128 width:_PANORAMA_THUMBNAIL_SIZE_ height:_PANORAMA_THUMBNAIL_SIZE_];
                    [imageArray addObject:leftRectImage];
                    
                    UIImage *fontRectImage = [MRXCPanoramaTool imageInRect:image x:256 y:0 width:_PANORAMA_THUMBNAIL_SIZE_ height:_PANORAMA_THUMBNAIL_SIZE_];
                    [imageArray addObject:fontRectImage];
                    
                    UIImage *rightRectImage = [MRXCPanoramaTool imageInRect:image x:128 y:0 width:_PANORAMA_THUMBNAIL_SIZE_ height:_PANORAMA_THUMBNAIL_SIZE_];
                    [imageArray addObject:rightRectImage];
                    
                    UIImage *backImage = [MRXCPanoramaTool imageInRect:image x:0 y:0 width:_PANORAMA_THUMBNAIL_SIZE_ height:_PANORAMA_THUMBNAIL_SIZE_];
                    [imageArray addObject:backImage];

                    UIImage *  topRectImage = [MRXCPanoramaTool imageInRect:image x:128 y:128 width:_PANORAMA_THUMBNAIL_SIZE_ height:_PANORAMA_THUMBNAIL_SIZE_];
                     [imageArray addObject:topRectImage];
                    
                    UIImage *  bottomRectImage =  [MRXCPanoramaTool imageInRect:image x:256 y:128 width:_PANORAMA_THUMBNAIL_SIZE_ height:_PANORAMA_THUMBNAIL_SIZE_];;
                     [imageArray addObject:bottomRectImage];
                }else if ([aResponseObject isKindOfClass:[NSArray class]]){
                    imageArray=(NSMutableArray*)aResponseObject;
                }
                for (int i=0; i<imageArray.count; i++) {
                    UIImage* oneImage=imageArray[i];
                    PLTexture* texture = [PLTexture textureWithImage:oneImage];
                    [texture setTexturePlace:0 row:0 col:0 face:i];
                    [self.plView addTexture:texture];
                }
                PLTexture *texture = nil;
//                double panoYaw=-90+[self.panoramaData.Yaw doubleValue] + self.handPanoYaw;
//                if(panoYaw> 360.0){
//                    panoYaw= panoYaw - 360.0;
//                }
//                if(panoYaw < 0.0){
//                    panoYaw = panoYaw + 360.0;
//                }
//                if(panoYaw> 180.0f){
//                    panoYaw = 360.0f - panoYaw;
//                }
//                else{
//                    panoYaw = (-1)*panoYaw;
//                }
                double panoYaw=90+ self.handPanoYaw;
                if ([self.dataSource getPanoramaType]==PanoramaEnumCube) {
                    PLCube *cube = (PLCube *)self.plView.sceneElement;
                    cube.panoYaw = panoYaw;
                }else if ([self.dataSource getPanoramaType]==PanoramaEnumPhere)
                {
                    PLSphere *phere = (PLSphere *)self.plView.sceneElement;
                    phere.panoYaw = panoYaw;
                    texture = [PLTexture textureWithImage:image];
                    [self.plView addTexture:texture];
                }
                [self.plView drawView];
                [self getRoadLinkStationS];
                [self getPanoTitleList];
            }
        }];
    }
}
-(void)locPanoByPanoID:(NSString*)panoID
{
    [self locPanoByPanoID:panoID withAnimate:NO];
}

-(void)locPanoByPanoID:(NSString*)panoID withAnimate:(bool)animate
{
    self.panoramaID=panoID;
    self.panoramaData.ImageID=panoID;
    if (animate) {
        self.curImageView.hidden=false;
        UIImage* curImage=[self.plView getImageFromView];
        [self.curImageView setImage:curImage];
        [UIView animateWithDuration:1.0  animations:^{
            self.curImageView.transform = CGAffineTransformMakeScale(2, 2);
        } completion:^(BOOL finished) {
            self.curImageView.transform = CGAffineTransformMakeScale(1, 1);
            self.curImageView.hidden=true;
            self.curImageView.image=nil;
        }];
    }
    if ([self.dataSource respondsToSelector:@selector(getPanoStationByID:CompletionBlock:)]){
        WEAK_SELF;
        [self.dataSource getPanoStationByID:panoID CompletionBlock:^(id aResponseObject, NSError *anError) {
            STRONG_SELF;
            if (!anError) {
                self.panoramaData=aResponseObject;
                self.panoramaID = self.panoramaData.ImageID;
                [self getPanoThumbnailDataAndRefresh];
            }
        }];
    }

}

-(void)locPanoByLon:(float)lon Lat:(float)lat Tolerance:(float)tolerance
{
    if ([self.dataSource respondsToSelector:@selector(getPanoStationByLon:Lat:Tolerance:CompletionBlock:)]){
        WEAK_SELF;
        [self.dataSource getPanoStationByLon:lon Lat:lat Tolerance:tolerance CompletionBlock:^(id aResponseObject, NSError *anError) {
            STRONG_SELF;
            if (!anError) {
                self.panoramaData=aResponseObject;
                self.panoramaID = self.panoramaData.ImageID;
                [self getPanoThumbnailDataAndRefresh];
            }
        }];
    }
}
- (void)requestPanoTileByID:(int)face{
    for(int row = 0; row < 2; row ++){
        for(int col = 0; col < 2; col ++){
            if ([self.dataSource respondsToSelector:@selector(getPanoTileByID:level:face:row:col:CompletionBlock:)]) {
                [self.dataSource getPanoTileByID:self.panoramaID level:2 face:face row:row col:col CompletionBlock:^(id aResponseObject, NSError *anError) {
                    if (!anError) {
                        UIImage* oneImage=nil;
                        if ([aResponseObject isKindOfClass:[NSData class]]) {
                            NSData* data =(NSData*)aResponseObject;
                            oneImage=[UIImage imageWithData:data];
                        }else{
                            oneImage=(UIImage*)aResponseObject;
                        }
                        PLTexture *texture = [PLTexture textureWithImage:oneImage];
                        if ([self.dataSource respondsToSelector:@selector(cubeFaceIndex:)]) {
                            int newFace=[self.dataSource cubeFaceIndex:face];
                            [texture setTexturePlace:2 row:row col:col face:newFace];
                        }else{
                            [texture setTexturePlace:2 row:row col:col face:face];
                        }
                        [self.plView addTexture:texture];
                        [self.plView drawView];
                    }
                }];
            }
        }
    }
}
- (BOOL)singleTouchEventPoint:(CGPoint)point{
   
    if(self.isAdjacentStatus == true){
        return false;
    }
    PLArrow *arrow = nil;
    for(PLSceneElement *element  in self.plView.scene.elements){
        if(![element isKindOfClass:[PLArrow class]]){
            continue;
        }
        PLArrow *scenearrow = (PLArrow *)element;
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
    for(PLSceneElement *element  in self.plView.scene.elements){
        if(![element isKindOfClass:[PLArrow class]]){
            continue;
        }
    }
    self.panoramaID = arrow.imageID;
    [self locPanoByPanoID:self.panoramaID withAnimate:YES];
    self.isAdjacentStatus = true;
    [self.plView panoramaSwitchBegan];
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
