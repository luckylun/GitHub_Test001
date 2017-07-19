//
//  ThemeManager.m
//  ThemeSkinSetupExample
//
//  Created by Macmini on 16/1/27.
//
//

#import "ThemeManager.h"
#import "NotificationMacro.h"



static ThemeManager * sharedThemeManager;

@interface ThemeManager()


@property (nonatomic,copy) NSString *themPath;

@end


@implementation ThemeManager

- (id) init {
    if(self = [super init]) {
        NSString * themePath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
        self.themPath = themePath;
        self.themePlistDict = [NSDictionary dictionaryWithContentsOfFile:themePath];
        self.themeName = nil;
    }
    
    return self;
}

+ (ThemeManager *) sharedThemeManager {
    @synchronized(self) {
        if (nil == sharedThemeManager) {
            sharedThemeManager = [[ThemeManager alloc] init];
        }
    }
    
    return sharedThemeManager;
}

// Override 重写themeName的set方法
- (void) setThemeName:(NSString *)themeName {
    _themeName = themeName;
}

- (UIImage *) themeImageWithName:(NSString *)imageName {
    if (imageName == nil) {
        return nil;
    }
    
    NSString * themePath = self.themPath;
    
    if (self.themeName) {
        if (![themePath hasSuffix:self.themeName]) {
            themePath = [self themePath];
            self.themPath = themePath;
        }
    }else{
        themePath = [self themePath];
        self.themPath = themePath;
    }
    
//    NSString * themeImagePath = [themePath stringByAppendingPathComponent:imageName];
//    UIImage * themeImage = [UIImage imageWithContentsOfFile:themeImagePath];
    
    NSString * themeSubPath = [self.themePlistDict objectForKey:self.themeName];
    
    NSString *newImagePath = [themeSubPath stringByAppendingPathComponent:imageName];
    UIImage *image = [UIImage imageNamed:newImagePath];
    
    return image;
}

// 返回主题路径
- (NSString *)themePath {
    NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
    if (self.themeName == nil || [self.themeName isEqualToString:@""]) {
        return resourcePath;
    }
    NSString * themeSubPath = [self.themePlistDict objectForKey:self.themeName];    // Skins/blue
    NSString * themeFilePath = [resourcePath stringByAppendingPathComponent:themeSubPath]; // .../Skins/blue
    
    return themeFilePath;
}
@end
