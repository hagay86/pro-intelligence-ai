/* Maven frontend config
   Loaded by index.html / login.html / chat.html
   Edit the production URL once you have your Cloudflare Tunnel running. */

(function () {
  // Auto-detect environment:
  // - localhost or 127.0.0.1 → assume backend on http://localhost:3000
  // - anything else → use the production URL configured below
  //
  // To deploy: replace PRODUCTION_API below with your Cloudflare Tunnel URL.

  // Same-origin by default: when the site is hosted on the same server that
  // serves the API (e.g. one Cloudflare tunnel serving both static + /api),
  // leave MAVEN_API as empty string for relative URLs.
  // Override with an explicit URL only if you split frontend + backend.

  // Same-origin by default: the Node server serves both the pages and /api,
  // so relative URLs just work locally, through a Cloudflare tunnel, or on Render/Fly.
  // Only a page opened straight from disk (file://) needs an explicit backend.
  // To split frontend + backend (e.g. Netlify), set window.MAVEN_API_OVERRIDE before this script.
  window.MAVEN_API =
    window.MAVEN_API_OVERRIDE ||
    (location.protocol === "file:" ? "http://localhost:3000" : "");

  // Helper: call API with auth cookies
  window.mavenFetch = async function (path, opts = {}) {
    const url = window.MAVEN_API + (path.startsWith("/") ? path : "/" + path);
    const r = await fetch(url, {
      credentials: "include",
      ...opts,
      headers: {
        "Content-Type": "application/json",
        ...(opts.headers || {}),
      },
    });
    let data;
    try { data = await r.json(); } catch { data = {}; }
    if (r.status === 429 && !data.error) data.error = "Too many requests — wait a minute and try again.";
    if (!r.ok) {
      const err = new Error(data.error || `HTTP ${r.status}`);
      err.status = r.status;
      err.data = data;
      throw err;
    }
    return data;
  };

  // Helper: navigate to login.html if not authenticated
  window.mavenRequireAuth = async function () {
    try {
      const r = await window.mavenFetch("/api/auth/me");
      if (!r.user) {
        location.href = "login.html";
        return null;
      }
      return r.user;
    } catch (e) {
      console.error("Auth check failed:", e);
      // Backend unreachable — show a soft warning rather than redirect
      return null;
    }
  };
})();
