/*
  manages light/dark mode.
*/

{
  // immediately load saved (or default) mode before page renders
  document.documentElement.dataset.dark =
    window.localStorage.getItem("dark-mode") ?? "false";

  const onLoad = () => {
    // update toggle button to match loaded mode
    const toggle = document.querySelector(".dark-toggle");
    if (toggle) toggle.checked = document.documentElement.dataset.dark === "true";
  };

  // after page loads
  window.addEventListener("load", onLoad);
  window.addEventListener("languagepagechange", onLoad);

  // when user toggles mode button
  window.onDarkToggleChange = (event) => {
    const value = event.target.checked;
    document.documentElement.dataset.dark = value;
    window.localStorage.setItem("dark-mode", value);
  };
}
