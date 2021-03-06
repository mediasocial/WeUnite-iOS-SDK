//
//  Foundation+Extensions.h
//  NE
//
//  Created by Anthony Gonslaves on 05/03/12.
//  Copyright (c) 2012 Demansol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(Utility)
    -(id)objectForkey1:(NSString *)tKey1 key2:(NSString *)tKey2;
    -(id)valueForKey1:(NSString *)tKey1 key2:(NSString *)tKey2;
    - (NSDictionary *)dictionaryByReplacingNullWithValue:(id)tObj;
@end


@interface NSMutableDictionary(Extensions)
    -(void)setObject:(id)tObject forKey1:(NSString *)tKey1 forKey2:(NSString*)tKey2;
    -(void)replaceNullWithValue:(id)tObj;
@end

@interface NSArray (Extensions)
- (NSArray *)arrayByReplacingNullWithValue:(id)tObj ;
@end

@interface NSMutableArray(Extensions)
    -(bool)replaceObject:(id)tObject1 byObject:(id)tObject2;
    -(void)objectsPerformSelector:(SEL)sel;
    -(void)objectsPerformSelector:(SEL)sel withObject:(id)tObj;
    -(void)replaceNullWithValue:(id)tObj;
@end

@interface NSString (Extensions)
    -(bool)containsSubstring:(NSString *)substring options:(NSStringCompareOptions)options;
    -(NSString *)urlEncode;
    -(BOOL)isValidEmailID;
    -(NSString *)SHA1EncodedString;
    -(NSDate *)dateFromDateFormat:(NSString *)tDateFormat;
@end

@interface NSDate(Utility)
    -(NSDate *)dateFromUTCtoLocalTime;
    -(NSString *)stringFromDateFormat:(NSString *)tDateFormat;
    -(NSString *)timeAgoFormat;
@end
