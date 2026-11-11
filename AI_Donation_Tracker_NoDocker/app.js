const $ = id => document.getElementById(id);
const money = n => "R" + Number(n).toLocaleString("en-ZA", { minimumFractionDigits: 2, maximumFractionDigits: 2 });
// Escape everything that comes from the database before putting it in HTML (prevents XSS).
const esc = s => String(s ?? "").replace(/[&<>"']/g, c => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]));
const formatDate = s => { const d = new Date(String(s).replace(" ", "T") + "Z"); return isNaN(d) ? s : d.toLocaleDateString("en-ZA", { day: "numeric", month: "short", year: "numeric" }); };

function toast(msg, type = "") {
  const t = document.createElement("div");
  t.className = "toast " + type; t.textContent = msg;
  $("toasts").appendChild(t);
  setTimeout(() => t.remove(), 3500);
}

async function api(url, opts) {
  const res = await fetch(url, opts);
  let data = null;
  try { data = await res.json(); } catch { /* non-JSON response */ }
  if (!data) throw new Error("Unexpected server response (HTTP " + res.status + ")");
  return data;
}

// ---- Theme ----
const savedTheme = localStorage.getItem("theme") || (matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light");
document.documentElement.dataset.theme = savedTheme;
$("themeBtn").onclick = () => {
  const t = document.documentElement.dataset.theme === "dark" ? "light" : "dark";
  document.documentElement.dataset.theme = t; localStorage.setItem("theme", t);
};

// ---- Load + render ----
let all = [];

async function loadDonations() {
  try {
    const d = await api("get_donations.php");
    all = d.donations || [];
    $("statTotal").textContent = money(d.total);
    $("statCount").textContent = d.count;
    $("statAvg").textContent = money(d.average);
    $("statMax").textContent = money(d.largest);
    renderBreakdown(d.byPurpose || {}, d.total);
    renderTable();
  } catch (e) {
    $("donationsTable").innerHTML = '<tr><td colspan="5" class="empty">Could not load donations. Is the PHP server running?</td></tr>';
  }
}

function renderBreakdown(by, total) {
  const entries = Object.entries(by).sort((a, b) => b[1] - a[1]);
  $("breakdown").innerHTML = total > 0
    ? entries.map(([k, v]) => `<div><div class="bar-top"><span>${esc(k)}</span><span>${money(v)} · ${Math.round(v / total * 100)}%</span></div><div class="bar"><i style="width:${v / total * 100}%"></i></div></div>`).join("")
    : '<p class="empty">No data yet.</p>';
}

function renderTable() {
  const q = $("search").value.trim().toLowerCase(), p = $("filterPurpose").value;
  const rows = all.filter(r => (!p || r.purpose === p) && (!q || r.donor_name.toLowerCase().includes(q)));
  $("donationsTable").innerHTML = rows.length ? rows.map(r => `
    <tr><td>${esc(r.donor_name)}</td><td class="num">${money(r.amount)}</td>
    <td><span class="tag">${esc(r.purpose)}</span></td>
    <td>${r.cardano_tx_id ? `<span class="chain" title="${esc(r.cardano_tx_id)}">₳ ${esc(r.cardano_tx_id.slice(0, 8))}…</span>` : "—"}</td>
    <td>${esc(formatDate(r.created_at))}</td></tr>`).join("")
    : `<tr><td colspan="5" class="empty">${all.length ? "No donations match your filters." : "No donations yet. Add the first one!"}</td></tr>`;
}
$("search").oninput = renderTable;
$("filterPurpose").onchange = renderTable;

// ---- Add a donation ----
$("donationForm").addEventListener("submit", async e => {
  e.preventDefault();
  const btn = e.submitter; btn.disabled = true;
  const body = new FormData();
  body.append("donorName", $("donorName").value.trim());
  body.append("amount", $("amount").value);
  body.append("purpose", $("purpose").value);
  body.append("cardanoTxId", $("transactionId").value.trim());
  try {
    const r = await api("save_donation.php", { method: "POST", body });
    toast(r.message, r.ok ? "ok" : "err");
    if (r.ok) { e.target.reset(); $("cardanoResult").textContent = ""; loadDonations(); }
  } catch (err) { toast(err.message, "err"); }
  btn.disabled = false;
});

// ---- AI assistant ----
async function ask(question) {
  const el = $("aiResponse"); el.hidden = false; el.textContent = "Thinking…";
  try {
    const r = await api("ai_assistant.php", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ question }) });
    el.textContent = r.answer;
  } catch (err) { el.textContent = "Sorry, the assistant could not respond: " + err.message; }
}
$("askAiBtn").onclick = () => { const q = $("question").value.trim(); q ? ask(q) : toast("Type a question first.", "err"); };
$("question").addEventListener("keydown", e => { if (e.key === "Enter") $("askAiBtn").click(); });
$("chips").onclick = e => { if (e.target.classList.contains("chip")) { $("question").value = e.target.textContent; ask(e.target.textContent); } };

// ---- Cardano verification ----
$("verifyTxBtn").onclick = async () => {
  const transactionId = $("transactionId").value.trim(), el = $("cardanoResult");
  if (!transactionId) { toast("Enter a transaction ID first.", "err"); return; }
  el.className = "hint"; el.textContent = "Checking…";
  try {
    const r = await api("verify_transaction.php", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ transactionId }) });
    el.textContent = r.message;
    el.className = "hint " + (["confirmed", "format_ok"].includes(r.status) ? "ok" : "bad");
  } catch (err) { el.className = "hint bad"; el.textContent = err.message; }
};

loadDonations();
