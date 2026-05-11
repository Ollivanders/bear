import theme from "./theme.js"
import keys from "./keys.js"

export default {
  settings: {
    hintAlign: "left",
    hintCharacters: "qwertasdfgzxcvb",
    omnibarSuggestionTimeout: 500,
    richHintsForKeystroke: 1,
    defaultSearchEngine: "ka",
    stealFocusOnLoad: false,
    theme,
  },

  keys,

  // Leader for site-specific mappings
  siteleader: "<Space>",

  // Leader for OmniBar searchEngines
  searchleader: "a",

  // Array containing zero or more log levels to enable: log, warn, error
  logLevels: [
    // "log",
    // "warn",
    "error",
  ],
}
