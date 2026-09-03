import axios from "axios";

const raw = import.meta.env.VITE_API_BASE_URL;
const BASE_URL = raw.replace(/\/+$/, "");

const api = axios.create({
  baseURL: BASE_URL,
  headers: { "Content-Type": "application/json" },
});

function handleApiError(e) {
  console.error(e?.response?.data || e);
  const msg = e?.response?.data?.errors?.join?.(", ") || e.message || "Erreur réseau";
  throw new Error(msg);
}

export const listFeeds = async () => {
  try { return (await api.get("/feeds")).data; }
  catch (e) { handleApiError(e); }
};

export const createFeed = async (title, url) => {
  try { return (await api.post("/feeds", { feed: { title, url } })).data; }
  catch (e) { handleApiError(e); }
};

export const deleteFeed = async (id) => {
  try { await api.delete(`/feeds/${id}`); }
  catch (e) { handleApiError(e); }
};

export const listItems = async (params) => {
  try { return (await api.get("/feed_items", { params })).data; }
  catch (e) { handleApiError(e); }
};

export const toggleRead = async (id) => {
  try { return (await api.patch(`/feed_items/${id}/toggle_read`)).data; }
  catch (e) { handleApiError(e); }
};