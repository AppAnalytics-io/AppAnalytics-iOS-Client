#import "AAHardware.h"
#import <sys/utsname.h>
#import <UIKit/UIKit.h>

@implementation AAHardware

typedef struct
{
    NSUInteger major;
    NSUInteger minor;
} DeviceVersion;

typedef NS_ENUM(NSInteger, DeviceModel)
{
    DeviceModel_Unknown = 0,
    DeviceModel_SimulatoriPhone,
    DeviceModel_SimulatoriPad,
    DeviceModel_iPhone1,
    DeviceModel_iPhone3G,
    DeviceModel_iPhone3GS,
    DeviceModel_iPhone4,
    DeviceModel_iPhone4S,
    DeviceModel_iPhone5,
    DeviceModel_iPhone5C,
    DeviceModel_iPhone5S,
    DeviceModel_iPhone6,
    DeviceModel_iPhone6Plus,
    DeviceModel_iPad1,
    DeviceModel_iPad2,
    DeviceModel_iPad3,
    DeviceModel_iPad4,
    DeviceModel_iPadMini1,
    DeviceModel_iPadMini2,
    DeviceModel_iPadMini3,
    DeviceModel_iPadAir1,
    DeviceModel_iPadAir2,
    DeviceModel_iPod1,
    DeviceModel_iPod2,
    DeviceModel_iPod3,
    DeviceModel_iPod4,
    DeviceModel_iPod5,
};

typedef NS_ENUM(NSInteger, DeviceFamily)
{
    DeviceFamily_Unknown = 0,
    DeviceFamily_iPhone,
    DeviceFamily_iPad,
    DeviceFamily_iPod,
    DeviceFamily_Simulator,
};

