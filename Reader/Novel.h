//
//  NovelItem.h
//  Novel
//
//  Created by 慧流 on 2017/6/2.
//  Copyright © 2017年 慧流. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NovelCatalog, NovelCatalogItem;
@interface Novel : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *coverURL;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *nfw;        // number of words, 字数
@property (strong, nonatomic) NSString *intro;      // 介绍
@property (strong, nonatomic) NovelCatalog *catalog;     // 目录
@property (strong, nonatomic) NovelCatalogItem *newest; // 最新章节

@end
