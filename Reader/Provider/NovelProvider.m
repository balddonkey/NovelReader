//
//  NovelProvider.m
//  Novel
//
//  Created by 慧流 on 2017/6/2.
//  Copyright © 2017年 慧流. All rights reserved.
//

#import "NovelProvider.h"
#import "ReaderDefines.h"
#import "GDataXMLNode.h"
#import "Novel.h"
#import "NovelChapter.h"

@interface NovelProvider ()

@end

@implementation NovelProvider

- (NSArray<Novel *> *)searchNovel:(NSString *)keyword {
    [NSException raise:@"Unimplementation method." format:@"%@: searchNovel: method not implementation", ReaderDomain];
    return nil;
}

- (NovelCatalog *)catalogWithNovel:(Novel *)novel {
    [NSException raise:@"Unimplementation method." format:@"%@: catalogWithNovel: method not implementation", ReaderDomain];
    return nil;
}

- (NovelChapter *)chapterWithCatalogItem:(NovelCatalogItem *)catalogItem {
    [NSException raise:@"Unimplementation method." format:@"%@: chapterWithCatalogItem: method not implementation", ReaderDomain];
    return nil;
}

- (NSString *)serialURLWithParams:(NSDictionary <NSString *, NSString *>*)params {
    NSMutableString *api = [self.searchApi mutableCopy];
    if (params.count) {
        [api appendString:@"?"];
    }
    for (NSString *key in params.allKeys) {
        NSString *value = params[key];
        // URL 以 & 结尾，& 会自动被忽略掉。
        [api appendFormat:@"%@=%@&", key, value];
    }
    return api;
}

- (Novel *)parseNovelWithNode:(GDataXMLNode *)node {
#ifdef DEBUG
    [NSException raise:@"Unimplementation method." format:@"%@: parseNovelWithNode: method not implementation", ReaderDomain];
#endif
    return nil;
}

- (NovelCatalogItem *)parseCatalogWithNode:(GDataXMLNode *)node {
#ifdef DEBUG
    [NSException raise:@"Unimplementation method." format:@"%@: parseCatalogWithNode: method not implementation", ReaderDomain];
#endif
    return nil;
}
- (NovelChapter *)parseNewestWithNode:(GDataXMLNode *)node {
#ifdef DEBUG
    [NSException raise:@"Unimplementation method." format:@"%@: parseNewestWithNode: method not implementation", ReaderDomain];
#endif
    return nil;
}

- (NSString *)propForName:(NSString *)propName node:(GDataXMLNode *)node xpath:(NSString *)xpath {
    GDataXMLNode *elem = [node firstNodeForXPath:xpath error:nil];
    return [elem propForName:propName];
}

- (NSDictionary *)novelXPathMapping {
#ifdef DEBUG
    [NSException raise:@"Unimplementation method." format:@"%@: novelXPathMapping: method not implementation", ReaderDomain];
#endif
    return nil;
}

- (NSDictionary *)catalogXPathMapping {
#ifdef DEBUG
    [NSException raise:@"Unimplementation method." format:@"%@: catalogXPathMapping: method not implementation", ReaderDomain];
#endif
    return nil;
}

- (NSDictionary *)chapterXPathMapping {
#ifdef DEBUG
    [NSException raise:@"Unimplementation method." format:@"%@: chapterXPathMapping: method not implementation", ReaderDomain];
#endif
    return nil;
}

@end
