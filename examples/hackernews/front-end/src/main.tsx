import { createRoot } from "react-dom/client";
import { connect, Protocol } from "@skipruntime/client";
import App from "./App.tsx";
import { SkipContext } from "./SkipContext.ts";
import "./index.css";

const skipclient = await connect(
  "ws://localhost:8080",
  await Protocol.generateCredentials(),
);

const root = createRoot(document.getElementById("root")!);
root.render(
  <SkipContext.Provider value={skipclient}>
    <App />
  </SkipContext.Provider>,
);
