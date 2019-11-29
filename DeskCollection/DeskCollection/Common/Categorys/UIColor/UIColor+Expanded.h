#import <UIKit/UIKit.h>

#define SUPPORTS_UNDOCUMENTED_API 0

@interface UIColor (UIColor_Expanded)

// 颜色空间
@property (nonatomic, readonly) CGColorSpaceModel colorSpaceModel;
// 是否提供了RGB通道
@property (nonatomic, readonly) BOOL canProvideRGBComponents;
// 红色通道值
@property (nonatomic, readonly) CGFloat red; // Only valid if canProvideRGBComponents is YES
// 绿色通道值
@property (nonatomic, readonly) CGFloat green; // Only valid if canProvideRGBComponents is YES
// 蓝色通道值
@property (nonatomic, readonly) CGFloat blue; // Only valid if canProvideRGBComponents is YES
// 灰度色
@property (nonatomic, readonly) CGFloat white; // Only valid if colorSpaceModel == kCGColorSpaceModelMonochrome
// 透明度
@property (nonatomic, readonly) CGFloat alpha;
// rgb整数值
@property (nonatomic, readonly) UInt32 rgbHex;

- (NSString *)colorSpaceString;

- (NSArray *)arrayFromRGBAComponents;

- (BOOL)red:(CGFloat *)r green:(CGFloat *)g blue:(CGFloat *)b alpha:(CGFloat *)a;

- (UIColor *)colorByLuminanceMapping;

- (UIColor *)colorByMultiplyingByRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (UIColor *)colorByAddingRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (UIColor *)colorByLighteningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (UIColor *)colorByDarkeningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

- (UIColor *)colorByMultiplyingBy:(CGFloat)f;
- (UIColor *)colorByAdding:(CGFloat)f;
- (UIColor *)colorByLighteningTo:(CGFloat)f;
- (UIColor *)colorByDarkeningTo:(CGFloat)f;

- (UIColor *)colorByMultiplyingByColor:(UIColor *)color;
- (UIColor *)colorByAddingColor:(UIColor *)color;
- (UIColor *)colorByLighteningToColor:(UIColor *)color;
- (UIColor *)colorByDarkeningToColor:(UIColor *)color;

- (NSString *)stringFromColor;
- (NSString *)hexStringFromColor;

+ (UIColor *)randomColor;
+ (UIColor *)colorWithString:(NSString *)stringToConvert;
+ (UIColor *)colorWithRGBHex:(NSUInteger)hex;
+ (UIColor *)colorWithARGBHex:(NSUInteger)hex;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

+ (UIColor *)colorWithName:(NSString *)cssColorName;

@end

#if SUPPORTS_UNDOCUMENTED_API
// UIColor_Undocumented_Expanded
// Methods which rely on undocumented methods of UIColor
@interface UIColor (UIColor_Undocumented_Expanded)
- (NSString *)fetchStyleString;
- (UIColor *)rgbColor; // Via Poltras
@end
#endif // SUPPORTS_UNDOCUMENTED_API
