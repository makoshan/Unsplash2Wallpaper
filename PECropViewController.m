//
//  PECropViewController.m
//  PhotoCropEditor
//
//  Created by kishikawa katsumi on 2013/05/19.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "PECropViewController.h"
#import "PECropView.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width


@interface PECropViewController () <UIActionSheetDelegate>

@property (nonatomic) PECropView *cropView;
@property (nonatomic) UIAlertController * alertController;
- (void)commonInit;

@end

@implementation PECropViewController
@synthesize rotationEnabled = _rotationEnabled;
UIImageView *imageView;
bool flag=false;

+ (NSBundle *)bundle
{
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"PEPhotoCropEditor" withExtension:@"bundle"];
        bundle = [[NSBundle alloc] initWithURL:bundleURL];
    });
    
    return bundle;
}



- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    self.rotationEnabled = YES;
}

#pragma mark -

- (void)loadView
{
    UIView *contentView = [[UIView alloc] init];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    contentView.backgroundColor = [UIColor blackColor];
    self.view = contentView;
    
    self.cropView = [[PECropView alloc] initWithFrame:contentView.bounds];
    [contentView addSubview:self.cropView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    self.navigationController.toolbar.translucent = NO;
    //todo
    [self setShowMajor:NO];
    if (!self.toolbarItems) {
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                       target:nil
                                                                                       action:nil];
        UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnDone setTitle:@"保存" forState:UIControlStateNormal];
        [btnDone setTitleColor:[UIColor blueColor]forState:UIControlStateNormal];
        btnDone.tag=200;
        [btnDone addTarget:self action:@selector(done:)forControlEvents:UIControlEventTouchUpInside];
        btnDone.frame = CGRectMake(0, 0, 44, 44);
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnDone];
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        btnCancel.tag=100;
        [btnCancel setTitleColor:[UIColor blueColor]forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(cancel:)forControlEvents:UIControlEventTouchUpInside];
        btnCancel.frame = CGRectMake(0, 0, 44, 44);
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnCancel];
        UIButton *btnConstrain = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnConstrain setTitle:@"尺寸" forState:UIControlStateNormal];
        [btnConstrain setTitleColor:[UIColor blueColor]forState:UIControlStateNormal];
        [btnConstrain addTarget:self action:@selector(constrain:)forControlEvents:UIControlEventTouchUpInside];
        btnConstrain.frame = CGRectMake(0, 0, 44, 44);
        UIBarButtonItem *constrainButton = [[UIBarButtonItem alloc] initWithCustomView:btnConstrain];
        UIButton *btnLook = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnLook setTitle:@"预览" forState:UIControlStateNormal];
        [btnLook setTitleColor:[UIColor blueColor]forState:UIControlStateNormal];
        [btnLook addTarget:self action:@selector(show:)forControlEvents:UIControlEventTouchUpInside];
        btnLook.frame = CGRectMake(0, 0, 44, 44);
        UIBarButtonItem *lookButton = [[UIBarButtonItem alloc] initWithCustomView:btnLook];
        self.toolbarItems = @[leftBarButtonItem,flexibleSpace, constrainButton,flexibleSpace, rightBarButtonItem,flexibleSpace,lookButton];
    }
    self.navigationController.toolbarHidden = self.toolbarHidden;
    
    self.cropView.image = self.image;
    
    
    
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth-10, kScreenHeight-10)];
    [self.view addSubview:imageView];
    imageView.hidden=YES;
    //添加拖动手势
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    panRecognizer.delegate = self;
    [self.view addGestureRecognizer:panRecognizer];
}
- (void)show:(id)sender
{
    if (flag){
        [self setShowMajor:NO];
        flag=false;
    }else{
        [self setShowMajor:YES];
        flag=true;
    }
    
}



- (void)setShowMajor:(BOOL)showsGridMajor
{
    
    self.cropView.showsGridMajor=showsGridMajor;
    
    
    
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.cropAspectRatio != 0) {
        self.cropAspectRatio = self.cropAspectRatio;
    }
    if (!CGRectEqualToRect(self.cropRect, CGRectZero)) {
        self.cropRect = self.cropRect;
    }
    if (!CGRectEqualToRect(self.imageCropRect, CGRectZero)) {
        self.imageCropRect = self.imageCropRect;
    }
    
    self.keepingCropAspectRatio = self.keepingCropAspectRatio;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark -

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.cropView.image = image;
}

