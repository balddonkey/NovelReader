//
//  BiqugeProvider.m
//  Novel
//
//  Created by 慧流 on 2017/6/2.
//  Copyright © 2017年 慧流. All rights reserved.
//

#import "BiqugeProvider.h"
#import "GDataXMLNode.h"
#import "ReaderDefines.h"
#import "Novel.h"
#import "NovelChapter.h"
#import "NovelCatalog.h"
#import "NovelCatalogItem.h"

@implementation BiqugeProvider

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.searchApi = @"http://zhannei.baidu.com/cse/search";
    }
    return self;
}

- (NSArray<Novel *> *)searchNovel:(NSString *)keyword {
    NSMutableDictionary *params = [self defaultParams];
    params[@"q"] = keyword;
    NSString *urlString = [[self serialURLWithParams:params] stringByAddingPercentEncodingWithAllowedCharacters:
                           [NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSError *error;
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLData:data error:&error];
    if (error) {
        NSLog(@"Generate XMLDocument failed: %@", error.localizedDescription);
        return nil;
    }
    NSArray *nodes = [document nodesForXPath:@"//div[@class=\"result-list\"]/div[@class=\"result-item result-game-item\"]" error:&error];
    if (error) {
        NSLog(@"Generate Nodes failed: %@", error.localizedDescription);
        return nil;
    }
    
    NSMutableArray *novels = [NSMutableArray new];
    for (GDataXMLNode *node in nodes) {
        NSLog(@"node: %@", node);
        Novel *novel = [self parseNovelWithNode:node];
        [novels addObject:novel];
    }
    if (nodes.count > 0 ) {
//        Novel *novel = [self parseNovelWithNode:nodes[0]];
//        NovelCatalog *catalog = [self catalogWithNovel:novel];
//        NovelChapter *chapter = [self chapterWithCatalogItem:catalog.catalog[0]];
    }
    
    return novels;
}

- (NovelCatalog *)catalogWithNovel:(Novel *)novel {
    
    NSURL *url = [[NSURL alloc] initWithString:novel.catalog.catalogURL];
    NSError *error;
    NSString *str = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"error: %@", error.localizedDescription);
    } else {
        NSLog(@"str: %@", str);
    }
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLString:str error:&error];
    NSArray *nodes = [document nodesForXPath:@"//div[@id=\"list\"]/dl[1]/dd" error:&error];
    NSMutableArray *catalog = [NSMutableArray new];
    for (GDataXMLNode *node in nodes) {
        NovelCatalogItem *catalogItem = [self parseCatalogWithNode:node];
        [catalog addObject:catalogItem];
    }
    novel.catalog.catalog = catalog;
    
    return novel.catalog;
}

- (NovelChapter *)chapterWithCatalogItem:(NovelCatalogItem *)catalogItem {
    
    NSURL *url = [[NSURL alloc] initWithString:catalogItem.chapterURL]; 
    NSError *error;
    NSString *str = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"error: %@", error.localizedDescription);
    } else {
        NSLog(@"str: %@", str);
    }
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLString:str error:&error];
    GDataXMLNode *node = [document firstNodeForXPath:@"//div[@id=\"content\"]" error:&error];
    NSString *content = [node XMLString];
    
    NSLog(@"content: %@", content);
//    content = [content stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
//    content = [content stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
//    content = [content stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    NovelChapter *chapter = [[NovelChapter alloc] init];
    chapter.title = catalogItem.title;
    chapter.chapterURL = catalogItem.chapterURL;
    chapter.text = content;
    return chapter;
}

- (NSMutableDictionary *)defaultParams {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            @"13603361664978768713", @"s",
            @"click", @"1",
            nil];
}

- (Novel *)parseNovelWithNode:(GDataXMLNode *)node {
    if (![self novelXPathMapping]) {
        NSLog(@"子类未提供 Novel 字段映射。Error Domain: %@", ReaderDomain);
        return nil;
    }
    Novel *novel = [[Novel alloc] init];
    
    // Novel name
    NSString *nameXPath = [self novelXPathMapping][@"name"];
    NSString *name = [self propForName:@"title" node:node xpath:nameXPath];
    novel.name = name;
    
    // Novel cover image url
    NSString *urlXPath = [self novelXPathMapping][@"coverURL"];
    NSString *coverURL = [self propForName:@"src" node:node xpath:urlXPath];
    novel.coverURL = coverURL;
    
    // Author
    NSString *authorMath = @"(\\w+)"; //@"([^\\s]+)"
    NSString *authorXPath = [self novelXPathMapping][@"author"];
    GDataXMLNode *authorNode = [node firstNodeForXPath:authorXPath error:nil];
    NSString *author = [authorNode stringValue];
    NSRange authorRange = [author rangeOfString:authorMath options:NSRegularExpressionSearch];
    author = [author substringWithRange:authorRange];
    novel.author = author;
    
    // Novel intro
    NSString *introXPath = [self novelXPathMapping][@"intro"];
    GDataXMLNode *introNode = [node firstNodeForXPath:introXPath error:nil];
    NSString *intro = [introNode stringValue];
    novel.intro = intro;
    
    // Catalog
    /// Catalog url
    NovelCatalog *catalog = [[NovelCatalog alloc] init];
    NSString *catalogURL = [self propForName:@"href" node:node xpath:nameXPath];
    catalog.catalogURL = catalogURL;
    novel.catalog = catalog;
    
    // Newest Chapter
    NovelCatalogItem *newest = [[NovelCatalogItem alloc] init];
    /// chapter title
    NSString *newestXPath = [self novelXPathMapping][@"newestTitle"];
    GDataXMLNode *newestNode = [node firstNodeForXPath:newestXPath error:nil];
    NSString *title = [newestNode stringValue];
    NSString *chapterURL = [newestNode propForName:@"href"];
    newest.title = title;
    newest.chapterURL = chapterURL;
    novel.newest = newest;
    
    return novel;
}

