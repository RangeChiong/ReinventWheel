//
//  RWQRCodeController.m
//  Centaline
//
//  Created by Ranger on 16/5/12.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "RWQRCodeController.h"
#import <AVFoundation/AVFoundation.h>

#define QR_Screen_Bounds   [UIScreen mainScreen].bounds
#define QR_Screen_Width    [UIScreen mainScreen].bounds.size.width
#define QR_Screen_Height   [UIScreen mainScreen].bounds.size.height

static CGFloat const DefaultScanWidth = 220;


static CGFloat const CornerLayerLength = 20.0f;

#define pLeft    rect.origin.x
#define pTop     rect.origin.y
#define pWidth   rect.size.width
#define pHeight  rect.size.height
#define pRight   pLeft + pWidth
#define pBottom  pTop + pHeight

#pragma mark-  QRCodeMaskView

@interface QRCodeMaskView : UIView

- (void)setScanViewFrame:(CGRect)rect;

@end

@implementation QRCodeMaskView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
    }
    return self;
}

- (void)setScanViewFrame:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:QR_Screen_Bounds];
    [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0] bezierPathByReversingPath]];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [self.layer setMask:shapeLayer];
    
    [self drawCorners:rect];
}


- (void)drawCorners:(CGRect)rect {
    
    CAShapeLayer *rectLayer = [CAShapeLayer layer];
    rectLayer.path = [UIBezierPath bezierPathWithRect:rect].CGPath;
    rectLayer.lineCap = kCALineCapSquare;
    rectLayer.lineWidth = 2.5f;
    rectLayer.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4].CGColor;
    rectLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:rectLayer];
    
    CAShapeLayer *cornerLayer1 = [self drawCorner:CGPointMake(pLeft + CornerLayerLength, pTop)
                                      centerPoint:CGPointMake(pLeft, pTop)
                                         endPoint:CGPointMake(pLeft, pTop + CornerLayerLength)];
    [self.layer addSublayer:cornerLayer1];
    
    CAShapeLayer *cornerLayer2 = [self drawCorner:CGPointMake(pRight - CornerLayerLength, pTop)
                                      centerPoint:CGPointMake(pRight, pTop)
                                         endPoint:CGPointMake(pRight, pTop + CornerLayerLength)];
    [self.layer addSublayer:cornerLayer2];
    
    CAShapeLayer *cornerLayer3 = [self drawCorner:CGPointMake(pRight, pBottom - CornerLayerLength)
                                      centerPoint:CGPointMake(pRight, pBottom)
                                         endPoint:CGPointMake(pRight - CornerLayerLength, pBottom)];
    [self.layer addSublayer:cornerLayer3];
    
    CAShapeLayer *cornerLayer4 = [self drawCorner:CGPointMake(pLeft, pBottom - CornerLayerLength)
                                      centerPoint:CGPointMake(pLeft, pBottom)
                                         endPoint:CGPointMake(pLeft + CornerLayerLength, pBottom)];
    [self.layer addSublayer:cornerLayer4];
    
}

- (CAShapeLayer *)drawCorner:(CGPoint)sP centerPoint:(CGPoint)cP endPoint:(CGPoint)eP {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineCap = kCALineCapSquare;
    layer.lineWidth = 5.0f;
    layer.strokeColor = [UIColor greenColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:sP];
    [bezierPath addLineToPoint:cP];
    [bezierPath addLineToPoint:eP];
    layer.path = bezierPath.CGPath;
    
    //    CGMutablePathRef linePath = CGPathCreateMutable();
    //    CGPathMoveToPoint(linePath, NULL, sP.x, sP.y);
    //    CGPathAddLineToPoint(linePath, NULL, cP.x, cP.y);
    //    CGPathAddLineToPoint(linePath, NULL, eP.x, eP.y);
    //    layer.path = linePath;
    //    CGPathRelease(linePath);
    
    return layer;
}

@end

#pragma mark-  QRCodeScanLineView

@interface QRCodeScanLineView : UIView {
    CADisplayLink * _timer;
    CGFloat _moveLineMinY;
    CGFloat _moveLineMaxY;
    BOOL _moveFlag;
}

