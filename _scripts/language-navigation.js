/* Progressive enhancement for the English/Chinese static page switcher. */

{
  const selector = ".language-toggle";
  let navigating = false;

  const initialLanguage = document.documentElement.dataset.language;
  if (initialLanguage === "en" || initialLanguage === "zh") {
    window.localStorage.setItem("site-language", initialLanguage);
  }

  const copyHeadElement = (nextDocument, selector) => {
    const current = document.head.querySelector(selector);
    const next = nextDocument.head.querySelector(selector);

    if (current && next) current.replaceWith(next.cloneNode(true));
    else if (current && !next) current.remove();
    else if (!current && next) document.head.append(next.cloneNode(true));
  };

  const updateHead = (nextDocument) => {
    document.title = nextDocument.title;

    [
      'meta[name="title"]',
      'meta[name="description"]',
      'meta[property="og:title"]',
      'meta[property="og:description"]',
      'meta[property="og:url"]',
      'meta[property="og:locale"]',
      'meta[property="og:locale:alternate"]',
      'meta[property="twitter:title"]',
      'meta[property="twitter:description"]',
      'meta[property="twitter:url"]',
      'link[rel="canonical"]',
      'link[rel="alternate"][hreflang="en"]',
      'link[rel="alternate"][hreflang="zh-CN"]',
      'link[rel="alternate"][hreflang="x-default"]',
      'link[rel="prefetch"]',
    ].forEach((headSelector) => copyHeadElement(nextDocument, headSelector));
  };

  const replacePage = (nextDocument) => {
    const selectors = ["header", "main", "footer"];
    const replacements = selectors.map((pageSelector) => [
      document.querySelector(pageSelector),
      nextDocument.querySelector(pageSelector),
    ]);

    if (replacements.some(([current, next]) => !current || !next)) {
      throw new Error("The translated page is missing a required section.");
    }

    const apply = () => {
      replacements.forEach(([current, next]) => current.replaceWith(next));
      document.documentElement.lang = nextDocument.documentElement.lang;
      document.documentElement.dataset.language = nextDocument.documentElement.dataset.language;
      updateHead(nextDocument);
    };

    if (document.startViewTransition && !window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
      document.startViewTransition(apply);
    } else apply();
  };

  const loadLanguagePage = async (url, pushHistory = true) => {
    if (navigating) return;
    navigating = true;
    document.documentElement.dataset.languageLoading = "true";

    try {
      const response = await fetch(url, { headers: { Accept: "text/html" } });
      if (!response.ok) throw new Error(`Language page request failed: ${response.status}`);

      const html = await response.text();
      const nextDocument = new DOMParser().parseFromString(html, "text/html");
      replacePage(nextDocument);

      if (pushHistory) window.history.pushState({ languageNavigation: true }, "", url);

      const language = nextDocument.documentElement.dataset.language || "en";
      window.localStorage.setItem("site-language", language);
      window.dispatchEvent(new Event("languagepagechange"));

      if (typeof window.gtag === "function") {
        window.gtag("event", "page_view", {
          page_location: window.location.href,
          page_title: document.title,
        });
      }
    } catch (error) {
      if (pushHistory) window.location.assign(url);
      else window.location.reload();
    } finally {
      navigating = false;
      delete document.documentElement.dataset.languageLoading;
    }
  };

  document.addEventListener("click", (event) => {
    const link = event.target.closest(selector);
    if (!link || event.defaultPrevented || event.button !== 0 || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return;

    const url = new URL(link.href, window.location.href);
    if (url.origin !== window.location.origin) return;

    event.preventDefault();
    loadLanguagePage(url.href);
  });

  window.addEventListener("popstate", () => loadLanguagePage(window.location.href, false));
}