- (NovelCatalogItem *)parseCatalogWithNode:(GDataXMLNode *)node {
    
    NSString *nameXPath = [self catalogXPathMapping][@"name"];
    GDataXMLNode *catalogNode = [node firstNodeForXPath:nameXPath error:nil];
    NovelCatalogItem *item = [[NovelCatalogItem alloc] init];
    item.title = [catalogNode stringValue];
    item.chapterURL = [@"http://www.biquge.com" stringByAppendingString:[catalogNode propForName:@"href"]];
    return item;
}

- (NovelChapter *)parseNewestWithNode:(GDataXMLNode *)node {
    
    return nil;
}

- (NSDictionary *)novelXPathMapping {
    NSDictionary * dic = @{@"name": @"div[@class=\"result-game-item-detail\"]/h3[@class=\"result-item-title result-game-item-title\"]/a[@class=\"result-game-item-title-link\"]",
                           @"coverURL": @"div[@class=\"result-game-item-pic\"]//a[@class=\"result-game-item-pic-link\"]//img[@class=\"result-game-item-pic-link-img\"]",
                           @"author": @"div[@class=\"result-game-item-detail\"]/div[@class=\"result-game-item-info\"]/p[1]/span[2]",
                           @"intro": @"div[@class=\"result-game-item-detail\"]/p[@class=\"result-game-item-desc\"]",
                           @"catalogURL": @"div[@class=\"result-game-item-detail\"]/h3[@class=\"result-item-title result-game-item-title\"]/a[@class=\"result-game-item-title-link\"]", // 目录地址
                           @"newestTitle": @"div[@class=\"result-game-item-detail\"]/div[@class=\"result-game-item-info\"]/p[4]/a[1]",
                           @"newestURL": @"div[@class=\"result-game-item-detail\"]/div[@class=\"result-game-item-info\"]/p[4]/a[1]"
                           };
    return dic;
}

- (NSDictionary *)catalogXPathMapping {
    NSDictionary *dic = @{@"name": @"a",         // 章节标题
                          @"chapterURL": @"a"    // 正文地址
                          };
    return dic;
}

- (NSString *)parseProp:(NSString *)propName forNode:(GDataXMLNode *)node {
    if ([propName isEqualToString:@"name"]) {
        NSString *nameXPath = [self novelXPathMapping][propName];
        NSString *name = [self propForName:@"title" node:node xpath:nameXPath];
        return name;
    } else if ([propName isEqualToString:@"coverURL"]) {
        NSString *urlXPath = [self novelXPathMapping][propName];
        NSString *coverURL = [self propForName:@"src" node:node xpath:urlXPath];
        return coverURL;
    } else if ([propName isEqualToString:@"author"]) {
        NSString *authorMath = @"(\\w+)"; //@"([^\\s]+)"
        NSString *authorXPath = [self novelXPathMapping][propName];
        GDataXMLNode *authorNode = [node firstNodeForXPath:authorXPath error:nil];
        NSString *author = [authorNode stringValue];
        NSRange authorRange = [author rangeOfString:authorMath options:NSRegularExpressionSearch];
        author = [author substringWithRange:authorRange];
        return author;
    } else if ([propName isEqualToString:@"intro"]) {
        NSString *introXPath = [self novelXPathMapping][propName];
        GDataXMLNode *introNode = [node firstNodeForXPath:introXPath error:nil];
        NSString *intro = [introNode stringValue];
        return intro;
    } else if ([propName isEqualToString:@"newestTitle"]) {
        NSString *newestXPath = [self novelXPathMapping][propName];
        GDataXMLNode *newestNode = [node firstNodeForXPath:newestXPath error:nil];
        NSString *title = [newestNode stringValue];
        return title;
    } else if ([propName isEqualToString:@"newestURL"]) {
        NSString *newestXPath = [self novelXPathMapping][propName];
        GDataXMLNode *newestNode = [node firstNodeForXPath:newestXPath error:nil];
        NSString *chapterURL = [newestNode propForName:@"href"];
        return chapterURL;
    }
    
    return nil;
}

@end
