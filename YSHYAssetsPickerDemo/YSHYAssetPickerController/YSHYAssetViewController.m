//
//  YSHYAssetViewController.m
//  ColorGradualChangeDemo
//
//  Created by 杨淑园 on 16/3/30.
//  Copyright © 2016年 yangshuyaun. All rights reserved.
//

#import "YSHYAssetViewController.h"
#import "YSHYAssetPickerController.h"
#import "YSHYShowBigViewController.h"
#import "YSHYEqualSpaceFlowLayout.h"
#import "YSHYAssetsCell.h"
#import "MBProgressHUD.h"
#import "YSHYAssetObj.h"
#define maxSelectedNumber   10;
@interface YSHYAssetViewController()<UICollectionViewDelegate,UICollectionViewDataSource,YSHYEqualSpaceFlowLayoutDelegate,YSHYAssetsCellDelegate>{
    BOOL unFirst;
}

@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) UIView *toolBar;
@property (nonatomic, strong) UIButton *preview;
@property (nonatomic, strong) UIButton *send;

@property (nonatomic, strong) UICollectionView * collectionView;
@end

@implementation YSHYAssetViewController

- (id)init
{
    if (self = [super init])
    {
        self.maxSlectedNumber = 10;
        self.indexPathsForSelectedItems=[[NSMutableArray alloc] init];
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
            [self setEdgesForExtendedLayout:UIRectEdgeNone];
        
        if ([self respondsToSelector:@selector(setContentSizeForViewInPopover:)])
            self.preferredContentSize = kPopoverContentSize;
    }
    
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self CreatCollectionView];
    [self setupButtons];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    NSLog(@"%@",_hasSelectedImages);
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!unFirst) {
        [self setupAssets];
        unFirst=YES;
    }
}
-(void)CreatCollectionView
{
    YSHYEqualSpaceFlowLayout * flowLayout = [[YSHYEqualSpaceFlowLayout alloc]init];
    flowLayout.delegate = self;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 3;
    flowLayout.sectionInset = UIEdgeInsetsMake(2, 3, 2, 0);
    flowLayout.itemSize = kCollectionViewSize;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64 -40) collectionViewLayout:flowLayout];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[YSHYAssetsCell class] forCellWithReuseIdentifier:@"CellID"];
    [self.view addSubview:self.collectionView];
}

#pragma mark - Setup

- (void)setupButtons
{
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil)
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(cancelPickingAssets:)];
    
    self.toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 105, kScreenWidth, 40 )];
    [self.toolBar setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:239.0/255.0 alpha:1.0]];
    
    
    self.preview = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.preview setBackgroundImage:[UIImage imageNamed:@"defultComplete"] forState:UIControlStateNormal];
    [self.preview setTitle:@"预览" forState:UIControlStateNormal];
    self.preview.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.preview setFrame:CGRectMake(5, 5 , 80, 30)];
    self.preview.userInteractionEnabled = NO;
    [self.preview addTarget:self action:@selector(previewClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.send = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.send setBackgroundImage:[UIImage imageNamed:@"defultComplete"] forState:UIControlStateNormal];
    [self.send setTitle:@"确定" forState:UIControlStateNormal];
    self.send.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.send setFrame:CGRectMake((kScreenWidth- 80 -5), 5 , 80, 30)];
    self.send.userInteractionEnabled = NO;
    [self.send addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.toolBar addSubview:self.preview];
    [self.toolBar addSubview:self.send];
    
    [self.view addSubview:self.toolBar];
}

- (void)setupAssets
{
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    if (!self.assets)
        self.assets = [[NSMutableArray alloc] init];
    else
        [self.assets removeAllObjects];
    
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        //过滤掉GIF 图片
        id obj = [asset.defaultRepresentation UTI];
        NSLog(@"%@",obj);
        if (asset && (![obj hasSuffix:@"gif"] && ![obj hasSuffix:@"GIF"]))
        {
            [self.assets addObject:asset];
        }
        else if (self.assets.count > 0)
        {
            [self.collectionView reloadData];
            NSInteger section = 0;
            NSInteger item = [self collectionView:self.collectionView numberOfItemsInSection:section] - 1;
            if (item < 0) item = 0;
            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
            [self.collectionView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
        }    };
    
    [self.assetsGroup enumerateAssetsUsingBlock:resultsBlock];
    
}

#pragma mark - Actions

