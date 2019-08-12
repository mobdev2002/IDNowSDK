/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React from 'react';
import {
  SafeAreaView,
  StyleSheet,
  ScrollView,
  View,
  Text,
  StatusBar,
  NativeModules,
  TouchableOpacity,
  Alert,
  ActivityIndicator,
  NativeEventEmitter,
} from 'react-native';

import {
  Header,
  LearnMoreLinks,
  Colors,
  DebugInstructions,
  ReloadInstructions,
} from 'react-native/Libraries/NewAppScreen';

import IDNowSDKManager from './IDNowSDKManager'

//TODO: Should be updated with real info
const TRANSACTION_TOKEN_VIDEO_IDENT = "DEV-XSXQK"
const COMPANY_ID_VIDEO_IDENT = "ihrebank"
const TRANSACTION_TOKEN_PHOTO_IDENT = "DEV-TAZLS"
const COMPANY_ID_PHOTO_IDENT = "idnow"

//IDNow Listeners
const IDNowResultSUCCESS = "IDNowResultSUCCESS"
const IDNowResultFINISHED = "IDNowResultFINISHED"
const IDNowResultCANCELLED = "IDNowResultCANCELLED"
const IDNowResultERROR = "IDNowResultERROR"

class App extends React.Component {

  state = {
    showActivity: false,
    IDNowListener: null,
  }

  componentDidMount = () => {
    this.setupIDNowListeners()
  }

  componentWillUnmount = () => {
    this.IDNowListener.remove()
  }

  showActivity = (show) => {
    this.setState({showActivity: show})
  }

  setupIDNowListeners = () => {

    this.IDNowListener = new NativeEventEmitter(IDNowSDKManager)

    this.IDNowListener.addListener(IDNowResultSUCCESS, (data) => {
      this.showAlert('ID Now Success')
    })

    this.IDNowListener.addListener(IDNowResultFINISHED, (data) => {
      this.showAlert('ID Now Finished')
    })

    this.IDNowListener.addListener(IDNowResultCANCELLED, (data) => {
      this.showAlert('ID Now Cancelled')
    })

    this.IDNowListener.addListener(IDNowResultERROR, (data) => {
      this.showAlert('ID Now Error')
    })
  }

  showAlert = (alertText) => {
    Alert.alert(
      '',
      alertText,
      [
        {text: 'Cancel', onPress: () => console.log('Cancel Pressed')},
      ],
      {cancelable: true},
    );

    this.showActivity(false)
  }

  startVideoIdentification = () => {

    this.showActivity(true)

    try {
      IDNowSDKManager.startVideoIdentification(COMPANY_ID_VIDEO_IDENT, TRANSACTION_TOKEN_VIDEO_IDENT);
    } catch (e) {
      console.log("Load error", e)
      this.showActivity(false)
    }
  }

  startPhotoIdentification = () => {

    this.showActivity(true)

    try {
      IDNowSDKManager.startPhotoIdentification(COMPANY_ID_VIDEO_IDENT, TRANSACTION_TOKEN_VIDEO_IDENT);
    } catch (e) {
      console.log("Load error", e)
      this.showActivity(false)
    }
  }

  _renderIDNowContainer = () => {

    let {showActivity} = this.state

    return <View style={styles.container}>
      <TouchableOpacity style={styles.button}
        onPress={() => this.startPhotoIdentification()}>
        <Text>Start photo identification</Text>
      </TouchableOpacity>
      <TouchableOpacity style={styles.button}
        onPress={() => this.startVideoIdentification()}>
        <Text>Start video identification</Text>
      </TouchableOpacity>

      {showActivity && <ActivityIndicator style={styles.activity}></ActivityIndicator>}
    </View>
  }

  render() {
    return this._renderIDNowContainer()
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  button: {
    marginVertical: 40,
  }, 
  activity: {
    position: 'absolute', 
    top: 0, 
    right: 0, 
    left: 0, 
    bottom: 0,
  }
});

// export default App;
export default App
