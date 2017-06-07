//
//  ReaderDefines.h
//  Novel
//
//  Created by 慧流 on 2017/6/5.
//  Copyright © 2017年 慧流. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *ReaderDomain;

#define keypath(...) \
metamacro_if_eq(1, metamacro_argcount(__VA_ARGS__))(keypath1(__VA_ARGS__))(keypath2(__VA_ARGS__))

//这个宏在取得keypath的同时在编译期间判断keypath是否存在，避免误写
//您可以先不用介意这里面的巫术..
#define keypath1(PATH) \
(((void)(NO && ((void)PATH, NO)), strchr(# PATH, '.') + 1))

#define keypath2(OBJ, PATH) \
(((void)(NO && ((void)OBJ.PATH, NO)), # PATH))

//A和B是否相等，若相等则展开为后面的第一项，否则展开为后面的第二项
//eg. metamacro_if_eq(0, 0)(true)(false) => true
//    metamacro_if_eq(0, 1)(true)(false) => false
#define metamacro_if_eq(A, B) \
metamacro_concat(metamacro_if_eq, A)(B)

#define metamacro_if_eq1(VALUE) metamacro_if_eq0(metamacro_dec(VALUE))

#define metamacro_if_eq0(VALUE) \
metamacro_concat(metamacro_if_eq0_, VALUE)

#define metamacro_if_eq0_1(...) metamacro_expand_

#define metamacro_expand_(...) __VA_ARGS__

#define metamacro_argcount(...) \
metamacro_at(20, __VA_ARGS__, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)

#define metamacro_at(N, ...) \
metamacro_concat(metamacro_at, N)(__VA_ARGS__)

#define metamacro_concat(A, B) \
metamacro_concat_(A, B)

#define metamacro_concat_(A, B) A ## B

#define metamacro_at2(_0, _1, ...) metamacro_head(__VA_ARGS__)

#define metamacro_at20(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, ...) metamacro_head(__VA_ARGS__)

#define metamacro_head(...) \
metamacro_head_(__VA_ARGS__, 0)

#define metamacro_head_(FIRST, ...) FIRST

#define metamacro_dec(VAL) \
metamacro_at(VAL, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19)