- (void)cancelPickingAssets:(id)sender
{
    YSHYAssetPickerController *picker = (YSHYAssetPickerController *)self.navigationController;
    
    if (picker.isFinishDismissViewController)
    {
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)previewClick
{
    YSHYAssetPickerController *picker = (YSHYAssetPickerController *)self.navigationController;
    YSHYShowBigViewController *big = [[YSHYShowBigViewController alloc]init];
    big.arrayOK = [NSMutableArray arrayWithArray:_indexPathsForSelectedItems];
    __weak typeof(picker) weakPicker = picker;
    big.popViewControllerBlock= ^(NSArray * array)
    {
        for (YSHYAssetObj *assetObj in array) {
            [_indexPathsForSelectedItems removeObject:assetObj];
            assetObj.selectedImageHidden = YES;
            YSHYAssetsCell * cell =(YSHYAssetsCell *)[_collectionView cellForItemAtIndexPath:assetObj.indexPath];
            [cell HandleTapTouch:assetObj.indexPath];
        }
    };
    big.sendImagesBlock = ^(NSArray * array)
    {
        [weakPicker.pickerDelegate assetPickerController:weakPicker didFinishPickingAssets:array];
    };
    [picker pushViewController:big animated:YES];
}
-(void)sendClick
{
    YSHYAssetPickerController *picker = (YSHYAssetPickerController *)self.navigationController;
    if ([picker.pickerDelegate respondsToSelector:@selector(assetPickerController:didFinishPickingAssets:)])
    {
        NSMutableArray * assets = [[NSMutableArray alloc]initWithCapacity:1];
        for (YSHYAssetObj * obj in _indexPathsForSelectedItems) {
            [assets addObject:obj.asset];
        }
        [picker.pickerDelegate assetPickerController:picker didFinishPickingAssets:assets];
    }
   
    if (picker.isFinishDismissViewController)
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"CellID";
    if([self.assets[indexPath.row] isKindOfClass:[ALAsset class]])
    {
        YSHYAssetObj * obj = [[YSHYAssetObj alloc]init];
        obj.asset = self.assets[indexPath.row];
        obj.selectedImageHidden = YES;
        obj.indexPath = indexPath;
        [self.assets replaceObjectAtIndex:indexPath.row withObject:obj];
    }
    YSHYAssetsCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.delegate = self;
    cell.backgroundColor = [UIColor yellowColor];
    [cell ConfigData:_assets[indexPath.row]];
    YSHYAssetObj * assetObj =_assets[indexPath.row];

    for(int i = 0;i < _hasSelectedImages.count ;i++)
    {
        ALAsset * asset = _hasSelectedImages[i];
//        PHImageManager.asset
        if([[asset defaultRepresentation].url isEqual:[assetObj.asset defaultRepresentation].url])
        {
            [_indexPathsForSelectedItems addObject:assetObj];
            assetObj.selectedImageHidden = NO;
            [cell HandleSelectedImage];
            [self setTitleWithSelectedIndexPaths:_indexPathsForSelectedItems];
        }
    }
    [cell layoutIfNeeded];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return kCollectionViewSize;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YSHYAssetsCell * cell = (YSHYAssetsCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell HandleTapTouch:indexPath];
}
-(void)HandleHiddenHud:(UIView *)view
{
    [view removeFromSuperview];
}

-(void)TapAssetsCell:(YSHYAssetsCell *)assetCell isSelectedImageHidden:(BOOL)selected indexPath:(NSIndexPath *)indexPath
{
    YSHYAssetObj * obj =(YSHYAssetObj *)self.assets[indexPath.row];
    if(selected)
    {
        if(self.hasSelecteNumber >= self.maxSlectedNumber)
        {
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            [self.view bringSubviewToFront:hud];
            hud.labelText =[NSString stringWithFormat:@"最多只能选%ld张呢",(long)self.maxSlectedNumber];
            [self performSelector:@selector(HandleHiddenHud:) withObject:hud afterDelay:2.0];
        }else
        {
            [_indexPathsForSelectedItems addObject:obj];
            obj.selectedImageHidden = NO;
            [assetCell HandleSelectedImage];
        }
    }
    else
    {
        [_indexPathsForSelectedItems removeObject:obj];
        obj.selectedImageHidden = YES;
        [assetCell HandleSelectedImage];
    }
    
    [self setTitleWithSelectedIndexPaths:_indexPathsForSelectedItems];
}

#pragma mark - Title
- (void)setTitleWithSelectedIndexPaths:(NSArray *)indexPaths
{
    // Reset title to group name
    self.hasSelecteNumber = indexPaths.count;
    if (indexPaths.count == 0)
    {
        self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
        [self.preview setBackgroundImage:[UIImage imageNamed:@"defultComplete" ]forState:
         UIControlStateNormal];
        self.preview.userInteractionEnabled = NO;
        [self.send setBackgroundImage:[UIImage imageNamed:@"defultComplete" ]forState:
         UIControlStateNormal];
        self.send.userInteractionEnabled = NO;
        [self.send setTitle:@"确定" forState:UIControlStateNormal];
        return;
    }
    
    [self.preview setBackgroundImage:[UIImage imageNamed:@"complete" ]forState:
     UIControlStateNormal];
    self.preview.userInteractionEnabled = YES;
    [self.send setBackgroundImage:[UIImage imageNamed:@"complete" ]forState:
     UIControlStateNormal];
    self.send.userInteractionEnabled = YES;
    [self.send setTitle:[NSString stringWithFormat:@"确定(%ld)",(long)self.hasSelecteNumber] forState:UIControlStateNormal];
}


@end
