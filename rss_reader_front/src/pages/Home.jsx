import { useEffect, useState } from "react";
import Header from "../components/Header/Header";
import FeedColumn from "../components/FeedColumn/FeedColumn";
import FeedForm from "../components/FeedForm/FeedForm";
import { listFeeds, createFeed } from "../api";

export default function Home() {
  const [feeds, setFeeds] = useState([]);
  const [showForm, setShowForm] = useState(false);

  const fetchFeeds = async () => {
    const data = await listFeeds();
    setFeeds(data);
  };
  useEffect(() => { fetchFeeds(); }, []);

  const onAddFeed = async (payloadOrTitle, maybeUrl) => {
    const { title, url } =
      typeof payloadOrTitle === "object"
        ? payloadOrTitle
        : { title: payloadOrTitle, url: maybeUrl };

    try {
      const newFeed = await createFeed(title, url);
      setFeeds(fs => [newFeed, ...fs]);
      setShowForm(false);
    } catch (e) {
      alert(e.message || "Impossible d'ajouter le flux");
    }
  };

  const handleFeedDeleted = (id) => {
    const rid = Number(id);
    setFeeds(xs => xs.filter(f => Number(f.id) !== rid));
  };

  return (
    <div className="container">
      <Header title="Lecteur RSS" />

      <div className="topBar">
        <button
          className={showForm ? "iconBtn" : "primary"}
          onClick={() => setShowForm(v => !v)}
          aria-label={showForm ? "Fermer" : "Ajouter un flux"}
          title={showForm ? "Fermer" : "Ajouter un flux"}
        >
          {showForm ? "×" : "Ajouter un flux"}
        </button>
      </div>

      {showForm && (
        <div className="inlineForm">
          <FeedForm onSubmit={onAddFeed} />
        </div>
      )}

      <div className="columns">
        {feeds.map(feed => (
          <FeedColumn
            key={feed.id}
            feed={feed}
            onDelete={handleFeedDeleted}
          />
        ))}
        {feeds.length === 0 && (
          <div className="muted">Ajoutez un flux pour commencer</div>
        )}
      </div>
    </div>
  );
}
