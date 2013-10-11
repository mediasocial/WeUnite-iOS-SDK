//
//  Foundation+Extensions.m
//  NE
//
//  Created by Anthony Gonslaves on 05/03/12.
//  Copyright (c) 2012 Demansol. All rights reserved.
//
#include <CommonCrypto/CommonHMAC.h>
#import "Foundation+Extensions.h"

#if __has_feature(objc_arc) && __clang_major__ >= 3
#define ARC_ENABLED 1
#endif // __has_feature(objc_arc)

@implementation NSDictionary(Utility)
-(id)objectForkey1:(NSString *)tKey1 key2:(NSString *)tKey2{
    NSString *key1key2 = [NSString stringWithFormat:@"%@%@",tKey1,tKey2];
    id object = [self objectForKey:key1key2];    
    return object;
}

-(id)valueForKey1:(NSString *)tKey1 key2:(NSString *)tKey2{
    return [self objectForkey1:tKey1 key2:tKey2];
}


- (NSDictionary *)dictionaryByReplacingNullWithValue:(id)tObj {
    NSMutableDictionary *replaced = [self mutableCopy];
    [replaced replaceNullWithValue:tObj];
    return replaced;
}

@end


@implementation NSMutableDictionary(Extensions)
-(void)setObject:(id)tObject forKey1:(NSString *)tKey1 forKey2:(NSString *)tKey2{
    NSString *key1key2 = [NSString stringWithFormat:@"%@%@",tKey1,tKey2];
    [self setObject:tObject forKey:key1key2];
}



-(void)replaceNullWithValue:(id)tObj{
    for(int i =0; i<self.allKeys.count; i++)
    {
        id key = self.allKeys[i];
        id value = [self objectForKey:key];
        if([value isKindOfClass:[NSDictionary class]])
        {
            NSMutableDictionary *mutableDict = (NSMutableDictionary *)[NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)value];
            [mutableDict replaceNullWithValue:tObj];
            [self setObject:mutableDict forKey:key];
        }
        else if([value isKindOfClass:[NSArray class]])
        {
            NSMutableArray *mutableArray = (NSMutableArray *)[(NSArray *)value mutableCopy];
            [mutableArray replaceNullWithValue:tObj];
            [self setObject:mutableArray forKey:key];
        }
        else if([value isKindOfClass:[NSNull class]]){
            [self setObject:tObj forKey:key];
        }
        else if([value isKindOfClass:[NSString class]]){
            NSString *stringVal = (NSString *)value;
            if([stringVal isEqualToString:@"<null>"]){
                [self setObject:tObj forKey:key];
            }
        }

    }
    NSLog(@"%@",self);
    
}



@end

@implementation NSArray (Extensions)
- (NSArray *)arrayByReplacingNullWithValue:(id)tObj {
    NSMutableArray *replaced = [self mutableCopy];
    [replaced replaceNullWithValue:tObj];
    return replaced;
}

@end

@implementation NSMutableArray(Extensions)
-(bool)replaceObject:(id)tObject1 byObject:(id)tObject2{
    if (![self containsObject:tObject1]) 
        return false;
    
    int index = [self indexOfObject:tObject1];
    [self replaceObjectAtIndex:index withObject:tObject2];    
    return true; 
}

-(void)objectsPerformSelector:(SEL)sel{
    [self objectsPerformSelector:sel withObject:nil];
}

-(void)objectsPerformSelector:(SEL)sel withObject:(id)tObj{
    int count = [self count];
    for (int i = 0; i < count; i++) {
        NSObject *obj = [self objectAtIndex:i];
        if ([obj respondsToSelector:sel]) {
            [obj performSelector:sel withObject:tObj];
        }
    }
}

