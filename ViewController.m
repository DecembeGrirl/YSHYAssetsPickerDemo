//
//  ViewController.m
//  YSHYAssetsPickerDemo
//
//  Created by 杨淑园 on 16/4/6.
//  Copyright © 2016年 yangshuyaun. All rights reserved.
//

#import "ViewController.h"
#import "YSHYAssetPickerController.h"
@interface ViewController ()<YSHYAssetPickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"选择图片" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 80, 80)];
    [btn addTarget:self action:@selector(HandleClickBtn) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setCenter:self.view.center];
    [self.view addSubview:btn];
}

-(void)HandleClickBtn
{
    YSHYAssetPickerController *picker = [[YSHYAssetPickerController alloc]init];
    picker.maximumNumberOfSelection = 15; //设置可选取图片的最大数量  默认为10
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
        [self.view endEditing:YES];
    }];
}
#pragma mark - YSHYAssetPickerControllerDelegate
-(void)assetPickerController:(YSHYAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    NSLog(@"选好了");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
