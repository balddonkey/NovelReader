//
//  ChapterViewController.m
//  Novel
//
//  Created by 慧流 on 2017/6/5.
//  Copyright © 2017年 慧流. All rights reserved.
//

#import "ChapterViewController.h"
#import "Reader.h"

CGFloat _kChapterFontSize = 18.f;

@interface ChapterViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textTv;

@end

@implementation ChapterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NovelChapter *chapter = [self.provider chapterWithCatalogItem:self.catalogItem];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.title = chapter.title;
            NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithData:[chapter.text dataUsingEncoding:NSUnicodeStringEncoding allowLossyConversion:YES] options:options documentAttributes:nil error:nil];

            NSString *strr = [str string];
            NSString *match = @"([\\S]+)";
            NSError *error;
            NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:match options:NSRegularExpressionCaseInsensitive error:&error];
            if (error) {
                NSLog(@"create: %@", error.localizedDescription);
            }
            NSArray *results = [regular matchesInString:strr options:NSMatchingReportCompletion range:NSMakeRange(0, strr.length)];
            NSLog(@"count: %lu", (unsigned long)results.count);
            NSMutableString *ss = [NSMutableString new];
            for (NSTextCheckingResult *result in results) {
                NSString *elemStr = [strr substringWithRange:result.range];
                NSLog(@"len: %ld", elemStr.length);
                if (elemStr.length < 2) {
                    continue;
                }
                [ss appendFormat:@"%@", elemStr];
                if (result != [results lastObject]) {
                    [ss appendFormat:@"\n"];
                }
            }
            
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
            style.lineSpacing = 5.0f;
            style.firstLineHeadIndent = _kChapterFontSize * 2;
            
            
            self.textTv.attributedText = [[NSAttributedString alloc] initWithString:ss attributes:@{NSParagraphStyleAttributeName: style, NSFontAttributeName: [UIFont systemFontOfSize:_kChapterFontSize]}];
            [self.textTv scrollRangeToVisible:NSMakeRange(0, 1)];
        });
    });
//    NSLog(@"%@", chapter.text);
//    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, str.length)];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
