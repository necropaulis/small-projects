function WordNode({ word, children }) {
  return (
    <div className="word-node">
      <p>{word}</p>
      <div className="branches">
        {children.map(child => (
          <WordNode key={child.word} {...child} />
        ))}
      </div>
    </div>
  );
}
