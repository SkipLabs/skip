let socket = new WebSocket("ws://127.0.0.1:3048");

socket.onopen = function(e) {
  alert("[open] Connection established");
  alert("Sending to server");
  var enc = new TextEncoder(); // always utf-8
  socket.send(enc.encode("echo foo\n"));
};

socket.onmessage = function(event) {
  const blb = event.data;
  
  const reader = new FileReader();

  // This fires after the blob has been read/loaded.
  reader.addEventListener("load", () => {
    // this will then display a text file
    console.log(reader.result);
  }, false);

  reader.readAsText(blb);
//  var fr = new FileReader();
//  fr.onload = function (e) {
//    console.log(new Uint8Array(e.target.result)[0]);
//  };
//  fr.readAsArrayBuffer(subBlob);
//  var string_arr =JSON.parse(event['data']).data;

};

socket.onclose = function(event) {
  if (event.wasClean) {
    alert(`[close] Connection closed cleanly, code=${event.code} reason=${event.reason}`);
  } else {
    // e.g. server process killed or network down
    // event.code is usually 1006 in this case
    alert('[close] Connection died');
  }
};

socket.onerror = function(error) {
  alert(`[error] ${error.message}`);
};
