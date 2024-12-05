import BrowserOnly from "@docusaurus/BrowserOnly";
import { Route } from "react-router-dom";

export default () => (
  <BrowserOnly>
    {() => {
      <Route
        path="/"
        component={() => {
          window.location.href = "https://skiplabs.io/";
          return null;
        }}
      />;
    }}
  </BrowserOnly>
);
