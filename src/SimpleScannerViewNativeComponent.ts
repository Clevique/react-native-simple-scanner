import { codegenNativeComponent, type ViewProps } from 'react-native';
import type { DirectEventHandler } from 'react-native/Libraries/Types/CodegenTypes';

export interface BarcodeScannedEvent {
  type: string;
  data: string;
  bounds?: {
    x: number;
    y: number;
    width: number;
    height: number;
  };
}

export interface ScannerErrorEvent {
  message: string;
  code?: string;
}

export interface CameraStatusChangeEvent {
  status: string;
}

interface NativeProps extends ViewProps {
  barcodeTypes?: ReadonlyArray<string>;
  flashEnabled?: boolean;
  isScanning?: boolean;
  onBarcodeScanned?: DirectEventHandler<BarcodeScannedEvent>;
  onScannerError?: DirectEventHandler<ScannerErrorEvent>;
  onCameraStatusChange?: DirectEventHandler<CameraStatusChangeEvent>;
}

export default codegenNativeComponent<NativeProps>('SimpleScannerView');
