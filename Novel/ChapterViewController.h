//
//  ChapterViewController.h
//  Novel
//
//  Created by 慧流 on 2017/6/5.
//  Copyright © 2017年 慧流. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NovelCatalogItem;
@protocol NovelProviderType;
@interface ChapterViewController : UIViewController

@property (strong, nonatomic) id <NovelProviderType> provider;
@property (strong, nonatomic) NovelCatalogItem *catalogItem;

@end
