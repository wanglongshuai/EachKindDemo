//
//  LSCoreToolCenter.m
//  LSCoreFramework
//
//  Created by 王隆帅 on 15/5/14.
//  Copyright (c) 2015年 王隆帅. All rights reserved.
//

#import "LSCoreToolCenter.h"

#import <SDWebImageManager.h>
#import <SDWebImageCompat.h>
#import <SVProgressHUD.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreText/CoreText.h>

@implementation LSCoreToolCenter

+ (void)load{
   
    [SVProgressHUD setBackgroundColor:RGBACOLOR(0, 0, 0, 0.8)];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setInfoImage:nil];
}

void ShowSuccessStatus(NSString *statues){
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:statues];
        });
    }else{
        [SVProgressHUD showSuccessWithStatus:statues];
    }
}


void ShowMessage(NSString *statues){
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showInfoWithStatus:statues];
        });
    }else{
        [SVProgressHUD showInfoWithStatus:statues];
    }
}

void ShowErrorStatus(NSString *statues){
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:statues];
            [SVProgressHUD showProgress:0.5 status:@"上传" maskType:SVProgressHUDMaskTypeGradient];
        });
    }else{
        [SVProgressHUD showErrorWithStatus:statues];
    }
}


void ShowMaskStatus(NSString *statues){
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showWithStatus:statues maskType:SVProgressHUDMaskTypeGradient];
        });
    }else{
        [SVProgressHUD showWithStatus:statues maskType:SVProgressHUDMaskTypeGradient];
    }
}

void ShowProgress(CGFloat progress){
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showProgress:progress maskType:SVProgressHUDMaskTypeGradient];
        });
    }else{
        [SVProgressHUD showProgress:progress maskType:SVProgressHUDMaskTypeGradient];
    }
}

void DismissHud(void){
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }else{
        [SVProgressHUD dismiss];
    }
}


#pragma mark - 富文本操作

/**
 *  单纯改变一句话中的某些字的颜色（一种颜色）
 *
 *  @param color    需要改变成的颜色
 *  @param totalStr 总的字符串
 *  @param subArray 需要改变颜色的文字数组(要是有相同的 只取第一个)
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_changeCorlorWithColor:(UIColor *)color TotalString:(NSString *)totalStr SubStringArray:(NSArray *)subArray {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    for (NSString *rangeStr in subArray) {
        
        NSRange range = [totalStr rangeOfString:rangeStr options:NSBackwardsSearch];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
    
    return attributedStr;
}

/**
 *  单纯改变句子的字间距（需要 <CoreText/CoreText.h>）
 *
 *  @param totalString 需要更改的字符串
 *  @param space       字间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_changeSpaceWithTotalString:(NSString *)totalString Space:(CGFloat)space {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    long number = space;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedStr addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedStr length])];
    CFRelease(num);
    
    return attributedStr;
}

/**
 *  单纯改变段落的行间距
 *
 *  @param totalString 需要更改的字符串
 *  @param lineSpace   行间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_changeLineSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalString length])];
    
    return attributedStr;
}

/**
 *  同时更改行间距和字间距
 *
 *  @param totalString 需要改变的字符串
 *  @param lineSpace   行间距
 *  @param textSpace   字间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_changeLineAndTextSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace textSpace:(CGFloat)textSpace {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalString length])];
    
    long number = textSpace;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedStr addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedStr length])];
    CFRelease(num);
    
    return attributedStr;
}

/**
 *  改变某些文字的颜色 并单独设置其字体
 *
 *  @param font        设置的字体
 *  @param color       颜色
 *  @param totalString 总的字符串
 *  @param subArray    想要变色的字符数组
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_changeFontAndColor:(UIFont *)font Color:(UIColor *)color TotalString:(NSString *)totalString SubStringArray:(NSArray *)subArray {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    for (NSString *rangeStr in subArray) {
        
        NSRange range = [totalString rangeOfString:rangeStr options:NSBackwardsSearch];
        
        [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        [attributedStr addAttribute:NSFontAttributeName value:font range:range];
    }
    
    return attributedStr;
}

/**
 *  为某些文字改为链接形式
 *
 *  @param totalString 总的字符串
 *  @param subArray    需要改变颜色的文字数组(要是有相同的 只取第一个)
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_addLinkWithTotalString:(NSString *)totalString SubStringArray:(NSArray *)subArray {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    for (NSString *rangeStr in subArray) {
        
        NSRange range = [totalString rangeOfString:rangeStr options:NSBackwardsSearch];
        [attributedStr addAttribute:NSLinkAttributeName value:totalString range:range];
    }
    
    return attributedStr;
}

#pragma mark - 选择相册相关API

/**
 *  获取相册的图片
 *
 *  @param result 获取到的图片
 *  @param error  失败信息
 */
