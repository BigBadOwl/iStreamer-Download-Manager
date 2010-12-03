#import "MyMutableURLRequest.h"
#import "MethodSwizzling.h"

@implementation NSMutableURLRequest (MyMutableURLRequest)

- (void)newSetValue:(NSString *)value forHTTPHeaderField:(NSString *)field;
{
    if ([field isEqualToString:@"User-Agent"]) {
        value = @"Mozilla/5.0 (iPad; U; CPU OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B334b Safari/531.21.10";
		//value = @"Mozilla/5.0 (X11; U; Linux i686; pl-PL; rv:1.9.0.2) Gecko/20121223 Ubuntu/9.25 (jaunty) Firefox/3.8";
    }
    [self newSetValue:value forHTTPHeaderField:field];
}

+ (void)setupUserAgentOverwrite
{
    [self swizzleMethod:@selector(setValue:forHTTPHeaderField:)
            withMethod:@selector(newSetValue:forHTTPHeaderField:)];
}

@end