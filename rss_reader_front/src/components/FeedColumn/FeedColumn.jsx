import { useEffect, useState } from "react";
import { listItems, toggleRead, deleteFeed } from "../../api";
import styles from "./FeedColumn.module.css";

const PER_PAGE = 5;

const pageWindow = (current, total, win = 5) => {
  const half = Math.floor(win / 2);
  let start = Math.max(1, current - half);
  let end = Math.min(total, start + win - 1);
  start = Math.max(1, end - win + 1);
  const arr = [];
  for (let i = start; i <= end; i++) arr.push(i);
  return arr;
};

export default function FeedColumn({ feed, onDelete }) {
  const [page, setPage] = useState(1);
  const [items, setItems] = useState([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const pages = Math.max(1, Math.ceil((total || 0) / PER_PAGE));

  const load = async () => {
    setLoading(true);
    setError(null);
    try {
      const data = await listItems({ page, per_page: PER_PAGE, feed_id: feed.id });
      setItems(data.items);
      setTotal(data.total);
    } catch (e) {
      setError(e.message || "Erreur de chargement");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    setPage(1);
    setItems([]);
    setError(null);
  }, [feed.id]);

  useEffect(() => {
    load();
  }, [page, feed.id]);

  const onToggle = async (id) => {
    const r = await toggleRead(id);
    setItems(xs => xs.map(x => (x.id === id ? { ...x, read: r.read } : x)));
  };

  const removeFeed = async () => {
    if (!confirm(`Supprimer le flux «${feed.title}» ?`)) return;
    await deleteFeed(feed.id);
    onDelete?.(feed.id);
  };

  return (
    <section className={styles.col}>
      <div className={styles.header}>
        <div className={styles.title}>
          <span>les news de </span>
          <strong className={styles.titleText}>{feed.title}</strong>
        </div>

        <div className={styles.headerRight}>
          <div className={styles.pager}>
            <button
              onClick={() => setPage(p => Math.max(1, p - 1))}
              disabled={page <= 1}
              aria-label="Page précédente"
              className={styles.pagerBtn}
            >←</button>

            <span className={styles.pageInfo}>{page} / {pages}</span>

            <button
              onClick={() => setPage(p => Math.min(pages, p + 1))}
              disabled={page >= pages}
              aria-label="Page suivante"
              className={styles.pagerBtn}
            >→</button>
          </div>

          <button
            className={styles.closeBtn}
            onClick={removeFeed}
            aria-label="Supprimer le flux"
            title="Supprimer le flux"
          >×</button>
        </div>
      </div>

      {error && (
        <div className={styles.muted}>
          {error}
        </div>
      )}

      {loading && items.length === 0 && (
        <div className={styles.muted}>Chargement…</div>
      )}

      <ul className={styles.list}>
        {items.map(it => (
          <li key={it.id} className={`${styles.card} ${it.read ? styles.read : styles.unread}`}>
            <div className={styles.rowTop}>
              <a className={styles.itemTitle} href={it.url} target="_blank" rel="noreferrer">
                {it.title}
              </a>
              <div className={styles.date}>
                {new Date(it.published_at).toLocaleDateString("fr-FR")}
              </div>
            </div>

            {it.summary && (
              <p className={styles.summary}>
                {stripHtml(it.summary).slice(0, 180)}
                {stripHtml(it.summary).length > 180 ? "…" : ""}
              </p>
            )}

            <div className={styles.rowBottom}>
              <button className={styles.mark} onClick={() => onToggle(it.id)}>
                {it.read ? "Marquer comme non lu" : "Marquer comme lu"}
              </button>
            </div>
          </li>
        ))}
      </ul>

      <div className={styles.numberPager}>
        <span
          className={`${styles.navText} ${page <= 1 ? styles.disabled : ""}`}
          onClick={() => page > 1 && setPage(page - 1)}
        >
          précédente
        </span>

        <ul className={styles.pages}>
          {pageWindow(page, pages, 5).map(n => (
            <li key={n}>
              <span
                className={`${styles.pageNum} ${n === page ? styles.activePage : ""}`}
                onClick={() => setPage(n)}
              >
                {n}
              </span>
            </li>
          ))}
        </ul>

        <span
          className={`${styles.navText} ${page >= pages ? styles.disabled : ""}`}
          onClick={() => page < pages && setPage(page + 1)}
        >
          suivante
        </span>
      </div>
    </section>
  );
}

function stripHtml(html) {
  const d = document.createElement("div");
  d.innerHTML = html || "";
  return d.textContent || d.innerText || "";
}
