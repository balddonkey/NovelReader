//
//  NovelProviderType.h
//  Novel
//
//  Created by 慧流 on 2017/6/2.
//  Copyright © 2017年 慧流. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Novel, NovelChapter, NovelCatalog, NovelCatalogItem;
@protocol NovelProviderType <NSObject>

@required
// 都为同步操作
- (NSArray <Novel *>*)searchNovel:(NSString *)keyword;
- (NovelCatalog *)catalogWithNovel:(Novel *)novel;
- (NovelChapter *)chapterWithCatalogItem:(NovelCatalogItem *)catalogItem;
@end
