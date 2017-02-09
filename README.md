# YSHYAssetsPickerDemo
相册多选
在需要调用相册的地方 添加如下代码


   
        YSHYAssetPickerController *picker = [[YSHYAssetPickerController alloc]initWithNumber:5 andHasSelectedImags:dataSource];//最多只能选5张 并传入已经选好的图片数组
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
 
实现其代理方法

#pragma mark - ZYQAssetPickerControllerDelegate
  -(void)assetPickerController:(YSHYAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
  {
     
     [dataSource removeAllObjects];
    
     [dataSource addObjectsFromArray:assets];
     
      [self CreatImageViewWithImags:dataSource];
      
  }
  
  
  ![image](https://github.com/DecembeGrirl/YSHYAssetsPickerDemo/blob/master/YSHYAssetsPickerDemo/YSHYAssetpicker.gif)
