//
//  EqualSpaceFlowLayout.h
//  UICollectionViewDemo
//
//  Created by CHC on 15/5/12.
//  Copyright (c) 2015年 CHC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  YSHYEqualSpaceFlowLayoutDelegate<UICollectionViewDelegateFlowLayout>
@end

@interface YSHYEqualSpaceFlowLayout : UICollectionViewFlowLayout

@property (nonatomic,weak) id<YSHYEqualSpaceFlowLayoutDelegate> delegate;
@end
