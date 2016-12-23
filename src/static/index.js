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

function addScore(score) {
  return scores.push(score);
}

function getScores() {
  return scores
    .limitToLast(10)
    .orderByChild('score')
    .once('value')
    .then(function (snapshot) {
      var data = []

      snapshot.forEach(function (score) {
        data.push(score.val());
      });

      return data.reverse();
    });
}

window.addScore = addScore
window.getScores = getScores

// inject bundled Elm app into div#main
var Elm = require( '../elm/Main' );

var app = Elm.Main.fullscreen({
  seed: Math.floor(Math.random()*0xFFFFFFFF),
  dictionary: require('raw!./dictionary.txt'),
  startTime: (new Date()).getTime(),
})

app.ports.addScore.subscribe(function (score) {
  addScore(score)
    .then(getScores)
    .then(function (scores) {
      app.ports.scores.send(scores);
    })
})
