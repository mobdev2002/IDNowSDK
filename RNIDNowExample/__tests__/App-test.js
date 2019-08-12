/**
 * @format
 */

import 'react-native';
import React from 'react';
import App from '../App';

// Note: test renderer must be required after react-native.
import renderer from 'react-test-renderer';

describe('App', () => {
  beforeEach(() => {
    NativeModules.IDNowSDKManager = { test: jest.fn() } 
  });
});

it('renders correctly', () => {
  renderer.create(<App />);
});
