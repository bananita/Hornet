#import "HornetCore.h"
#import "NSObject+Properties.h"

@interface HornetCore ()
@property (nonatomic, readwrite, strong) NSMutableDictionary *mutableMappings;
@property (nonatomic, readwrite, strong) NSMutableDictionary *mutableSingletons;
@end

@implementation HornetCore

- (id)init {
    self = [super init];

    if (self) {
        self.mutableMappings = [NSMutableDictionary new];
        self.mutableSingletons = [NSMutableDictionary new];
    }

    return self;
}

- (NSDictionary *)mappings {
    return [self.mutableMappings copy];
}

- (NSDictionary *)singletons {
    return [self.mutableSingletons copy];
}

- (void)inject:(id)object {
    NSArray *propertyNames = [object namesOfProperties];

    for (NSString *propertyName in propertyNames) {
        Protocol *protocolOfProperty = [object protocolOfPropertyWithName:propertyName];
        NSString *protocolName = NSStringFromProtocol(protocolOfProperty);

        InjectionParameters* injectionParameters = self.mutableMappings[protocolName];

        if (!injectionParameters)
            continue;

        if (injectionParameters.singleton) {
            if (!self.mutableSingletons[protocolName])
                self.mutableSingletons[protocolName] = [injectionParameters.clazz new];

            [object setValue:self.mutableSingletons[protocolName] forKey:propertyName];
            continue;
        }

        [object setValue:[injectionParameters.clazz new] forKey:propertyName];
    }
}

- (void)registerClass:(Class)clazz forProtocol:(Protocol *)protocol {
    InjectionParameters *injectionParameters = [InjectionParameters new];
    injectionParameters.clazz = clazz;
    injectionParameters.singleton = NO;

    self.mutableMappings[NSStringFromProtocol(protocol)] = injectionParameters;
}

- (void)registerSingletonClass:(Class)clazz forProtocol:(Protocol *)protocol {
    InjectionParameters *injectionParameters = [InjectionParameters new];
    injectionParameters.clazz = clazz;
    injectionParameters.singleton = YES;

    self.mutableMappings[NSStringFromProtocol(protocol)] = injectionParameters;
}

- (void)unregisterAll {
    self.mutableMappings = [NSMutableDictionary new];
    self.mutableSingletons = [NSMutableDictionary new];
}

@end

@implementation InjectionParameters
@end