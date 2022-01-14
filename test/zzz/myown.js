myown = function(e) {
  console.log('Worker: Message received from main script');
  console.log(e);
  var workerResult = 'background task';
  postMessage(workerResult);
}
