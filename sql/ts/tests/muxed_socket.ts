import { expect } from "@playwright/test";

////////////////////////////////////////////////////////////////////////////////
// tests
////////////////////////////////////////////////////////////////////////////////

export const ms_tests = () => {
  return [
    {
      name: "Happy Path Client Opens Client Closes",
      fun: async (env, mu) => {
        const socket = await mu.connectAndAuth(env);
        const stream = await socket.openStream();
        let promise = new Promise(function (resolve, reject) {
          let result = "";
          stream.onData = (data) => {
            result = mu.toHex(data);
          };
          stream.send(mu.request_echo(0));
          stream.close();

          socket.onClose = () => resolve(result);
          setTimeout(() => socket.closeSocket(), 2000);
        });
        return await promise;
      },
      check: (res) => expect(res).toEqual("0x00000000"),
    },
    {
      name: "Happy Path Client Opens Server Closes",
      fun: async (env, mu) => {
        const socket = await mu.connectAndAuth(env);
        const stream = await socket.openStream();
        let promise = new Promise(function (resolve, reject) {
          let data = "";
          stream.onData = (d) => {
            data = mu.toHex(d);
          };
          let result = "";
          stream.onClose = () => (result = data);

          stream.send(mu.request_echo(0));
          stream.send(mu.request_close());

          socket.onClose = () => resolve(result);
          setTimeout(() => socket.closeSocket(), 2000);
        });
        return await promise;
      },
      check: (res) => {
        expect(res).toEqual("0x00000000");
      },
    },
    {
      name: "Happy Path Server Opens Client Closes",
      fun: async (env, mu) => {
        const socket = await mu.connectAndAuth(env);
        const stream = await socket.openStream();
        stream.send(mu.request_stream());
        stream.close();
        let promise = new Promise(function (resolve, reject) {
          let received: Array<ArrayBuffer> = [];
          let size = 0;
          socket.onStream = (stream) => {
            stream.onData = (data: ArrayBuffer) => {
              received.push(data);
            };

            stream.onClose = () => (size = received.length);

            stream.send(mu.request_echo(2));
            stream.close();
            setTimeout(() => socket.closeSocket(), 2000);
          };
          socket.onClose = () => resolve([size, received.map(mu.toHex)]);
        });
        return JSON.stringify(await promise);
      },
      check: (res) => {
        expect(res).toEqual(JSON.stringify([2, ["0xabcdef12", "0x00000002"]]));
      },
    },
    {
      name: "Happy Path Server Opens Server Closes",
      fun: async (env, mu) => {
        const socket = await mu.connectAndAuth(env);
        let promise = new Promise(function (resolve, reject) {
          let received: Array<ArrayBuffer> = [];
          let size = 0;
          socket.onStream = (stream) => {
            stream.onData = (data: ArrayBuffer) => {
              received.push(data);
            };

            stream.onClose = () => (size = received.length);

            stream.send(mu.request_echo(2));
            stream.send(mu.request_close());
            setTimeout(() => socket.closeSocket(), 2000);
          };
          socket.onClose = () => resolve([size, received.map(mu.toHex)]);
        });
        const stream = await socket.openStream();
        stream.send(mu.request_stream());
        stream.close();
        return JSON.stringify(await promise);
      },
      check: (res) => {
        expect(res).toEqual(JSON.stringify([2, ["0xabcdef12", "0x00000002"]]));
      },
    },
    {
      name: "Concurrent Streams Initiated From The Client",
      fun: async (env, mu) => {
        const socket = await mu.connectAndAuth(env);
        let promise = new Promise(function (resolve, reject) {
          socket.onClose = () => resolve(receivedData.map(mu.toHex));
        });
        let receivedData: Array<ArrayBuffer> = [];
        const onData = (data: ArrayBuffer) => {
          receivedData.push(data);
        };
        const stream1 = await socket.openStream();
        stream1.onData = onData;
        stream1.send(mu.request_echo(0));

        const stream2 = await socket.openStream();
        stream1.onData = onData;
        stream1.send(mu.request_echo(1));

        stream1.close();
        stream2.close();

        setTimeout(() => socket.closeSocket(), 2000);
        return JSON.stringify(await promise);
      },
      check: (res) => {
        expect(res).toEqual(JSON.stringify(["0x00000000", "0x00000001"]));
      },
    },
    {
      name: "Concurrent Streams Initiated From Both Ends",
      fun: async (env, mu) => {
        const socket = await mu.connectAndAuth(env);

        let received: Array<ArrayBuffer> = [];
        let promise = new Promise(function (resolve, reject) {
          // worth noting that the output is deterministic due to the JS
          // concurrency model
          socket.onClose = () => resolve(received.map(mu.toHex));
        });

        const stream1 = await socket.openStream();
        stream1.onData = (data: ArrayBuffer) => {
          received.push(data);
        };
        stream1.send(mu.request_echo(1));
        stream1.send(mu.request_stream());

        const stream2 = await socket.openStream();
        stream2.onData = (data: ArrayBuffer) => {
          received.push(data);
        };
        stream2.send(mu.request_echo(2));
        stream2.send(mu.request_echo(3));
        stream2.send(mu.request_echo(4));

        socket.onStream = (server_stream) => {
          server_stream.onData = (data) => {
            received.push(data);
          };

          server_stream.send(mu.request_echo(5));
          server_stream.send(mu.request_echo(6));
          server_stream.send(mu.request_echo(7));

          server_stream.close();
          setTimeout(() => socket.closeSocket(), 2000);
        };
        stream1.close();
        stream2.close();
        return JSON.stringify(await promise);
      },
      check: (res) => {
        expect(res).toEqual(
          JSON.stringify([
            "0x00000001",
            "0xabcdef12",
            "0x00000002",
            "0x00000003",
            "0x00000004",
            "0x00000005",
            "0x00000006",
            "0x00000007",
          ]),
        );
      },
    },
    {
      name: "Client Errors Stream",
      fun: async (env, mu) => {
        const socket = await mu.connectAndAuth(env);
        const stream = await socket.openStream();
        let promise = new Promise(function (resolve, reject) {
          let receivedData = false;
          stream.onData = (data) => {
            receivedData = true;
          };

          stream.send(mu.request_echo(0));
          stream.error(11, "client_error!");

          socket.onClose = () => resolve(receivedData);
          setTimeout(() => socket.closeSocket(), 2000);
        });
        return JSON.stringify(await promise);
      },
      check: (res) => {
        expect(res).toEqual("false");
      },
    },
    {
      name: "Server Errors Stream",
      fun: async (env, mu) => {
        const socket = await mu.connectAndAuth(env);
        const stream = await socket.openStream();
        let promise = new Promise(function (resolve, reject) {
          let receivedData = false;
          let receivedClose = false;
          stream.onData = (data) => {
            receivedData = false;
          };

          stream.onClose = () => {
            receivedClose = false;
          };

          let receivedCode = 0;

          stream.onError = (code, msg) => {
            receivedCode = code;
          };

          stream.send(mu.request_error());
          // this will happen before we have a chance to read the error
          // message, but should be ignored by the server
          stream.send(mu.request_echo(0));

          socket.onClose = () =>
            resolve([receivedData, receivedClose, receivedCode]);
          setTimeout(() => socket.closeSocket(), 2000);
        });
        return JSON.stringify(await promise);
      },
      check: (res) => {
        expect(res).toEqual(JSON.stringify([false, false, 5]));
      },
    },
    {
      name: "Auth Short AccessKey",
      fun: async (env, mu) => {
        const key = await env
          .crypto()
          .subtle.importKey(
            "raw",
            env.encodeUTF8("very_secure"),
            { name: "HMAC", hash: "SHA-256" },
            false,
            ["sign"],
          );
        const socket = await mu.connect(env, "ws://localhost:8090", {
          accessKey: "root",
          privateKey: key,
          deviceUuid: "f6a0a084-d21f-487d-813a-971c183309a3",
        });
        let receivedError = false;
        let receivedData = "";
        let promise = new Promise(function (resolve, reject) {
          socket.onClose = () => resolve([receivedError, receivedData]);
          setTimeout(() => socket.closeSocket(), 2000);
        });
        const stream = await socket.openStream();
        stream.onData = (data) => (receivedData = mu.toHex(data));
        socket.onError = (code, msg) => {
          receivedError = true;
        };
        stream.send(mu.request_echo(0));
        stream.close();
        return JSON.stringify(await promise);
      },
      check: (res) => {
        expect(res).toEqual(JSON.stringify([false, "0x00000000"]));
      },
    },
    {
      name: "Auth Fail",
      fun: async (env, mu) => {
        const key = await env.crypto().subtle.importKey(
          "raw",
          env.encodeUTF8("this-is-not-correct"), // <--
          { name: "HMAC", hash: "SHA-256" },
          false,
          ["sign"],
        );
        const socket = await mu.connect(env, "ws://localhost:8090", {
          accessKey: "ABCDEFGHIJKLMNOPQRST",
          privateKey: key,
          deviceUuid: "F6A0A084-D21F-487D-813A-971C183309A3",
        });
        let receivedData = "";
        let receivedCode = 0;
        let promise = new Promise(function (resolve, reject) {
          socket.onError = (code, msg) => {
            setTimeout(() => {
              if (receivedData == "") {
                resolve([code, receivedData]);
              }
            }, 2000);
          };
          socket
            .openStream()
            .then((stream) => {
              stream.onData = (data) => {
                receivedData = mu.toHex(data);
                reject(JSON.stringify([receivedCode, receivedData]));
              };
              // this doesn't get called because the socket errored
              socket.onClose = () =>
                reject(JSON.stringify([receivedCode, receivedData]));
              stream.send(mu.request_echo(0));
            })
            .catch((ex) => {});
          setTimeout(() => socket.closeSocket(), 2000);
        });
        return JSON.stringify(await promise);
      },
      check: (res) => {
        expect(res).toEqual(JSON.stringify([1002, ""]));
      },
    },
    {
      name: "Error Connection",
      fun: async (env, mu) => {
        const socket = await mu.connectAndAuth(env);
        const stream = await socket.openStream();
        let promise = new Promise(function (resolve, reject) {
          let receivedData = "";
          stream.onError = (code, msg) => {
            setTimeout(() => {
              if (receivedData == "") {
                resolve([code, msg]);
              }
            }, 2000);
          };

          stream.onData = (data) => {
            receivedData = mu.toHex(data);
            reject(JSON.stringify(receivedData));
          };

          stream.send(mu.request_echo(0));
          socket.errorSocket(99, "test");
        });
        return JSON.stringify(await promise);
      },
      check: (res) => {
        expect(res).toEqual(JSON.stringify([99, "test"]));
      },
    },
    {
      name: "Threads",
      fun: async (env, mu, to) => {
        const socket = await mu.connectAndAuth(env);
        let promise = new Promise(function (resolve, reject) {
          let streamCount = 6;
          let received: Array<number> = [];

          socket.onStream = (stream) => {
            let acc = 0;
            stream.onData = (data) => {
              const dataView = new DataView(data);
              acc += dataView.getUint32(0);
            };

            stream.onClose = () => {
              received.push(acc);
              if (--streamCount < 1) {
                socket.closeSocket();
              }
            };

            stream.close();
          };

          socket.onClose = () => resolve(received);
          socket.openStream().then((stream) => {
            stream.send(mu.request_concurrent_streaming());
            stream.close();
          });
        });
        return JSON.stringify(await promise);
      },
      check: (res) => {
        let val = 10001 * (10000 / 2);
        expect(res).toEqual(JSON.stringify([val, val, val, val, val, val]));
      },
    },
  ];
};
