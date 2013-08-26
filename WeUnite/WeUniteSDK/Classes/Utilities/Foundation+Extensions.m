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
@end


@implementation NSMutableDictionary(Extensions)
-(void)setObject:(id)tObject forKey1:(NSString *)tKey1 forKey2:(NSString *)tKey2{
    NSString *key1key2 = [NSString stringWithFormat:@"%@%@",tKey1,tKey2];
    [self setObject:tObject forKey:key1key2];
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

@end

