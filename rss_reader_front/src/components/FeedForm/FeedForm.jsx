import { useState } from "react";
import styles from "./FeedForm.module.css";

export default function FeedForm({ onSubmit }) {
  const [title, setTitle] = useState("");
  const [url, setUrl] = useState("");
  const [busy, setBusy] = useState(false);

  const submit = async (e) => {
    e.preventDefault();
    if (!title || !url) return;
    setBusy(true);
    try {
      await onSubmit({ title, url });
      setTitle(""); setUrl("");
    } finally {
      setBusy(false);
    }
  };

  return (
    <form className={styles.form} onSubmit={submit}>
      <input
        value={title}
        onChange={e => setTitle(e.target.value)}
        placeholder="Titre du flux"
      />
      <input
        value={url}
        onChange={e => setUrl(e.target.value)}
        placeholder="URL du flux"
      />
      <button disabled={busy || !title || !url}>OK</button>
    </form>
  );
}