+ (void)getSavedPhotoList:(void (^)(NSArray *))result error:(void (^)(NSError *))error
{
    NSMutableArray *savedPhotoList = [NSMutableArray array];
    
    if (IOS_VERSION >= __IPHONE_9_0) {
        
        NSMutableArray* assetarray = [NSMutableArray array];
        PHFetchResult* collections = [PHAssetCollection fetchMomentsWithOptions:nil];
        
        for (PHAssetCollection* collection in collections) {
            PHFetchResult* assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
            for (PHAsset* asset in assets) {
                if (asset.mediaType ==  PHAssetMediaTypeImage) {
                    [assetarray addObject:asset];
                }
            }
        }
        
        [assetarray sortUsingComparator:^NSComparisonResult(PHAsset* obj1, PHAsset* obj2) {
            return [obj2.creationDate compare:obj1.creationDate];
        }];
        
        if (result) {
            result(assetarray);
        }
        return;
        
    }
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
        
        
        if ([[group valueForProperty:@"ALAssetsGroupPropertyType"] intValue] == ALAssetsGroupSavedPhotos) {
            
            [group setAssetsFilter: [ALAssetsFilter allPhotos]];
            
            [group enumerateAssetsUsingBlock:^(ALAsset *alPhoto, NSUInteger index, BOOL *stop) {
                @autoreleasepool {
                    
                    if(alPhoto == nil) {
                        
                        NSArray * tempArray = [savedPhotoList copy];
                        [savedPhotoList removeAllObjects];
                        [savedPhotoList addObjectsFromArray: [[tempArray reverseObjectEnumerator] allObjects]];
                        
                        
                        result([savedPhotoList mutableCopy]);
                        
                        return;
                    }
                    
                    [savedPhotoList addObject:alPhoto];
                }
            }];
        }
    };
    
    void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *err) {
        
        NSLog(@"Asset read Error : %@", [err description]);
    };
    
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:assetGroupEnumerator failureBlock:assetGroupEnumberatorFailure];
}

/**
 *  获取asset中的image
 *
 *  @param asset       PSAsset
 *  @param size        尺寸
 *  @param completion  完成block
 *  @param synchronous 是否异步
 */
+ (void)generaImaeWithAsset:(PHAsset *)asset size:(CGSize)size completion:(void (^)(UIImage *))completion synchronous:(BOOL)synchronous {
    
    PHImageRequestOptions* options = [[PHImageRequestOptions alloc]init];
    options.synchronous = synchronous;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (completion) {
            completion(result);
        }
    }];
    
}

/**
 *  获取Asset中的size
 *
 *  @param asset Asset
 *
 *  @return 得到的size
 */
+ (CGSize)getSizeFromAsset:(id)asset {
    
    CGSize size;
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        
        PHAsset* pa = (PHAsset*)asset;
        size = CGSizeMake(pa.pixelWidth, pa.pixelHeight);
    } else {
        
        ALAssetRepresentation * representation = [asset defaultRepresentation];
        size = [representation dimensions];
    }
    
    return size;
}

/**
 *  从asset中截取一定尺寸的图片
 *
 *  @param asset asset
 *  @param size  需要的尺寸
 *
 *  @return 得到的image
 */
+ (UIImage *)getThumImageFromAsset:(id)asset withSize:(CGSize)size {
    
    __block UIImage *image;
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        
        PHAsset* pa = (PHAsset*)asset;
        
        [LSCoreToolCenter generaImaeWithAsset:pa size:size completion:^(UIImage *result) {
            
            image = result;
        } synchronous:YES];
        
    } else {
        
        if ([[[UIDevice alloc] systemVersion] floatValue] >= 9.0) {
            
            image = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];;
        } else {
            
            image = [UIImage imageWithCGImage:[asset thumbnail]];;
        }
    }
    
    return image;
    
}

#pragma mark - animation

void JumpAnimation (UIView *view ,NSTimeInterval duration,float height){
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    CGFloat currentTx = view.transform.ty;
    animation.duration = duration;
    animation.values = @[@(currentTx), @(currentTx + height),@(currentTx), @(currentTx +height/3.0),@(currentTx), @(currentTx + height/5.0),@(currentTx),];
    animation.keyTimes = @[ @(0), @(0.35), @(0.65), @(0.80),@(0.885), @(0.95), @(1.0) ];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [view.layer addAnimation:animation forKey:@"kViewShakerAnimationKey"];
}

@end
