#import <objc/runtime.h>
#import <objc/message.h>

@interface NSObject (Swizzle)

+ (BOOL)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector;

@end