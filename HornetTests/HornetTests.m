#import <XCTest/XCTest.h>
#import "Hornet.h"

@protocol Proto <NSObject>
@end

@protocol SecondProto <NSObject>
@end

@interface ProtoImpl : NSObject <Proto>
@end

@implementation ProtoImpl
@end

@interface ClassToInject : NSObject
@property id<Proto> injected;
@property id<SecondProto> objectOfSecondProtocol;
@end

@implementation ClassToInject
- (id)init {
    self = [super init];
    [Hornet inject:self];
    return self;
}
@end

@interface HornetTests : XCTestCase
@end

@implementation HornetTests

- (void)setUp {
    [super setUp];

    [Hornet unregisterAll];
}

- (void)testWithoutRegisteredClassObjectShouldntBeCreated {
    //Act
    ClassToInject *object = [ClassToInject new];

    //Assert
    XCTAssertNil(object.injected);
}

- (void)testPropertyOfUnregisteredProtocolShouldBeNil {
    //Arrange
    [Hornet registerClass:[ProtoImpl class] forProtocol:@protocol(Proto)];

    //Act
    ClassToInject *object = [ClassToInject new];

    //Assert
    XCTAssertNil(object.objectOfSecondProtocol);
}

- (void)testAfterRegisteringNoSingletonObjectOfProperClassShouldBeInjected {
    //Arrange
    [Hornet registerClass:[ProtoImpl class] forProtocol:@protocol(Proto)];

    //Act
    ClassToInject *object = [ClassToInject new];

    //Assert
    XCTAssertEqualObjects([object.injected class], [ProtoImpl class]);
}

- (void)testAfterRegisteringNoSingletonEveryInjectedObjectShouldBeNew {
    //Arrange
    [Hornet registerClass:[ProtoImpl class] forProtocol:@protocol(Proto)];

    //Act
    ClassToInject *firstObject = [ClassToInject new];
    ClassToInject *secondObject = [ClassToInject new];

    //Assert
    XCTAssertNotEqual(firstObject.injected, secondObject.injected);
}

- (void)testAfterRegisteringSingletonObjectOfProperClassShouldBeInjected {
    //Arrange
    [Hornet registerSingletonClass:[ProtoImpl class] forProtocol:@protocol(Proto)];

    //Act
    ClassToInject *object = [ClassToInject new];

    //Assert
    XCTAssertEqualObjects([object.injected class], [ProtoImpl class]);
}

- (void)testAfterRegisteringSingletonEveryInjectedObjectShouldBeSameObject {
    //Arrange
    [Hornet registerSingletonClass:[ProtoImpl class] forProtocol:@protocol(Proto)];

    //Act
    ClassToInject *firstObject = [ClassToInject new];
    ClassToInject *secondObject = [ClassToInject new];

    //Assert
    XCTAssertEqual(firstObject.injected, secondObject.injected);
}

@end

