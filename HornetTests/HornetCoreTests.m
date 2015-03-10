#import <XCTest/XCTest.h>
#import "HornetCore.h"

@protocol FirstProto <NSObject>
@end

@protocol SecondProto <NSObject>
@end

@interface FirstProtoImpl : NSObject <FirstProto>
@end

@interface SecondProtoImpl : NSObject <SecondProto>
@end

@interface HornetCoreTests : XCTestCase

@property HornetCore *hornetCore;

@end

@implementation HornetCoreTests

- (void)setUp {
    [super setUp];

    self.hornetCore = [HornetCore new];
}

- (void)testAfterInitializationDictionaryOfMappingsShouldBeReady {
    //Assert
    XCTAssertNotEqualObjects([self.hornetCore.mappings class], [NSDictionary class]);
    XCTAssertTrue(self.hornetCore.mappings.count == 0);
}

- (void)testAfterInitializationDictionaryOfSingletonsShouldBeReady {
    //Assert
    XCTAssertNotEqualObjects([self. hornetCore.singletons class], [NSDictionary class]);
    XCTAssertTrue(self.hornetCore.singletons.count == 0);
}

- (void)testRegisteringClassShouldAddItToADictionary {
    //Act
    [self.hornetCore registerClass:[FirstProtoImpl class] forProtocol:@protocol(FirstProto)];

    //Assert
    InjectionParameters *parameters = self.hornetCore.mappings[NSStringFromProtocol(@protocol(FirstProto))];
    XCTAssertEqualObjects(parameters.clazz, [FirstProtoImpl class]);
    XCTAssertFalse(parameters.singleton);
}

- (void)testRegisteringSingletonClassShouldAddItToSingletonDictionary {
    //Act
    [self.hornetCore registerSingletonClass:[FirstProtoImpl class] forProtocol:@protocol(FirstProto)];

    //Assert
    InjectionParameters *parameters = self.hornetCore.mappings[NSStringFromProtocol(@protocol(FirstProto))];
    XCTAssertEqualObjects(parameters.clazz, [FirstProtoImpl class]);
    XCTAssertTrue(parameters.singleton);
}

- (void)testUnregisteringShouldLeaveEmptyDictionaries {
    //Arrange
    [self.hornetCore registerClass:[FirstProtoImpl class] forProtocol:@protocol(FirstProto)];
    [self.hornetCore registerSingletonClass:[SecondProtoImpl class] forProtocol:@protocol(SecondProto)];

    //Act
    [self.hornetCore unregisterAll];

    //Assert
    XCTAssertNotEqualObjects([self.hornetCore.mappings class], [NSDictionary class]);
    XCTAssertTrue(self.hornetCore.mappings.count == 0);
    XCTAssertNotEqualObjects([self.hornetCore.singletons class], [NSDictionary class]);
    XCTAssertTrue(self.hornetCore.singletons.count == 0);
}

@end

@implementation FirstProtoImpl
@end
@implementation SecondProtoImpl
@end