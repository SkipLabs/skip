import { MuxedSocket } from "../../../../build/skdb_node.js";
import crypto from 'node:crypto';
import assert from 'node:assert';

function request_close() {
  const buf = new ArrayBuffer(4);
  const dv = new DataView(buf);
  dv.setUint32(0, 0x0);
  return buf;
}

function request_error() {
  const buf = new ArrayBuffer(4);
  const dv = new DataView(buf);
  dv.setUint32(0, 0x4);
  return buf;
}

function request_echo(n) {
  const buf = new ArrayBuffer(8);
  const dv = new DataView(buf);
  dv.setUint32(0, 0x1);
  dv.setUint32(4, n);
  return buf;
}

function request_stream() {
  const buf = new ArrayBuffer(8);
  const dv = new DataView(buf);
  dv.setUint32(0, 3);
  return buf;
}

function toHex(buf) {
  return '0x' + [...new Uint8Array(buf)].map(x => x.toString(16).padStart(2, '0')).join('');
}

function logStreamActivity(stream) {
  stream.onClose = () => console.log(`${stream.streamId} closed`);
  stream.onError = (_err) => console.log(`${stream.streamId} errored`);
  stream.onData = (data) => console.log(`${stream.streamId} received data: ${toHex(data)}`);
}

async function connectAndAuth() {
  const enc = new TextEncoder();
  const key = await crypto.subtle.importKey(
    "raw", enc.encode("test"), { name: "HMAC", hash: "SHA-256"}, false, ["sign"]);

  const socket = await MuxedSocket.connect("ws://localhost:8080", {
    accessKey: "ABCDEFGHIJKLMNOPQRST",
    privateKey: key,
    deviceUuid: "abcde",
  });
  return socket;
}

////////////////////////////////////////////////////////////////////////////////
// tests
////////////////////////////////////////////////////////////////////////////////

const tests = {
  happyPathClientOpensClientCloses: async () => {
    const socket = await connectAndAuth();
    const stream = socket.openStream();

    let receivedData = false;
    stream.onData = (data) => {
      receivedData = true;
      assert.equal(toHex(data), "0x00000000");
    };

    stream.send(request_echo(0));
    stream.close();

    socket.onClose = () => assert(receivedData);
    socket.closeSocket();
  },

  happyPathClientOpensServerCloses: async () => {
    const socket = await connectAndAuth();
    const stream = socket.openStream();

    let receivedData = false;
    stream.onData = (data) => {
      receivedData = true;
      assert.equal(toHex(data), "0x00000000");
    };

    let receivedClose = false;
    stream.onClose = () => {
      assert(receivedData);
      receivedClose = true;
    };

    stream.send(request_echo(0));
    stream.send(request_close());

    socket.onClose = () => {
      assert(receivedData);
      assert(receivedClose);
    };
    socket.closeSocket();
  },

  happyPathServerOpensClientCloses: async () => {
    const socket = await connectAndAuth();
    const stream = socket.openStream();

    stream.send(request_stream());
    stream.close();

    let received = [];
    let receivedClose = false;

    socket.onStream = (stream) => {
      stream.onData = (data) => {
        received.push(data);
      };

      stream.onClose = () => {
        receivedClose = true;
        assert(received.length, 2);
      };

      stream.send(request_echo(2));
      stream.close();
      socket.closeSocket();
    };

    socket.onClose = () => {
      assert.equal(received.length, 2);
      assert.equal(toHex(received[0]), "0xabcdef12");
      assert.equal(toHex(received[1]), "0x00000002");
      assert(receivedClose);
    };
  },

  happyPathServerOpensServerCloses: async () => {
    const socket = await connectAndAuth();
    const stream = socket.openStream();

    stream.send(request_stream());
    stream.close();

    let received = [];
    let receivedClose = false;

    socket.onStream = (stream) => {
      stream.onData = (data) => {
        received.push(data);
      };

      stream.onClose = () => {
        receivedClose = true;
        assert(received.length, 2);
      };

      stream.send(request_echo(2));
      stream.send(request_close());
      socket.closeSocket();
    };

    socket.onClose = () => {
      assert.equal(received.length, 2);
      assert.equal(toHex(received[0]), "0xabcdef12");
      assert.equal(toHex(received[1]), "0x00000002");
      assert(receivedClose);
    };
  },

  concurrentStreamsInitiatedFromTheClient: async () => {
    const socket = await connectAndAuth();

    let receivedData = [];
    const onData = (data) => {
      receivedData.push(data);
    };

    const stream1 = socket.openStream();
    stream1.onData = onData;
    stream1.send(request_echo(0));

    const stream2 = socket.openStream();
    stream1.onData = onData;
    stream1.send(request_echo(1));

    stream1.close();
    stream2.close();

    socket.onClose = () => assert.deepEqual(receivedData.map(toHex), ["0x00000000", "0x00000001"]);
    socket.closeSocket();
  },

  concurrentStreamsInitiatedFromBothEnds: async () => {
    const socket = await connectAndAuth();

    let received = [];

    const stream1 = socket.openStream();
    stream1.onData = (data) => {
      received.push(data);
    };
    stream1.send(request_echo(1));
    stream1.send(request_stream());

    const stream2 = socket.openStream();
    stream2.onData = (data) => {
      received.push(data);
    };
    stream2.send(request_echo(2));
    stream2.send(request_echo(3));
    stream2.send(request_echo(4));

    socket.onStream = (server_stream) => {
      server_stream.onData = (data) => {
        received.push(data);
      };

      server_stream.send(request_echo(5));
      server_stream.send(request_echo(6));
      server_stream.send(request_echo(7));

      server_stream.close();
      socket.closeSocket();
    };

    stream1.close();
    stream2.close();

    // worth noting that the output is deterministic due to the JS
    // concurrency model

    socket.onClose = () => {
      assert.equal(received.length, 8);
      assert.deepEqual(received.map(toHex), [
        "0x00000001",
        "0xabcdef12",
        "0x00000002",
        "0x00000003",
        "0x00000004",
        "0x00000005",
        "0x00000006",
        "0x00000007",
      ]);
    };
  },

  clientErrorsStream: async () => {
    const socket = await connectAndAuth();
    const stream = socket.openStream();

    let receivedData = false;
    stream.onData = (data) => {
      receivedData = true;
    };

    stream.send(request_echo(0));
    stream.error(11, "client_error!");

    socket.onClose = () => assert(!receivedData);
    socket.closeSocket();
  },

  serverErrorsStream: async () => {
    const socket = await connectAndAuth();
    const stream = socket.openStream();

    let receivedError = false;

    stream.onData = (data) => {
      assert(false);
    };

    stream.onClose = () => {
      assert(false);
    };

    stream.onError = (code, msg) => {
      receivedError = true;
      assert.equal(code, 5);
    };

    stream.send(request_error());
    // this will happen before we have a chance to read the error
    // message, but should be ignored by the server
    stream.send(request_echo(0));

    socket.onClose = () => assert(receivedError);
    socket.closeSocket();
  }
};


for (const test in tests) {
  console.log('Running', test);
  await tests[test]();
}
