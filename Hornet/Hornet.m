#import "Hornet.h"
#import "HornetCore.h"

@implementation Hornet

+ (void)inject:(id)object {
    [[self core] inject:object];
}

+ (void)registerClass:(Class)clazz forProtocol:(Protocol *)protocol {
    [[self core] registerClass:clazz forProtocol:protocol];
}

+ (void)registerSingletonClass:(Class)clazz forProtocol:(Protocol *)protocol {
    [[self core] registerSingletonClass:clazz forProtocol:protocol];
}

+ (void)unregisterAll {
    [[self core] unregisterAll];
}

+ (HornetCore *)core {
    static HornetCore *core;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        core = [HornetCore new];
    });
    return core;
}

@end
