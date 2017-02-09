# YSHYAssetsPickerDemo
相册多选
在需要调用的相册的地方 加入如下代码

YSHYAssetPickerController *picker = [[YSHYAssetPickerController alloc]initWithNumber:5 andHasSelectedImags:dataSource];//最多只能选5张 并
      传入已经选着的图片集合
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



并实现其代理方法 #pragma mark - YSHYAssetPickerControllerDelegate

    -(void)assetPickerController:(YSHYAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
     {
      NSLog(@"选好了");
     }