@property (nonatomic, strong) UIImageView *line;

- (void)startAnimation;
- (void)stopAnimation;

@end

@implementation QRCodeScanLineView

- (instancetype)initWithFrame:(CGRect)frame scanHeight:(CGFloat)height {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.line];
        _moveLineMinY = 0;
        _moveLineMaxY = height - self.frame.size.height;
    }
    return self;
}

- (void)startAnimation {
    _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(moveLine)];
    [_timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stopAnimation {
    [_timer invalidate];
    _timer = nil;
    
    _moveFlag = NO;
    CGRect rect = _line.frame;
    rect.origin.y = 0;
    _line.frame = rect;
}


- (void)moveLine {
    
    if (_line.frame.origin.y <= _moveLineMaxY) {
        if (_moveFlag) {
            _line.transform = CGAffineTransformTranslate(_line.transform, 0, -3);
            
            if (_line.frame.origin.y <= _moveLineMinY) {
                _moveFlag = NO;
            }
        }else {
            _line.transform = CGAffineTransformTranslate(_line.transform, 0, 3);
            
            if (_line.frame.origin.y >= _moveLineMaxY - _line.frame.size.height) {
                _moveFlag = YES;
            }
        }
    }
}


#pragma mark-   Setter & Getter

- (UIImageView *)line {
    if (_line) {
        return _line;
    }
    _line = [[UIImageView alloc] initWithFrame:self.bounds];
    _line.backgroundColor = [UIColor greenColor];
    
    CAGradientLayer *colorLayer = [CAGradientLayer layer];
    colorLayer.frame    = (CGRect){CGPointZero, _line.frame.size};
    colorLayer.position = _line.center;
    [_line.layer addSublayer:colorLayer];
    
    colorLayer.colors = @[(__bridge id)[UIColor colorWithRed:0 green:150/255.0 blue:0 alpha:1].CGColor,
                          (__bridge id)[UIColor greenColor].CGColor,
                          (__bridge id)[UIColor colorWithRed:0 green:150/255.0 blue:0 alpha:1].CGColor];
    colorLayer.locations  = @[@(0.25), @(0.5), @(0.75)];
    colorLayer.startPoint = CGPointMake(0, 0);
    colorLayer.endPoint   = CGPointMake(1, 0);
    
    return _line;
}

@end

#pragma mark-  RWQRCodeController

@interface RWQRCodeController ()<
AVCaptureMetadataOutputObjectsDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate> {
    

}

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;

@property (nonatomic, strong) QRCodeMaskView *maskView;
@property (nonatomic, strong) QRCodeScanLineView *line;

@property (nonatomic, copy) void(^takeQRCodeStringBlock)(NSString *metaString); //!< block返回扫描信息
@property (nonatomic, copy) void(^takeQRCodeStringFromPhotoBlock)(NSString *metaString); //!< block返回扫描信息

@end

@implementation RWQRCodeController

+ (instancetype)showWithController:(UIViewController *)controller
                  takeQRCodeString:(void(^)(NSString *metaString))block {
    RWQRCodeController *scaner = [[RWQRCodeController alloc] initWithController:controller];
    scaner.takeQRCodeStringBlock = ^(NSString *metaString) {
        block(metaString);
    };
    return scaner;
}

- (instancetype)initWithController:(UIViewController *)controller {
    if (self = [super init]) {
        [self addToController:controller];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self __initialize];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.view.layer insertSublayer:self.videoPreviewLayer atIndex:0];
    [self startQRCodeScan];

    if (_showsDefaultMaskView) {
        [self.view addSubview:self.maskView];
        [self.view addSubview:self.line];
        [_line startAnimation];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self stopQRCodeScan];
}

- (void)__initialize {
    _canScanBarCode = NO;
    _showsDefaultMaskView = YES;
    
    _scanRect = CGRectMake((QR_Screen_Width - DefaultScanWidth) / 2,
                           (QR_Screen_Height - DefaultScanWidth) / 2,
                           DefaultScanWidth,
                           DefaultScanWidth);
}

#pragma mark-  开启和关闭扫描