+ (NSString *)rawSystemInfoString
{
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (DeviceVersion)deviceVersion
{
    NSString *systemInfoString = [self rawSystemInfoString];
    
    NSUInteger positionOfFirstInteger = [systemInfoString rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location;
    NSUInteger positionOfComma = [systemInfoString rangeOfString:@","].location;
    
    NSUInteger major = 0;
    NSUInteger minor = 0;
    
    if (positionOfComma != NSNotFound)
    {
        major = [[systemInfoString substringWithRange:NSMakeRange(positionOfFirstInteger, positionOfComma - positionOfFirstInteger)] integerValue];
        minor = [[systemInfoString substringFromIndex:positionOfComma + 1] integerValue];
    }
    
    return (DeviceVersion){major, minor};
}

+ (NSString*)modelName
{
    DeviceFamily family = DeviceFamily_Unknown;
    DeviceModel model = DeviceModel_Unknown;
    NSString *modelString = @"Unknown Device";
    
    // Simulator
    if (TARGET_IPHONE_SIMULATOR)
    {
        family = DeviceFamily_Simulator;
        
        BOOL iPadScreen = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        model = iPadScreen ? DeviceModel_SimulatoriPad : DeviceModel_SimulatoriPhone;
        modelString = iPadScreen ? @"iPad Simulator": @"iPhone Simulator";
    }
    // Actual device
    else
    {
        DeviceVersion deviceVersion = [self deviceVersion];
        NSString *systemInfoString = [self rawSystemInfoString];
        
        
        NSDictionary *familyManifest = @{@"iPhone": @(DeviceFamily_iPhone),
                                         @"iPad": @(DeviceFamily_iPad),
                                         @"iPod": @(DeviceFamily_iPod),
                                         };
        
        NSDictionary *modelManifest = @{
            @"iPhone": @{
            // 1st Gen
            @[@(1), @(1)]: @[@(DeviceModel_iPhone1), @"iPhone 1"],
            
            // 3G
            @[@(1), @(2)]: @[@(DeviceModel_iPhone3G), @"iPhone 3G"],
            
            // 3GS
            @[@(2), @(1)]: @[@(DeviceModel_iPhone3GS), @"iPhone 3GS"],
            
            // 4
            @[@(3), @(1)]: @[@(DeviceModel_iPhone4), @"iPhone 4"],
            @[@(3), @(2)]: @[@(DeviceModel_iPhone4), @"iPhone 4"],
            @[@(3), @(3)]: @[@(DeviceModel_iPhone4), @"iPhone 4"],
            
            // 4S
            @[@(4), @(1)]: @[@(DeviceModel_iPhone4S), @"iPhone 4S"],
            
            // 5
            @[@(5), @(1)]: @[@(DeviceModel_iPhone5), @"iPhone 5"],
            @[@(5), @(2)]: @[@(DeviceModel_iPhone5), @"iPhone 5"],
            
            // 5C
            @[@(5), @(3)]: @[@(DeviceModel_iPhone5C), @"iPhone 5C"],
            @[@(5), @(4)]: @[@(DeviceModel_iPhone5C), @"iPhone 5C"],
            
            // 5S
            @[@(6), @(1)]: @[@(DeviceModel_iPhone5S), @"iPhone 5S"],
            @[@(6), @(2)]: @[@(DeviceModel_iPhone5S), @"iPhone 5S"],
            
            // 6 Plus
            @[@(7), @(1)]: @[@(DeviceModel_iPhone6Plus), @"iPhone 6 Plus"],
            
            // 6
            @[@(7), @(2)]: @[@(DeviceModel_iPhone6), @"iPhone 6"],
            },
    @"iPad": @{
            // 1
            @[@(1), @(1)]: @[@(DeviceModel_iPad1), @"iPad 1"],
            
            // 2
            @[@(2), @(1)]: @[@(DeviceModel_iPad2), @"iPad 2"],
            @[@(2), @(2)]: @[@(DeviceModel_iPad2), @"iPad 2"],
            @[@(2), @(3)]: @[@(DeviceModel_iPad2), @"iPad 2"],
            @[@(2), @(4)]: @[@(DeviceModel_iPad2), @"iPad 2"],
            
            // Mini
            @[@(2), @(5)]: @[@(DeviceModel_iPadMini1), @"iPad Mini 1"],
            @[@(2), @(6)]: @[@(DeviceModel_iPadMini1), @"iPad Mini 1"],
            @[@(2), @(7)]: @[@(DeviceModel_iPadMini1), @"iPad Mini 1"],
            
            // 3
            @[@(3), @(1)]: @[@(DeviceModel_iPad3), @"iPad 3"],
            @[@(3), @(2)]: @[@(DeviceModel_iPad3), @"iPad 3"],
            @[@(3), @(3)]: @[@(DeviceModel_iPad3), @"iPad 3"],
            
            // 4
            @[@(3), @(4)]: @[@(DeviceModel_iPad4), @"iPad 4"],
            @[@(3), @(5)]: @[@(DeviceModel_iPad4), @"iPad 4"],
            @[@(3), @(6)]: @[@(DeviceModel_iPad4), @"iPad 4"],
            
            // Air
            @[@(4), @(1)]: @[@(DeviceModel_iPadAir1), @"iPad Air 1"],
            @[@(4), @(2)]: @[@(DeviceModel_iPadAir1), @"iPad Air 1"],
            @[@(4), @(3)]: @[@(DeviceModel_iPadAir1), @"iPad Air 1"],
            
            // Mini 2
            @[@(4), @(4)]: @[@(DeviceModel_iPadMini2), @"iPad Mini 2"],
            @[@(4), @(5)]: @[@(DeviceModel_iPadMini2), @"iPad Mini 2"],
            @[@(4), @(6)]: @[@(DeviceModel_iPadMini2), @"iPad Mini 2"],
            
            // Mini 3
            @[@(4), @(7)]: @[@(DeviceModel_iPadMini3), @"iPad Mini 3"],
            @[@(4), @(8)]: @[@(DeviceModel_iPadMini3), @"iPad Mini 3"],
            @[@(4), @(9)]: @[@(DeviceModel_iPadMini3), @"iPad Mini 3"],
            
            // Air 2
            @[@(5), @(3)]: @[@(DeviceModel_iPadAir2), @"iPad Air 2"],
            @[@(5), @(4)]: @[@(DeviceModel_iPadAir2), @"iPad Air 2"],
            },
    @"iPod": @{
            // 1st Gen
            @[@(1), @(1)]: @[@(DeviceModel_iPod1), @"iPod Touch 1"],
            
            // 2nd Gen
            @[@(2), @(1)]: @[@(DeviceModel_iPod2), @"iPod Touch 2"],
            
            // 3rd Gen
            @[@(3), @(1)]: @[@(DeviceModel_iPod3), @"iPod Touch 3"],
            
            // 4th Gen
            @[@(4), @(1)]: @[@(DeviceModel_iPod4), @"iPod Touch 4"],
            
            // 5th Gen
            @[@(5), @(1)]: @[@(DeviceModel_iPod5), @"iPod Touch 5"],
            },
        };
        
        for (NSString *familyString in familyManifest)
        {
            if ([systemInfoString hasPrefix:familyString])
            {
                family = [familyManifest[familyString] integerValue];
                
                NSArray *modelNuances = modelManifest[familyString][@[@(deviceVersion.major), @(deviceVersion.minor)]];
                if (modelNuances)
                {
                    model = [modelNuances[0] integerValue];
                    modelString = modelNuances[1];
                }
                
                break;
            }
        }
    }
    
    return modelString;
}

@end
