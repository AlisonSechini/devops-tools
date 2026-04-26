import { StatusBar } from 'expo-status-bar';
import { StyleSheet, Text, View, Image, TextInput, TouchableOpacity } from 'react-native';
import {useState} from "react";

export default function App() {
  const [texto, setTexto] = useState("");

  return (
    <View style={styles.container}>
      <Image source={require('./assets/icon.png')} style={styles.image} />
      <Text>Open up App.js to start working on your app!</Text>
      <TextInput onChangeText={setTexto} value={texto}/>
        <Text>Valor: {texto}</Text>
        <TouchableOpacity>
          <Text>Botão</Text>
        </TouchableOpacity>
      <Image source={require('./assets/splash-icon.png')} style={styles.image} />
      <StatusBar style="auto" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#3d3d3d',
    alignItems: 'center',
    justifyContent: 'center',
  },
  image: {
    width: 100,
    height: 100,
    marginBottom: 20,
  },
});