- (void)setKeepingCropAspectRatio:(BOOL)keepingCropAspectRatio
{
    _keepingCropAspectRatio = keepingCropAspectRatio;
    self.cropView.keepingCropAspectRatio = self.keepingCropAspectRatio;
}

- (void)setCropAspectRatio:(CGFloat)cropAspectRatio
{
    _cropAspectRatio = cropAspectRatio;
    self.cropView.cropAspectRatio = self.cropAspectRatio;
}

- (void)setCropRect:(CGRect)cropRect
{
    _cropRect = cropRect;
    _imageCropRect = CGRectZero;
    
    CGRect cropViewCropRect = self.cropView.cropRect;
    cropViewCropRect.origin.x += cropRect.origin.x;
    cropViewCropRect.origin.y += cropRect.origin.y;
    
    CGSize size = CGSizeMake(fminf(CGRectGetMaxX(cropViewCropRect) - CGRectGetMinX(cropViewCropRect), CGRectGetWidth(cropRect)),
                             fminf(CGRectGetMaxY(cropViewCropRect) - CGRectGetMinY(cropViewCropRect), CGRectGetHeight(cropRect)));
    cropViewCropRect.size = size;
    self.cropView.cropRect = cropViewCropRect;
}

- (void)setImageCropRect:(CGRect)imageCropRect
{
    _imageCropRect = imageCropRect;
    _cropRect = CGRectZero;
    
    self.cropView.imageCropRect = imageCropRect;
}

- (BOOL)isRotationEnabled
{
    return _rotationEnabled;
}

- (void)setRotationEnabled:(BOOL)rotationEnabled
{
    _rotationEnabled = rotationEnabled;
    self.cropView.rotationGestureRecognizer.enabled = _rotationEnabled;
}

- (CGAffineTransform)rotationTransform
{
    return self.cropView.rotation;
}

- (CGRect)zoomedCropRect
{
    return self.cropView.zoomedCropRect;
}


- (void)resetCropRect
{
    [self.cropView resetCropRect];
}

- (void)resetCropRectAnimated:(BOOL)animated
{
    [self.cropView resetCropRectAnimated:animated];
}

#pragma mark - Gesture Handler

- (void)panGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint velocity = [gestureRecognizer velocityInView:self.view];
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (velocity.y > 0) {
            if ([self.delegate respondsToSelector:@selector(cropViewControllerDidCancel:)]) {
                [self.delegate cropViewControllerDidCancel:self];
            }
        }
        
        return;
    }
    
    
    
}


#pragma mark -

- (void)cancel:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(cropViewControllerDidCancel:)]) {
        [self.delegate cropViewControllerDidCancel:self];
    }
}

- (void)done:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(cropViewController:didFinishCroppingImage:transform:cropRect:)]) {
        [self.delegate cropViewController:self didFinishCroppingImage:self.cropView.croppedImage transform: self.cropView.rotation cropRect: self.cropView.zoomedCropRect ];
    } else if ([self.delegate respondsToSelector:@selector(cropViewController:didFinishCroppingImage:)]) {
        UIButton *btns = (UIButton *)sender;
        [self.delegate cropViewController:self didFinishCroppingImage:self.cropView.croppedImage btn:btns];
    }
}

- (void)constrain:(id)sender
{
    self.alertController=[UIAlertController alertControllerWithTitle: nil                                                                             message: nil                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    //添加Button
    [self.alertController addAction: [UIAlertAction actionWithTitle: @"640 x 1136" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.cropView.cropAspectRatio = 640.0f / 1136.0f;
        
    }]];
    [self.alertController addAction: [UIAlertAction actionWithTitle:  @"750 × 1334" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        self.cropView.cropAspectRatio = 750.0f / 1334.0f;
    }]];
    [self.alertController addAction: [UIAlertAction actionWithTitle:    @"1242 × 2208" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        self.cropView.cropAspectRatio = 1242.0f / 2208.0f;
    }]];
    [self.alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController: self.alertController animated: YES completion: nil];
}



@end