- (void)startQRCodeScan {
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authorizationStatus) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler: ^(BOOL granted) {
                if (granted) {
                    [_session startRunning];
                }else {
                    NSLog(@"访问受限");
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            [_session startRunning];
            break;
        }
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied: {
            NSLog(@"%@", @"访问受限");
            break;
        }
        default:
            break;
    }
//    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
//        if (granted) {
//            [_session startRunning];
//        }else {
//            NSLog(@"访问受限");
//        }
//    }];
}

- (void)stopQRCodeScan {
    [_session stopRunning];
}

#pragma mark - 开灯或关灯
- (void)openLight:(BOOL)opened {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (![device hasTorch]) {
    } else {
        if (opened) {
            // 开启闪光灯
            if(device.torchMode != AVCaptureTorchModeOn ||
               device.flashMode != AVCaptureFlashModeOn){
                [device lockForConfiguration:nil];
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                [device unlockForConfiguration];
            }
        } else {
            // 关闭闪光灯
            if(device.torchMode != AVCaptureTorchModeOff ||
               device.flashMode != AVCaptureFlashModeOff){
                [device lockForConfiguration:nil];
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                [device unlockForConfiguration];
            }
        }
    }
}

- (void)openShake:(BOOL)shaked {
    if (shaked) {
        //开启系统震动
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

- (void)openSystemSound:(BOOL)sounding name:(NSString *)name {
    
//    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",soundName,soundType];
//   [[NSBundle bundleWithIdentifier:@"com.apple.UIKit" ]pathForResource:soundName ofType:soundType];//得到苹果框架资源UIKit.framework ，从中取出所要播放的系统声音的路径
    if (sounding) {
        //设置自定义声音
        NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@",name];
        [self playSound:[NSURL fileURLWithPath:path]];
    }
}

- (void)openCustomSound:(BOOL)sounding name:(NSString *)name {

    if (sounding) {
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:name withExtension:nil];
        [self playSound:fileURL];
    }
}

- (void)playSound:(NSURL *)url {
    if (url) {
        SystemSoundID soundID;
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
        if (error == kAudioServicesNoError){
            AudioServicesPlaySystemSound(soundID);
        }else {
            NSLog(@"Failed to create sound");
        }
    }
}

#pragma mark - 调用相册

- (void)openPhoto:(void(^)(NSString *metaString))block {
    // 不支持打开照片扫描条形码
    // 二维码只能支持8.0+
    if (_canScanBarCode) {
        return;
    }
    
    //1.判断相册是否可以打开
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    }
    if (_takeQRCodeStringFromPhotoBlock) {
        _takeQRCodeStringFromPhotoBlock = ^(NSString *metaString) {
            block(metaString);
        };
    }
    //2.创建图片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    //选中之后大图编辑模式
    ipc.allowsEditing = YES;
    [self presentViewController:ipc animated:YES completion:nil];
}


