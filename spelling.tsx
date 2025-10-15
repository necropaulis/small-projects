import React, { useState } from "react";
import "./App.css";

const DICTIONARY = [
  "a", "at", "an", "cat", "bat", "rat", "cart", "cast", "can", "ant", "tan", "tap", "pat", "part"
];

function isOneLetterAdded(base: string, candidate: string) {
  if (candidate.length !== base.length + 1) return false;
  let diff = 0;
  let i = 0, j = 0;
  while (i < base.length && j < candidate.length) {
    if (base[i] !== candidate[j]) {
      diff++;
      j++;
      if (diff > 1) return false;
    } else {
      i++;
      j++;
    }
  }
  return true;
}

function App() {
  const [path, setPath] = useState(["a"]);
  const [input, setInput] = useState("");
  const [message, setMessage] = useState("");

  const currentWord = path[path.length - 1];

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const word = input.trim().toLowerCase();

    if (!DICTIONARY.includes(word)) {
      setMessage("❌ Not a valid word!");
      return;
    }
    if (!isOneLetterAdded(currentWord, word)) {
      setMessage("⚠️ Must add exactly one new letter.");
      return;
    }
    if (path.includes(word)) {
      setMessage("⛔ Word already used!");
      return;
    }

    setPath([...path, word]);
    setInput("");
    setMessage("✅ Nice one!");
  };

  return (
    <div className="game">
      <h1>Spelling Growth Game 🧩</h1>
      <p>Start from <b>"a"</b> and add one letter each turn!</p>

      <div className="tree">
        {path.map((word, i) => (
          <span key={i} className="word-node">{word}</span>
        ))}
      </div>

      <form onSubmit={handleSubmit}>
        <input
          type="text"
          value={input}
          onChange={e => setInput(e.target.value)}
          placeholder="Enter new word"
        />
        <button type="submit">Add</button>
      </form>

      <p className="message">{message}</p>
    </div>
  );
}

export default App;
