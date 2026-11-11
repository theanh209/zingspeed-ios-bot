// File: MenuUtils.mm
#include "ImGuiDrawViewX.h"
#include "MenuUtils.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define timer(sec) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sec * NSEC_PER_SEC), dispatch_get_main_queue(), ^

@interface MenuUtils()
@property (nonatomic, strong) ImGuiDrawViewX *vna;
- (ImGuiDrawViewX*) GetImGuiView;
@end

static MenuUtils *extraInfo;
ImVec2 MenuOrigin = {(float)SCREEN_WIDTH - 400, 0};
ImVec2 MenuSize = {400, 260};

UIButton* VisibleMenuButton;
MenuInteraction* menuTouchView;
UITextField* hideRecordTextfield;
UIView* hideRecordView;
bool StreamerMode = false;
bool MoveMenu = true;
extern NSString* baseimage;

@interface MenuInteraction()
@end
@implementation MenuInteraction
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect touchableArea = CGRectMake(MenuOrigin.x, MenuOrigin.y, MenuSize.x, MenuSize.y);
    if (CGRectContainsPoint(touchableArea, point)) {
        return [super pointInside:point withEvent:event];
    }
    return NO;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event { [[extraInfo GetImGuiView] updateIOWithTouchEvent:event]; }
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event { [[extraInfo GetImGuiView] updateIOWithTouchEvent:event]; }
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event { [[extraInfo GetImGuiView] updateIOWithTouchEvent:event]; }
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event { [[extraInfo GetImGuiView] updateIOWithTouchEvent:event]; }
@end

@implementation MenuUtils
bool isOpened = false;

- (ImGuiDrawViewX*) GetImGuiView { return _vna; }

+ (void)load {
    [super load];
    timer(3) {
        extraInfo = [MenuUtils new];
        [extraInfo initGesture];
    });
}

// FIX: Thay nút bấm bằng cử chỉ vuốt để không văng app
-(void)initGesture {
    UIView* mainView = [UIApplication sharedApplication].windows[0].rootViewController.view;
    hideRecordTextfield = [[UITextField alloc] init];
    hideRecordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    [hideRecordView setBackgroundColor:[UIColor clearColor]];
    [hideRecordView setUserInteractionEnabled:YES];
    hideRecordTextfield.secureTextEntry = true;
    [hideRecordView addSubview:hideRecordTextfield];
    CALayer *layer = hideRecordTextfield.layer;
    if ([layer.sublayers.firstObject.delegate isKindOfClass:[UIView class]]) {
        hideRecordView = (UIView *)layer.sublayers.firstObject.delegate;
    } else {
        hideRecordView = nil;
    }

    [[UIApplication sharedApplication].keyWindow addSubview:hideRecordView];

    if (!_vna) {
        ImGuiDrawViewX *vc = [[ImGuiDrawViewX alloc] init];
        _vna = vc;
    }

    [ImGuiDrawViewX showChange:false];
    [hideRecordView addSubview:_vna.view];

    menuTouchView = [[MenuInteraction alloc] initWithFrame:mainView.frame];
    [[UIApplication sharedApplication].windows[0].rootViewController.view addSubview:menuTouchView];

    NSData* data = [[NSData alloc] initWithBase64EncodedString:baseimage options:0];
    UIImage* menuIconImage = [UIImage imageWithData:data];

    // Vẫn giữ nút nhìn thấy nhưng không nhận touch trực tiếp
    VisibleMenuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    VisibleMenuButton.frame = CGRectMake(mainView.frame.size.width / 2, mainView.frame.size.height / 2, 50, 50);
    VisibleMenuButton.backgroundColor = [UIColor clearColor];
    VisibleMenuButton.layer.cornerRadius = VisibleMenuButton.frame.size.width * 0.5f;
    [VisibleMenuButton setBackgroundImage:menuIconImage forState:UIControlStateNormal];
    VisibleMenuButton.layer.opacity = 0.7;
    [hideRecordView addSubview:VisibleMenuButton];
    
    // Thêm cử chỉ vuốt 3 ngón tay để mở menu
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toggleMenu)];
    swipe.numberOfTouchesRequired = 3;
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [mainView addGestureRecognizer:swipe];

    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toggleMenu)];
    swipeLeft.numberOfTouchesRequired = 3;
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [mainView addGestureRecognizer:swipeLeft];
}

-(void)toggleMenu {
    dispatch_async(dispatch_get_main_queue(), ^{
        [ImGuiDrawViewX showChange:![ImGuiDrawViewX isMenuShowing]];
        if ([ImGuiDrawViewX isMenuShowing]) {
            _vna.mtkView.paused = NO; // Bật render khi mở
        } else {
            _vna.mtkView.paused = YES; // Tắt render khi đóng
        }
    });
}

@end
