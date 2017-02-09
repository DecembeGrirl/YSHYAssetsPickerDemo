//
//  ViewController.m
//  YSHYAssetsPickerDemo
//
//  Created by 杨淑园 on 16/4/6.
//  Copyright © 2016年 yangshuyaun. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "YSHYAssetPickerController.h"
@interface ViewController ()<YSHYAssetPickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController * _imagePicker;
    NSMutableArray * dataSource;
    UIView *  imagesView;
    
}
@property (nonatomic, strong)ALAssetsLibrary * library;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:btn];
    [btn setFrame:CGRectMake(100, 200, 100, 30)];
    [btn setTitle:@"添加" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    dataSource = [NSMutableArray arrayWithCapacity:3];
    
}

-(void)btnClick
{
    UIAlertController * actionView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionView addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        YSHYAssetPickerController *picker = [[YSHYAssetPickerController alloc]initWithNumber:5 andHasSelectedImags:dataSource];//最多只能选5张
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.showEmptyGroups = NO;
        picker.pickerDelegate = self;
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject,NSDictionary *bindings){
            if ([[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyType]isEqual:ALAssetTypeVideo]) {
                NSTimeInterval duration = [[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyDuration]doubleValue];
                return duration >= 5;
            }else{
                return  YES;
            }
        }];
        [self presentViewController:picker animated:YES completion:^{
        }];
        
    }]];
    [actionView addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        CGAffineTransform cameraTransform = CGAffineTransformMakeScale(1.25,1.25);
        _imagePicker.cameraViewTransform = cameraTransform;
        
        _imagePicker.mediaTypes = @[AVMediaTypeVideo];
        _imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
        _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        _imagePicker.delegate = self;
        [self presentViewController:_imagePicker animated:YES completion:^{
            [self.view endEditing:YES];
        }];
        
    }]];
    [actionView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:actionView animated:YES completion:nil];
    
}


#pragma mark - YSHYAssetPickerControllerDelegate
-(void)assetPickerController:(YSHYAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [dataSource removeAllObjects];
    [dataSource addObjectsFromArray:assets];
    [self CreatImageViewWithImags:dataSource];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //获取图片信息
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    // 将图片保存在系统相册
    if(picker.sourceType ==UIImagePickerControllerSourceTypeCamera)
    {
        if(nil == _library)
            _library = [[ALAssetsLibrary alloc] init];
        __weak __typeof__(self) weakSelf = self;
        [_library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
                [weakSelf.library assetForURL:assetURL resultBlock:^(ALAsset *asset){//这里的asset便是我们所需要的图像对应的ALAsset了
                    dispatch_async(dispatch_get_main_queue(),^{
                        [dataSource addObject:asset];
                        [self CreatImageViewWithImags:dataSource];
                    });
                }failureBlock:^(NSError *error) {
                }];
            });
        }];
    }
    [_imagePicker dismissViewControllerAnimated:YES completion:nil];
}

-(void)CreatImageViewWithImags:(NSMutableArray *)array
{
    if(imagesView)
    {
        [imagesView removeFromSuperview];
    }
    imagesView = [[UIView alloc]init];
    [self.view addSubview:imagesView];
    [imagesView  setFrame:CGRectMake(10, 250, self.view.frame.size.width - 20, 300)];
    CGFloat width = (imagesView.frame.size.width- 20) / 4;
    for (int i = 0; i < array.count; i++) {
        ALAsset *asset = array[i];
        UIImageView * myImageView = [[UIImageView alloc]init];
        
        [myImageView setImage:[UIImage imageWithCGImage:[asset aspectRatioThumbnail]]];
        [imagesView addSubview:myImageView];
        
        int a = i / 4;
        int b = i % 4;
        [myImageView setFrame:CGRectMake((width + 5) * b , (width + 5) * a, width, width)];
    }
    
}
@end
