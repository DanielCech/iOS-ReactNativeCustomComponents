/**
 * @flow
 */

import React, { Component } from 'react';
import {
  Button,
  NativeModules,
  NativeEventEmitter,
  StyleSheet,
  Text,
  TextInput,
  View
} from 'react-native';

import EmitterSubscription from 'EmitterSubscription';

import SignatureView from './components/SignatureView';

type StateType = {
  textField: string;
  swiftCounterValue: number;
  swiftButtonCurrentlyEnabled: boolean;
};

export default class ReactNativeTab extends Component {
  state: StateType;

  constructor(props: Object) {
    super(props);
    this.state = {
      textField: 'Enter text to send to Swift',
      swiftCounterValue: 0,
      swiftButtonCurrentlyEnabled: true,
     };
  }

  counterChangedEventEmitter: ?NativeEventEmitter = null;
  counterChangedEventSubscriber: EmitterSubscription = null;

  componentWillMount(): void {
    this.setupSwiftCounterChangedEventListener();
  }

  componentWillUnmount(): void {
    this.counterChangedEventSubscriber.remove();
  }

  // Type 1: Calling a Swift function from JavaScript
  scanBarcode() {
    NativeModules.NativeModuleJavaScriptCallback.scanBarcode(function(err, code) {
      console.log("callback!!!")
      console.log(err)
      console.log(code)
    });
  }

  takePatientPhoto() {
    NativeModules.NativeModuleJavaScriptCallback.takePatientPhoto(function(err, patientURL) {
      console.log("callback!!!")
      console.log(err)
      console.log(patientURL)
    });
  }

  scanIDCard() {
    NativeModules.NativeModuleJavaScriptCallback.scanIDCard(function(err, response) {
      console.log("scan id card callback!!!")
      console.log(err)
      console.log("idCardURL: " + response["idCard"] + ", idCardFaceURL: " + response["idFace"])
    });
  }

  scanDoctorReferenceLetter() {
    NativeModules.NativeModuleJavaScriptCallback.scanDoctorReferenceLetter(function(err, letterURL) {
      console.log("callback!!!")
      console.log(err)
      console.log(letterURL)
    });
  }

  // Type 2: Calling a Swift function with a callback
  toggleSwiftButtonEnabledState() {
    NativeModules.NativeModuleJavaScriptCallback.toggleSwiftButtonEnabled(
        (newStateDict) => {
          this.setState({ swiftButtonCurrentlyEnabled: newStateDict.swiftButtonEnabled });
        }
      );
  }

  // Type 3: Broadcasting data from Swift and listening in JavaScript
  setupSwiftCounterChangedEventListener() {
    this.counterChangedEventEmitter = new NativeEventEmitter(NativeModules.NativeModuleBroadcastToJavaScript);
    this.counterChangedEventSubscriber = this.counterChangedEventEmitter.addListener(
      "SwiftCounterChanged",
      (countEventInfo) => {
        this.setState({ swiftCounterValue: countEventInfo.count });
      }
    );
  }

  clearSignatureButtonClick = () => {
    //console.log(this.signature);
    this.signature.clearSign(this.signature)
  };

  render() {
    return (
      <View style={styles.container}>
        <View style={styles.mainContent}>
          <Text style={styles.welcome}>
            ReactNative Controller!
          </Text>
          <Text style={styles.instructions}>
            Press Cmd+R to reload,{'\n'}
            Cmd+D or shake for dev menu
          </Text>
          <Button
            onPress={ () => this.scanBarcode() }
            title="Scan Barcode"
            color="#007aff"
          />
          <Button
            onPress={ () => this.takePatientPhoto() }
            title="Take Patient Photo"
            color="#007aff"
          />
          <Button
            onPress={ () => this.scanIDCard() }
            title="Scan ID Card"
            color="#007aff"
          />
          <Button
            onPress={ () => this.scanDoctorReferenceLetter() }
            title="Scan Reference Letter"
            color="#007aff"
          />
          <SignatureView style={{height: 70, backgroundColor: 'powderblue'}}
            ref={(component) => {
              this.signature = component;
            }}
          />
          <Button
            title="Clear Signature"
            onPress={this.clearSignatureButtonClick}
          />
        </View>
        <View style={styles.tabContentBottomSpacer}/>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  mainContent: {
    flex: 1,
    justifyContent: 'center',
    backgroundColor: '#F5FCFF',
  },
  tabContentBottomSpacer: {
    height: 49, //the height of the tab bar. Note the tab bar is translucent and this color will shine through
    backgroundColor: '#FFFFFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 30,
  },
});
