import { useState } from "react";

const Sugestions = () => {
  const [suggestions, setSuggestions] = useState("");

  console.debug("suggestions --> " + suggestions);
  return (
    <>
      <h3>Suggestions</h3>
      <textarea
        placeholder="Any notes or comments?"
        value={suggestions}
        onChange={(e) => setSuggestions(e.target.value)}
      />
    </>
  );
};

export default Sugestions;
