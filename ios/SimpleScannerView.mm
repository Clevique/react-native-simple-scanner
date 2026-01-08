#import "SimpleScannerView.h"

#import <react/renderer/components/SimpleScannerViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/SimpleScannerViewSpec/EventEmitters.h>
#import <react/renderer/components/SimpleScannerViewSpec/Props.h>
#import <react/renderer/components/SimpleScannerViewSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"
#import <AVFoundation/AVFoundation.h>
#import "SimpleScanner-Swift.h"

using namespace facebook::react;

@interface SimpleScannerView () <RCTSimpleScannerViewViewProtocol>

@end

@implementation SimpleScannerView {
    SimpleScannerViewSwift * _swiftView;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
    return concreteComponentDescriptorProvider<SimpleScannerViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const SimpleScannerViewProps>();
    _props = defaultProps;

    _swiftView = [[SimpleScannerViewSwift alloc] initWithFrame:frame];
    _swiftView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    self.contentView = _swiftView;
  }

  return self;
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
    const auto &oldViewProps = *std::static_pointer_cast<SimpleScannerViewProps const>(_props);
    const auto &newViewProps = *std::static_pointer_cast<SimpleScannerViewProps const>(props);

    // Update barcodeTypes
    if (oldViewProps.barcodeTypes != newViewProps.barcodeTypes) {
        NSMutableArray<NSString *> *barcodeTypes = [NSMutableArray array];
        for (const auto &type : newViewProps.barcodeTypes) {
            [barcodeTypes addObject:[NSString stringWithUTF8String:type.c_str()]];
        }
        _swiftView.barcodeTypes = barcodeTypes;
    }

    // Update flashEnabled
    if (oldViewProps.flashEnabled != newViewProps.flashEnabled) {
        _swiftView.flashEnabled = newViewProps.flashEnabled;
    }

    // Update isScanning
    if (oldViewProps.isScanning != newViewProps.isScanning) {
        _swiftView.isScanning = newViewProps.isScanning;
    }

    // Store event handlers in Swift view
    __weak SimpleScannerView *weakSelf = self;
    _swiftView.onBarcodeScanned = ^(NSDictionary *event) {
        SimpleScannerView *strongSelf = weakSelf;
        if (!strongSelf) return;

        if (strongSelf->_eventEmitter) {
            std::string type = [[event objectForKey:@"type"] UTF8String];
            std::string data = [[event objectForKey:@"data"] UTF8String];

            // Extract bounds if available
            facebook::react::SimpleScannerViewEventEmitter::OnBarcodeScanned payload{
                .type = type,
                .data = data
            };

            NSDictionary *boundsDict = [event objectForKey:@"bounds"];
            if (boundsDict) {
                double x = [[boundsDict objectForKey:@"x"] doubleValue];
                double y = [[boundsDict objectForKey:@"y"] doubleValue];
                double width = [[boundsDict objectForKey:@"width"] doubleValue];
                double height = [[boundsDict objectForKey:@"height"] doubleValue];

                payload.bounds = std::make_optional(facebook::react::SimpleScannerViewEventEmitter::BarcodeBounds{
                    .x = x,
                    .y = y,
                    .width = width,
                    .height = height
                });
            }

            auto emitter = std::static_pointer_cast<SimpleScannerViewEventEmitter const>(strongSelf->_eventEmitter);
            emitter->onBarcodeScanned(payload);
        }
    };

    _swiftView.onScannerError = ^(NSDictionary *event) {
        SimpleScannerView *strongSelf = weakSelf;
        if (!strongSelf) return;

        if (strongSelf->_eventEmitter) {
            std::string message = [[event objectForKey:@"message"] UTF8String];
            auto emitter = std::static_pointer_cast<SimpleScannerViewEventEmitter const>(strongSelf->_eventEmitter);
            emitter->onScannerError(SimpleScannerViewEventEmitter::OnScannerError{
                .message = message
            });
        }
    };

    _swiftView.onCameraStatusChange = ^(NSDictionary *event) {
        SimpleScannerView *strongSelf = weakSelf;
        if (!strongSelf) return;

        if (strongSelf->_eventEmitter) {
            std::string status = [[event objectForKey:@"status"] UTF8String];
            auto emitter = std::static_pointer_cast<SimpleScannerViewEventEmitter const>(strongSelf->_eventEmitter);
            emitter->onCameraStatusChange(SimpleScannerViewEventEmitter::OnCameraStatusChange{
                .status = status
            });
        }
    };

    [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> SimpleScannerViewCls(void)
{
    return SimpleScannerView.class;
}

@end
