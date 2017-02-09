//
//  YSHYAssetPickerController.m
//  ColorGradualChangeDemo
//
//  Created by 杨淑园 on 16/3/30.
//  Copyright © 2016年 yangshuyaun. All rights reserved.
//

#import "YSHYAssetPickerController.h"
#import "YSHYAssetGroupViewController.h"
@interface YSHYAssetPickerController ()
{
    YSHYAssetGroupViewController *groupViewController;
}
@end

@implementation YSHYAssetPickerController

- (id)initWithNumber:(NSInteger)maxNumber andHasSelectedImags:(NSMutableArray *)images
{
    groupViewController = [[YSHYAssetGroupViewController alloc] init];
     groupViewController.maxSelectedNumber = maxNumber;
    groupViewController.hasSelectedImages = images;
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
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