#pragma mark-  摄像头输出数据的delegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        [self stopQRCodeScan];
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        
        if (obj.stringValue && ![obj.stringValue isEqualToString:@""] && obj.stringValue.length > 0) {
            if (_delegate && [_delegate respondsToSelector:@selector(hadScanedCodeString:)]) {
                [_delegate hadScanedCodeString:obj.stringValue];
            }else {
//            if (_takeQRCodeStringBlock) {
                _takeQRCodeStringBlock(obj.stringValue);
//            }
            }
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate

//相册获取的照片进行处理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // 1.取出选中的图片
    UIImage *pickImage = info[UIImagePickerControllerEditedImage];
    
    NSData *imageData = UIImagePNGRepresentation(pickImage);
    
    CIImage *ciImage = [CIImage imageWithData:imageData];
    
    //2.从选中的图片中读取二维码数据
    //2.1创建一个探测器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                                              context:nil
                                              options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    
    // 2.2利用探测器探测数据
    NSArray *feature = [detector featuresInImage:ciImage];
    
    // 2.3取出探测到的数据
    for (CIQRCodeFeature *result in feature) {
        NSString *urlStr = result.messageString;
        //二维码信息回传
        if (_delegate && [_delegate respondsToSelector:@selector(hadScanedCodeStringFromPhoto:)]) {
            [_delegate hadScanedCodeStringFromPhoto:urlStr];
        }else {
//            if (_takeQRCodeStringFromPhotoBlock) {
            _takeQRCodeStringFromPhotoBlock(urlStr);
//            }
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark-   Setter & Getter

- (QRCodeMaskView *)maskView {
    if (_maskView) {
        return _maskView;
    }
    
    _maskView = [[QRCodeMaskView alloc] initWithFrame:QR_Screen_Bounds];
    [_maskView setScanViewFrame:CGRectMake((QR_Screen_Width - DefaultScanWidth) / 2,
                                           (QR_Screen_Height - DefaultScanWidth) / 2,
                                           DefaultScanWidth,
                                           DefaultScanWidth)];
    return _maskView;
}

- (QRCodeScanLineView *)line {
    if (_line) {
        return _line;
    }
    _line = [[QRCodeScanLineView alloc] initWithFrame:CGRectMake((QR_Screen_Width - DefaultScanWidth) / 2,
                                                                 (QR_Screen_Height - DefaultScanWidth) / 2,
                                                                 DefaultScanWidth,
                                                                 2)
                                           scanHeight:DefaultScanWidth];
    return _line;
}

- (AVCaptureVideoPreviewLayer *)videoPreviewLayer {
    if (_videoPreviewLayer) {
        return _videoPreviewLayer;
    }
    
    //  设置预览图层
    _videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    
    //  设置preview图层的属性
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //设置preview图层的大小
    [_videoPreviewLayer setFrame:QR_Screen_Bounds];
    
    return _videoPreviewLayer;
}

- (AVCaptureSession *)session {
    if (_session) {
        return _session;
    }
    
    _session = [[AVCaptureSession alloc] init];
    
    // 读取质量，质量越高，可读取小尺寸的二维码
    if ([_session canSetSessionPreset:AVCaptureSessionPreset1920x1080]) {
        [_session setSessionPreset:AVCaptureSessionPreset1920x1080];
    }
    else if ([_session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        [_session setSessionPreset:AVCaptureSessionPreset1280x720];
    }
    else {
        [_session setSessionPreset:AVCaptureSessionPresetPhoto];
    }
    
    if (self.input) {
        if ([_session canAddInput:_input]) {
            [_session addInput:_input];
        }
        
        if ([_session canAddOutput:self.output]) {
            [_session addOutput:_output];
        }
        
        //设置输出的格式
        //一定要先设置会话的输出为output之后，再指定输出的元数据类型
        if (_canScanBarCode) {
            _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                            AVMetadataObjectTypeCode128Code,
                                            AVMetadataObjectTypeCode93Code,
                                            AVMetadataObjectTypeCode39Code,
                                            AVMetadataObjectTypeCode39Mod43Code,
                                            AVMetadataObjectTypeEAN8Code,
                                            AVMetadataObjectTypeEAN13Code,
                                            AVMetadataObjectTypeUPCECode,
                                            AVMetadataObjectTypePDF417Code,
                                            AVMetadataObjectTypeAztecCode];
            
        }else{
            [_output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
        }
    }
    
    return _session;
}

- (AVCaptureDeviceInput *)input {
    if (_input) {
        return _input;
    }
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //摄像头判断
    NSError *error = nil;
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (error) {
        NSLog(@"摄像头不可用-%@", error.localizedDescription);
        return nil;
    }
    
    return _input;
}

- (AVCaptureMetadataOutput *)output {
    if (_output) {
        return _output;
    }
    
    //设置输出(Metadata元数据)
    _output = [[AVCaptureMetadataOutput alloc] init];
    
    //设置输出的代理
    //使用主线程队列，相应比较同步，使用其他队列，相应不同步，容易让用户产生不好的体验
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 设置有效区域
    [_output setRectOfInterest:CGRectMake(_scanRect.origin.x / QR_Screen_Height,
                                          _scanRect.origin.y / QR_Screen_Width,
                                          _scanRect.size.width / QR_Screen_Height,
                                          _scanRect.size.height / QR_Screen_Width)];
    return _output;
}

#pragma mark-  utils

- (void)addToController:(UIViewController *)controller {
    [controller.view addSubview:self.view];
    [controller addChildViewController:self];
}

- (void)removeFromController {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