-(void)replaceNullWithValue:(id)tObj{
    for (int i= 0; i<self.count; i++) {
        id object = [self objectAtIndex:i];
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *mutableDict = (NSMutableDictionary *)[NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)object];;
            [mutableDict replaceNullWithValue:tObj];
            [self replaceObjectAtIndex:i withObject:mutableDict];
        }
        else if([object isKindOfClass:[NSArray class]]){
            NSMutableArray *mutableArray = (NSMutableArray *)[(NSArray *)object mutableCopy];
            [mutableArray replaceNullWithValue:tObj];
            [self replaceObjectAtIndex:i withObject:mutableArray];
        }
        else if([object isKindOfClass:[NSNull class]]){
            [self replaceObjectAtIndex:i withObject:tObj];
        }
        else if([object isKindOfClass:[NSString class]]){
            NSString *stringVal = (NSString *)object;
            if([stringVal isEqualToString:@"<null>"]){
                [self replaceObjectAtIndex:i withObject:tObj];
            }
        }
    }
}
@end


@implementation NSString (Extensions)
-(NSString *)urlEncode{
    NSString *encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                  NULL,
                                                                                  (CFStringRef)self,
                                                                                  NULL,
                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                  kCFStringEncodingUTF8 );
    return encodedString;
}




-(bool)containsSubstring:(NSString *)substring options:(NSStringCompareOptions)options{
    NSRange range = [self rangeOfString:substring options:NSCaseInsensitiveSearch];
    if (range.location == NSNotFound) 
        return NO;
    
    return YES;
}

-(BOOL)isValidEmailID{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    BOOL isValidEmailID = [emailTest evaluateWithObject:self];
    
    return isValidEmailID;
}

-(NSString *)SHA1EncodedString{
    NSString *hashkey = self;
    // PHP uses ASCII encoding, not UTF
    const char *s = [hashkey cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    // This is the destination
    uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0};
    // This one function does an unkeyed SHA1 hash of your hash data
    CC_SHA1(keyData.bytes, keyData.length, digest);
    
    // Now convert to NSData structure to make it usable again
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    // description converts to hex but puts <> around it and spaces every 4 bytes
    NSString *hash = [out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}

-(NSDate *)dateFromDateFormat:(NSString *)tDateFormat{
   // @"EE, d LLLL yyyy HH:mm:ss Z" == @"Tue, 25 May 2010 12:53:58 +0000"
    //a for am or pm
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:tDateFormat];
    NSDate *date = [dateFormat dateFromString:self];
#ifndef ARC_ENABLED
    [dateFormatter release];
#endif
    return date;
}

@end

@implementation NSDate(Utility)

-(NSString *)stringFromDateFormat:(NSString *)tDateFormat
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
	[dateFormatter setDateFormat:tDateFormat];
    
    NSString *dateString = [dateFormatter stringFromDate:self];
    
    
#ifndef ARC_ENABLED
    [dateFormatter release];
#endif

	return dateString;
}

-(NSDate *)dateFromUTCtoLocalTime{
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:self];
    NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:self];
    NSTimeInterval gmtInterval = currentGMTOffset - gmtOffset;
    
    NSDate *destinationDate = [NSDate dateWithTimeInterval:gmtInterval sinceDate:self] ;
    return destinationDate;
}

- (NSString *)timeAgoFormat
{
    double seconds = [self timeIntervalSince1970];
    double difference = [[NSDate date] timeIntervalSince1970] - seconds;
    NSMutableArray *periods = [NSMutableArray arrayWithObjects:@"second", @"minute", @"hour", @"day", @"week", @"month", @"year", @"decade", nil];
    NSArray *lengths = [NSArray arrayWithObjects:@60, @60, @24, @7, @4.35, @12, @10, nil];
    int j = 0;
    for(j=0; difference >= [[lengths objectAtIndex:j] doubleValue]; j++)
    {
        difference /= [[lengths objectAtIndex:j] doubleValue];
    }
    difference = roundl(difference);
    if(difference != 1)
    {
        [periods insertObject:[[periods objectAtIndex:j] stringByAppendingString:@"s"] atIndex:j];
    }
    return [NSString stringWithFormat:@"%li %@%@", (long)difference, [periods objectAtIndex:j], @" ago"];
}

@end

