// Macros

#define NSURL(s) [NSURL URLWithString:s]
#define UIIMAGE(s) [UIImage imageNamed:s]


// UIColor Macros

#define HSB(hue, saturation, brightness, alpha) [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0]
#define HSBA(hue, saturation, brightness, alpha) [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha]
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#if !defined(COMPARE)
#define COMPARE(A,B) ({ __typeof__(A) __a = (A); __typeof__(B) __b = (B); __a < __b ? NSOrderedAscending : (__a > __b ? NSOrderedDescending : NSOrderedSame); })
#endif


// Functions

static inline BOOL IsEmpty(id thing) {
    return thing == nil
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}
