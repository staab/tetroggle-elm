// pull in desired CSS/SASS files
require('./styles/main.scss')
var $ = jQuery = require( '../../node_modules/jquery/dist/jquery.js')
require( '../../node_modules/bootstrap-sass/assets/javascripts/bootstrap.js')

window.firebase.initializeApp({
  apiKey: "AIzaSyBTnIOnXsflJT8uq9EHkZKlaarke09Uqjk",
  authDomain: "tetroggle.firebaseapp.com",
  databaseURL: "https://tetroggle.firebaseio.com",
  storageBucket: "tetroggle.appspot.com",
  messagingSenderId: "52280023929"
});

var db = window.firebase.database();
var scores = db.ref('scores');

function objToArray(obj) {
  var result = [];

  for (var key in obj) {
    if (obj.hasOwnProperty(key)) {
      result.push(obj[key]);
    }
  }

  return result;
}

function addScore(elapsed, name, score) {
  return scores.push({
    elapsed: elapsed,
    name: name,
    score: score
  });
}

function getScores() {
  return scores
    .orderByChild('score')
    .limitToLast(50)
    .once('value')
    .then(function (snapshot) {
      var data = objToArray(snapshot.val());

      return data;
    });
}

window.addScore = addScore
window.getScores = getScores

// inject bundled Elm app into div#main
var Elm = require( '../elm/Main' );
Elm.Main.embed(document.getElementById('main'), {
  seed: Math.floor(Math.random()*0xFFFFFFFF),
  dictionary: require('raw!./dictionary.txt'),
  startTime: (new Date()).getTime(),
})
