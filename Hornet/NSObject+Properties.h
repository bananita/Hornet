#import <Foundation/Foundation.h>

@interface NSObject (Properties)

- (NSArray *)namesOfProperties;
- (Protocol *)protocolOfPropertyWithName:(NSString *)propertyName;

@end
