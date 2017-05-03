//
//  YSHYAssetPickerController.m
//  ColorGradualChangeDemo
//
//  Created by 杨淑园 on 16/3/30.
//  Copyright © 2016年 yangshuyaun. All rights reserved.
//

#import "YSHYAssetPickerController.h"
#import "YSHYAssetGroupViewController.h"
#import "YSHYAssetViewController.h"
#import "YSHYAssetObj.h"
@interface YSHYAssetPickerController ()
{
    YSHYAssetGroupViewController *groupViewController;
    
}
@property(nonatomic, strong)YSHYAssetViewController * assetVC;
@end

@implementation YSHYAssetPickerController

- (id)initWithNumber:(NSInteger)maxNumber andHasSelectedImags:(NSMutableArray *)images
{
    if(self = [super init])
    {
        groupViewController = [[YSHYAssetGroupViewController alloc] init];
        groupViewController.maxSelectedNumber = maxNumber;
        groupViewController.hasSelectedImages = images;
        
        
        _assetVC = [[YSHYAssetViewController alloc]init];
        _assetVC.hasSelectedImages=  groupViewController.hasSelectedImages;
        _assetVC.maxSlectedNumber =  groupViewController.maxSelectedNumber;
        if (self = [super initWithRootViewController:groupViewController])
        {
            _maximumNumberOfSelection      = maxNumber;
            _minimumNumberOfSelection      = 0;
            _assetsFilter                  = [ALAssetsFilter allAssets];
            _showCancelButton              = YES;
            _showEmptyGroups               = NO;
            _selectionFilter               = [NSPredicate predicateWithValue:YES];
            _isFinishDismissViewController = YES;
            
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
            self.preferredContentSize=kPopoverContentSize;
#else
            if ([self respondsToSelector:@selector(setContentSizeForViewInPopover:)])
                [self setContentSizeForViewInPopover:kPopoverContentSize];
#endif
        }
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    __weak typeof(self)weakself = self;
    groupViewController.block = ^(NSMutableArray *groups)
    {
        if(groups.count > 0)
        {
            weakself.assetVC.assetsGroup = groups[0];
            if(![weakself.visibleViewController isKindOfClass:[YSHYAssetViewController class]])
            {
                [weakself pushViewController:weakself.assetVC animated:NO];
            }
        }
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [super popViewControllerAnimated:animated];
    NSMutableArray * assetArry = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < _assetVC.indexPathsForSelectedItems.count; i++) {
        YSHYAssetObj * obj = _assetVC.indexPathsForSelectedItems[i];
        [assetArry addObject:obj.asset];
    }
    groupViewController.maxSelectedNumber = _assetVC.maxSlectedNumber;
    groupViewController.hasSelectedImages = [assetArry mutableCopy];
    return groupViewController;
}

@end
