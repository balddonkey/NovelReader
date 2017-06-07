//
//  NovelProvider.h
//  Novel
//
//  Created by 慧流 on 2017/6/2.
//  Copyright © 2017年 慧流. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NovelProviderType.h"

@class GDataXMLNode, Novel, NovelCatalog, NovelChapter, NovelCatalogItem;
// 这是一个基类，提供一些通用Api
@interface NovelProvider : NSObject <NovelProviderType>

@property (strong, nonatomic) NSString *searchApi;  // 搜索接口地址

- (NSString *)serialURLWithParams:(NSDictionary *)params;

- (Novel *)parseNovelWithNode:(GDataXMLNode *)node;
- (NovelCatalogItem *)parseCatalogWithNode:(GDataXMLNode *)node;
- (NovelChapter *)parseNewestWithNode:(GDataXMLNode *)node;

- (NSString *)propForName:(NSString *)propName node:(GDataXMLNode *)node xpath:(NSString *)xpath;

// 针对 Novel 和 NovelCatalog、NovelCatalogItem 各字段 xpath 值
- (NSDictionary *)novelXPathMapping;
- (NSDictionary *)catalogXPathMapping;
- (NSDictionary *)chapterXPathMapping;

@end
