import type { BarcodeResult, ScannerError } from '../types';

export const mockBarcodeScannerView = jest.fn(() => null);

export const mockCheckCameraPermission = jest
  .fn()
  .mockResolvedValue('granted' as const);

export const mockRequestCameraPermission = jest.fn().mockResolvedValue(true);

/**
 * Helper to simulate barcode scan in tests
 */
export const simulateScan = (result: BarcodeResult) => {
  const lastCall = mockBarcodeScannerView.mock.calls.slice(-1)[0];
  if (lastCall && lastCall[0]?.onBarcodeScanned) {
    lastCall[0].onBarcodeScanned(result);
  }
};

/**
 * Helper to simulate error in tests
 */
export const simulateError = (error: ScannerError) => {
  const lastCall = mockBarcodeScannerView.mock.calls.slice(-1)[0];
  if (lastCall && lastCall[0]?.onError) {
    lastCall[0].onError(error);
  }
};

/**
 * Helper to simulate camera status change in tests
 */
export const simulateCameraStatusChange = (status: string) => {
  const lastCall = mockBarcodeScannerView.mock.calls.slice(-1)[0];
  if (lastCall && lastCall[0]?.onCameraStatusChange) {
    lastCall[0].onCameraStatusChange(status);
  }
};

/**
 * Setup Jest mocks for react-native-simple-scanner
 */
export const setupMocks = () => {
  jest.mock('react-native-simple-scanner', () => ({
    BarcodeScannerView: mockBarcodeScannerView,
    checkCameraPermission: mockCheckCameraPermission,
    requestCameraPermission: mockRequestCameraPermission,
    ScannerErrorCode: {
      CAMERA_UNAVAILABLE: 'CAMERA_UNAVAILABLE',
      PERMISSION_DENIED: 'PERMISSION_DENIED',
      CONFIGURATION_FAILED: 'CONFIGURATION_FAILED',
      UNKNOWN: 'UNKNOWN',
    },
  }));
};

/**
 * Reset all mocks to their initial state
 */
export const resetMocks = () => {
  mockBarcodeScannerView.mockClear();
  mockCheckCameraPermission.mockClear();
  mockRequestCameraPermission.mockClear();
};
