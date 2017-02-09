# YSHYAssetsPickerDemo
相册多选
在需要调用的相册的地方 加入如下代码

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

并实现其代理方法 #pragma mark - YSHYAssetPickerControllerDelegate

    -(void)assetPickerController:(YSHYAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
     {
      NSLog(@"选好了");
     }
