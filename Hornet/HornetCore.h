#import <Foundation/Foundation.h>

@interface HornetCore : NSObject

@property (nonatomic, readonly) NSDictionary *mappings;
@property (nonatomic, readonly) NSDictionary *singletons;

- (void)inject:(id)object;
- (void)registerClass:(Class)clazz forProtocol:(Protocol *)protocol;
- (void)registerSingletonClass:(Class)clazz forProtocol:(Protocol *)protocol;
- (void)unregisterAll;

@end

@interface InjectionParameters : NSObject

@property Class clazz;
@property BOOL singleton;

@end