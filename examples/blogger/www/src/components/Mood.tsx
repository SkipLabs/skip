import { useState } from "react";

const Mood = () => {
  const [mood, setMood] = useState("");

  console.debug("mood --> " + mood);

  return (
    <>
      <h3>Mood</h3>
      <textarea
        placeholder="How are you feeling about this post?"
        value={mood}
        onChange={(e) => setMood(e.target.value)}
      />
    </>
  );
};

export default Mood;
