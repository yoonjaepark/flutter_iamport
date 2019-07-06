/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React from 'react';
import { Platform } from 'react-native';
import { createAppContainer, createStackNavigator } from 'react-navigation';

import Home from 'components/Home';
import Payment from 'components/Payment';
import PaymentTest from 'components/PaymentTest';
import PaymentResult from 'components/PaymentResult';
import Certification from 'components/Certification';
import CertificationTest from 'components/CertificationTest';
import CertificationResult from 'components/CertificationResult';

const headerMode = Platform.OS === 'ios' ? 'float' : 'none';

const AppNavigator = createStackNavigator({
  Home: { screen: Home },
  Payment: { screen: Payment },
  PaymentTest: { screen: PaymentTest },
  PaymentResult: { screen: PaymentResult },
  Certification: { screen: Certification },
  CertificationTest: { screen: CertificationTest },
  CertificationResult: { screen: CertificationResult },
}, {
  headerMode
});

const AppContainer = createAppContainer(AppNavigator);
export default AppContainer;

