#import <Foundation/Foundation.h>

@interface Hornet : NSObject

+ (void)inject:(id)object;

+ (void)registerClass:(Class)clazz forProtocol:(Protocol *)protocol;
+ (void)registerSingletonClass:(Class)clazz forProtocol:(Protocol *)protocol;

+ (void)unregisterAll;

@end
