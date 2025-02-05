//Firebase
const userCollection = 'Users';
const callsCollection = 'Calls';
const tokensCollection = 'Tokens';

const fcmKey = 'AAAA8hfeYZKXDOOmZ6OR8Cd70oZdKsD2Ao44YfuXBFgocNOH5gp2';
//Routes
const loginScreen = '/';
const homeScreen = '/homeScreen';
const callScreen = '/callScreen';
const testScreen = '/testScreen';

//Agora
const agoraAppId = '2e7fdb8a709c4a8ca54b346fa0aa050a';
const agoraTestChannelName = 'funky';
const agoraTestToken =
    '007eJxTYLjc+tS9YZHL+aOfnshL/BKd9Cizz1bsV15HqPyEOCmePcoKDEap5mkpSRaJ5gaWySaJFsmJpiZJxiZmaYkGiYkGpgaJ09bvTGsIZGT4dcKdhZEBAkF8Voa00rzsSgYGAMuUIXk=';
const agoraChatTestToken =
    '007eJxTYFi1e8rD2Yv38oRPXftnDUvtvfTqU37L3r26vHOq6aSH1m2bFRiMUs3TUpIsEs0NLJNNEi2SE01NkoxNzNISDRITDUwNEj9qbE5rCGRkcDsjysTIwMrAyMDEAOIzMAAAv78hvQ==';
//EndPoints -- this is for generating call token programmatically for each call
const cloudFunctionBaseUrl =
    'https://8019-2409-40c4-3009-db94-6815-cf5-df4d-98fa.ngrok-free.app/';
const fireCallEndpoint = 'access_token';

const int callDurationInSec = 45;

//Call Status
enum CallStatus {
  none,
  ringing,
  accept,
  reject,
  unAnswer,
  cancel,
  end,
}
