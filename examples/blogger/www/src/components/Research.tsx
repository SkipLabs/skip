import { useState } from "react";

const Research = () => {
  const [research, setResearch] = useState("");

  console.debug("research --> " + research);
  return (
    <>
      <h3>Research</h3>
      <textarea
        placeholder="Research notes and references"
        value={research}
        onChange={(e) => setResearch(e.target.value)}
      />{" "}
    </>
  );
};

export default Research;
