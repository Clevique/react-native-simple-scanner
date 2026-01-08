import { NativeModules } from 'react-native';
import type { PermissionStatus } from './types';

const { PermissionModule } = NativeModules;

if (!PermissionModule) {
  throw new Error(
    'PermissionModule is not available. Make sure react-native-simple-scanner is properly linked.'
  );
}

/**
 * Check current camera permission status without prompting the user
 * @returns Promise resolving to the current permission status
 */
export function checkCameraPermission(): Promise<PermissionStatus> {
  return PermissionModule.checkCameraPermission();
}

/**
 * Request camera permission from the user
 * @returns Promise resolving to true if permission was granted, false otherwise
 */
export function requestCameraPermission(): Promise<boolean> {
  return PermissionModule.requestCameraPermission();
}
