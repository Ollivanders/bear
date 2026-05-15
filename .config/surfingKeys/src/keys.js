import actions from "./actions.js"
import api from "./api.js"
import help from "./help.js"
import util from "./util.js"

const { categories } = help

const { Clipboard, Front, Hints } = api

// Remove undesired default mappings
const unmaps = {
  mappings: [
    "sb",
    "sw",
    "ob",
    "oe",
    "ow",
    "oy",
    "cp",
    ";cp",
    ";ap",
    "spa",
    "spb",
    "spd",
    "sps",
    "spc",
    "spi",
    "sfr",
    "zQ",
    "zz",
    "zR",
    "ab",
    "Q",
    "q",
    "ag",
    "af",
    ";s",
    "yp",
    "p",
    "<Ctrl-j>",
    "<Ctrl-h>",
  ],
  searchAliases: {
    s: ["g", "d", "b", "e", "w", "s", "h", "y"],
  },
}

const maps = {}

maps.global = [
  {
    alias: "F",
    map: "gf",
    category: categories.mouseClick,
    description: "Open a link in non-active new tab",
  },
  {
    alias: "zf",
    category: categories.mouseClick,
    description: "Open link URL in vim editor",
    callback: actions.previewLink,
  },
  {
    alias: "w",
    map: "k",
    category: categories.scroll,
    description: "Scroll up",
  },
  {
    alias: "s",
    map: "j",
    category: categories.scroll,
    description: "Scroll down",
  },
  {
    alias: "K",
    map: "e",
    category: categories.scroll,
    description: "Scroll half page up",
  },
  {
    alias: "J",
    map: "d",
    category: categories.scroll,
    description: "Scroll half page down",
  },
  {
    alias: "gh",
    category: categories.scroll,
    description: "Scroll to element targeted by URL hash",
    callback: actions.scrollToHash,
  },
  {
    alias: "gi",
    category: categories.pageNav,
    description: "Edit current URL with vim editor",
    callback: actions.vimEditURL,
  },
  {
    alias: "gI",
    category: categories.pageNav,
    description: "View image in new tab",
    callback: () => util.createHints("img", (i) => actions.openLink(i.src)),
  },
  {
    alias: "g.",
    category: categories.pageNav,
    description: "Go to parent domain",
    callback: () => {
      const subdomains = window.location.host.split(".")
      const parentDomain = (
        subdomains.length > 2 ? subdomains.slice(1) : subdomains
      ).join(".")
      actions.openLink(`${window.location.protocol}//${parentDomain}`)
    },
  },
  {
    alias: "yp",
    category: categories.clipboard,
    description: "Copy URL path of current page",
    callback: () => Clipboard.write(window.location.href),
  },
  {
    alias: "yI",
    category: categories.clipboard,
    description: "Copy Image URL",
    callback: () => util.createHints("img", (i) => Clipboard.write(i.src)),
  },
  {
    alias: "yA",
    category: categories.clipboard,
    description: "Copy link as Markdown",
    callback: () =>
      util.createHints("a[href]", (a) =>
        Clipboard.write(`[${a.innerText}](${a.href})`)
      ),
  },
  {
    alias: "yO",
    category: categories.clipboard,
    description: "Copy page URL/Title as Org-mode link",
    callback: () => Clipboard.write(actions.getOrgLink()),
  },
  {
    alias: "yM",
    category: categories.clipboard,
    description: "Copy page URL/Title as Markdown link",
    callback: () => Clipboard.write(actions.getMarkdownLink()),
  },
  {
    alias: "yT",
    category: categories.tabs,
    description: "Duplicate current tab (non-active new tab)",
    callback: () =>
      actions.openLink(window.location.href, { newTab: true, active: false }),
  },
  {
    alias: "yu",
    category: categories.clipboard,
    description: "copy jira ticket from url",
    callback: actions.copyJiraTicketId,
  },
  // TODO
  // {
  //   alias:       "yx",
  //   category:    categories.tabs,
  //   description: "Cut current tab",
  //   callback:    () => actions.cutTab(),
  // },
  // {
  //   alias:       "px",
  //   category:    categories.tabs,
  //   description: "Paste tab",
  //   callback:    () => actions.pasteTab(),
  // },
  {
    alias: ";se",
    category: categories.settings,
    description: "Edit Settings",
    callback: actions.editSettings,
  },
  {
    alias: "=W",
    category: categories.misc,
    description: "Lookup whois information for domain",
    callback: () => actions.openLink(actions.getWhoisUrl(), { newTab: true }),
  },
  {
    alias: "=d",
    category: categories.misc,
    description: "Lookup dns information for domain",
    callback: () => actions.openLink(actions.getDnsInfoUrl(), { newTab: true }),
  },
  {
    alias: "=D",
    category: categories.misc,
    description: "Lookup all information for domain",
    callback: () =>
      actions.openLink(actions.getDnsInfoUrl({ all: true }), { newTab: true }),
  },
  {
    alias: "=c",
    category: categories.misc,
    description: "Show Google's cached version of page",
    callback: () =>
      actions.openLink(actions.getGoogleCacheUrl(), { newTab: true }),
  },
  {
    alias: "=a",
    category: categories.misc,
    description: "Show Archive.org Wayback Machine for page",
    callback: () => actions.openLink(actions.getWaybackUrl(), { newTab: true }),
  },
  {
    alias: "=A",
    category: categories.misc,
    description: "Show Alexa.com info for domain",
    callback: () => actions.openLink(actions.getAlexaUrl(), { newTab: true }),
  },
  {
    alias: "=s",
    category: categories.misc,
    description: "View social discussions for page",
    callback: () =>
      actions.openLink(actions.getDiscussionsUrl(), { newTab: true }),
  },
  {
    alias: "=S",
    category: categories.misc,
    description: "View summary for page",
    callback: () => actions.openLink(actions.getSummaryUrl(), { newTab: true }),
  },
  {
    alias: "=o",
    category: categories.misc,
    description: "Show outline.com version of page",
    callback: () => actions.openLink(actions.getOutlineUrl(), { newTab: true }),
  },
  {
    alias: "=bw",
    category: categories.misc,
    description: "Show BuiltWith report for page",
    callback: () =>
      actions.openLink(actions.getBuiltWithUrl(), { newTab: true }),
  },
  {
    alias: "=wa",
    category: categories.misc,
    description: "Show Wappalyzer report for page",
    callback: () =>
      actions.openLink(actions.getWappalyzerUrl(), { newTab: true }),
  },
  {
    alias: ";pd",
    category: categories.misc,
    description: "Toggle PDF viewer from SurfingKeys",
    callback: actions.togglePdfViewer,
  },
  {
    alias: "gxE",
    map: "gxt",
    category: categories.tabs,
    description: "Close tab to left",
  },
  {
    alias: "gxR",
    map: "gxT",
    category: categories.tabs,
    description: "Close tab to right",
  },
  {
    alias: "\\cgh",
    category: categories.clipboard,
    description: "Open clipboard string as GitHub path (e.g. 'torvalds/linux')",
    callback: async () => {
      const { url } = actions.gh.parseRepo(await navigator.clipboard.readText())
      Front.showBanner(`Open ${url}`)
      actions.openLink(url, { newTab: true })
    },
  },
  {
    alias: "F",
    map: "gf",
    category: categories.mouseClick,
    description: "Open a link in non-active new tab",
  },
  {
    alias: "oh",
    category: categories.omnibar,
    description: "Open URL from history",
    callback: () => Front.openOmnibar({ type: "History" }),
  },
  // {
  //   alias:       "\\A",
  //   description: "Open AWS service",
  //   callback:    actions.omnibar.aws,
  // },
]

maps["amazon.com"] = [
  {
    alias: "fs",
    description: "Fakespot",
    callback: actions.fakeSpot,
  },
  {
    alias: "a",
    description: "View product",
    callback: actions.az.viewProduct,
  },
  {
    alias: "c",
    description: "Add to Cart",
    callback: () => util.createHints("#add-to-cart-button"),
  },
  {
    alias: "R",
    description: "View Product Reviews",
    callback: () => actions.openLink("#customerReviews"),
  },
  {
    alias: "Q",
    description: "View Product Q&A",
    callback: () => actions.openLink("#Ask"),
  },
  {
    alias: "A",
    description: "Open Account page",
    callback: () => actions.openLink("/gp/css/homepage.html"),
  },
  {
    alias: "C",
    description: "Open Cart page",
    callback: () => actions.openLink("/gp/cart/view.html"),
  },
  {
    alias: "O",
    description: "Open Orders page",
    callback: () => actions.openLink("/gp/css/order-history"),
  },
]

const googleSearchResultSelector = [
  "a h3",
  "h3 a",
  "a[href^='/search']:not(.fl):not(#pnnext,#pnprev):not([role]):not(.hide-focus-ring)",
  "g-scrolling-carousel a",
  ".rc > div:nth-child(2) a",
  ".kno-rdesc a",
  ".kno-fv a",
  ".isv-r > a:first-child",
  ".dbsr > a:first-child",
  ".X5OiLe",
  ".WlydOe",
  ".fl",
].join(",")

maps["www.google.com"] = [
  {
    alias: "a",
    description: "Open search result",
    callback: () => util.createHints(googleSearchResultSelector),
  },
  {
    alias: "A",
    description: "Open search result (new tab)",
    callback: () =>
      util.createHints(
        googleSearchResultSelector,
        actions.openAnchor({ newTab: true, active: false })
      ),
  },
  {
    alias: "d",
    description: "Open search in DuckDuckGo",
    callback: actions.go.ddg,
  },
]


maps["youtube.com"] = [
  {
    leader: "",
    alias: "A",
    description: "Open video",
    callback: () =>
      util.createHints(
        "*[id='video-title']",
        actions.openAnchor({ newTab: true })
      ),
  },
  {
    leader: "",
    alias: "C",
    description: "Open channel",
    callback: () => util.createHints("*[id='byline']"),
  },
  {
    leader: "",
    alias: "gH",
    description: "Goto homepage",
    callback: () =>
      actions.openLink("https://www.youtube.com/feed/subscriptions?flow=2"),
  },
  {
    leader: "",
    alias: "F",
    description: "Toggle fullscreen",
    callback: () =>
      actions.dispatchMouseEvents(
        document.querySelector("#movie_player .ytp-fullscreen-button"),
        "mousedown",
        "click"
      ),
  },
  {
    leader: "",
    alias: "Yt",
    description: "Copy YouTube video link for current time",
    callback: () => Clipboard.write(actions.yt.getCurrentTimestampLink()),
  },
  {
    leader: "",
    alias: "Ym",
    description: "Copy YouTube video markdown link for current time",
    callback: () =>
      Clipboard.write(actions.yt.getCurrentTimestampMarkdownLink()),
  },
]

maps["github.com"] = [
  {
    alias: "A",
    description: "Open repository Actions page",
    callback: () => actions.gh.openRepoPage("/actions"),
  },
  {
    alias: "C",
    description: "Open repository Commits page",
    callback: () => actions.gh.openRepoPage("/commits"),
  },
  {
    alias: "I",
    description: "Open repository Issues page",
    callback: () => actions.gh.openRepoPage("/issues"),
  },
  {
    alias: "N",
    description: "Open notifications page",
    callback: () => actions.gh.openPage("/notifications"),
  },
  {
    alias: "P",
    description: "Open repository Pull Requests page",
    callback: () => actions.gh.openRepoPage("/pulls"),
  },
  {
    alias: "R",
    description: "Open Repository page",
    callback: () => actions.gh.openRepoPage("/"),
  },
  {
    alias: "S",
    description: "Open repository Settings page",
    callback: () => actions.gh.openRepoPage("/settings"),
  },
  {
    alias: "W",
    description: "Open repository Wiki page",
    callback: () => actions.gh.openRepoPage("/wiki"),
  },
  {
    alias: "X",
    description: "Open repository Security page",
    callback: () => actions.gh.openRepoPage("/security"),
  },
  {
    alias: "O",
    description: "Open repository Owner's profile page",
    callback: actions.gh.openRepoOwner,
  },
  {
    alias: "U",
    description: "Open your profile page ('Me')",
    callback: actions.gh.openProfile,
  },
  {
    alias: "a",
    description: "View Repository",
    callback: actions.gh.openRepo,
  },
  {
    alias: "u",
    description: "View User",
    callback: actions.gh.openUser,
  },
  {
    alias: "f",
    description: "View File",
    callback: actions.gh.openFile,
  },
  {
    alias: "c",
    description: "View Commit",
    callback: actions.gh.openCommit,
  },
  {
    alias: "i",
    description: "View Issue",
    callback: actions.gh.openIssue,
  },
  {
    alias: "p",
    description: "View Pull Request",
    callback: actions.gh.openPull,
  },
  {
    alias: "V",
    description: "Approve current Pull Request",
    callback: actions.gh.approvePull,
  },
  {
    alias: "M",
    description: "Merge current Pull Request",
    callback: actions.gh.mergePull,
  },
  {
    alias: "d",
    description: "Approve current deployment",
    callback: actions.gh.approveDeployment,
  },
  {
    alias: "e",
    description: "View external link",
    callback: () => util.createHints("a[rel=nofollow]"),
  },
  {
    // TODO: Add repetition support: 3gu
    leader: "",
    alias: "gu",
    description: "Go up one path in the URL (GitHub)",
    callback: actions.gh.goParent,
  },
  {
    alias: "s",
    description: "Toggle Star",
    callback: actions.gh.star({ toggle: true }),
  },
  {
    alias: "yy",
    description: "Copy Project Path",
    callback: async () => Clipboard.write(util.getURLPath({ count: 2 })),
  },
  {
    alias: "Y",
    description: "Copy Project Path (including domain)",
    callback: () =>
      Clipboard.write(util.getURLPath({ count: 2, domain: true })),
  },
  {
    alias: "l",
    description: "Toggle repo language stats",
    callback: actions.gh.toggleLangStats,
  },
  {
    alias: "D",
    description: "Open in github.dev (new tab)",
    callback: () => actions.gh.openInDev({ newTab: true }),
  },
  {
    alias: "dd",
    description: "Open in github.dev",
    callback: actions.gh.openInDev,
  },
  {
    alias: "G",
    description: "View on SourceGraph",
    callback: actions.gh.viewSourceGraph,
  },
  {
    alias: "r",
    description: "View live raw version of file",
    callback: () =>
      actions.gh
        .selectFile({ directories: false })
        .then((file) => actions.openLink(file.rawUrl, { newTab: true })),
  },
  {
    alias: "yr",
    description: "Copy raw link to file",
    callback: () =>
      actions.gh
        .selectFile({ directories: false })
        .then((file) => Clipboard.write(file.rawUrl)),
  },
  {
    alias: "yf",
    description: "Copy link to file",
    callback: () =>
      actions.gh.selectFile().then((file) => Clipboard.write(file.url)),
  },
  {
    alias: "gcp",
    description: "Open clipboard string as file path in repo",
    callback: actions.gh.openFileFromClipboard,
  },
]

maps["raw.githubusercontent.com"] = [
  {
    alias: "R",
    description: "Open Repository page",
    callback: () => actions.gh.openRepoPage("/"),
  },
  {
    alias: "F",
    description: "Open Source File",
    callback: actions.gh.openSourceFile,
  },
]

maps["github.io"] = [
  {
    alias: "R",
    description: "Open Repository page",
    callback: () => actions.gh.openGithubPagesRepo(),
  },
]

maps["wikipedia.org"] = [
  {
    alias: "s",
    description: "Toggle simple version of current article",
    callback: actions.wp.toggleSimple,
  },
  {
    alias: "a",
    description: "View page",
    callback: () =>
      util.createHints(
        "#bodyContent :not(sup):not(.mw-editsection) > a:not([rel=nofollow])"
      ),
  },
  {
    alias: "e",
    description: "View external link",
    callback: () => util.createHints("a[rel=nofollow]"),
  },
  {
    alias: "ys",
    description: "Copy article summary as Markdown",
    callback: () => Clipboard.write(actions.wp.markdownSummary()),
  },
  {
    alias: "R",
    description: "View WikiRank for current article",
    callback: actions.wp.viewWikiRank,
  },
]

maps["chatgpt.com"] = [
  {
    alias: "i",
    leader: "",
    description: "Focus input",
    callback: () => setTimeout(() => Hints.dispatchMouseClick(document.querySelector("#prompt-textarea")), 0),
  },
]

maps["claude.ai"] = [
  {
    alias: "i",
    leader: "",
    description: "Focus input",
    callback: () => setTimeout(() => Hints.dispatchMouseClick(document.querySelector(".ProseMirror[contenteditable=true]")), 0),
  },
]

maps["console.aws.amazon.com"] = [
  {
    alias: "s",
    description: "Switch AWS session",
    callback: async () => {
      const btn = document.querySelector('[data-testid="more-menu__awsc-nav-account-menu-button"]')
      if (!btn) {
        Front.showBanner("Account menu button not found")
        return
      }
      if (btn.getAttribute("aria-expanded") !== "true") {
        Hints.dispatchMouseClick(btn)
        try {
          // wait for menu to open
          await util.until(() => btn.getAttribute("aria-expanded") === "true")
          // then wait for session tiles to populate
          await util.until(() =>
            document.querySelector('[data-testid^="awsc-account-menu-other-session-tile"]')
          )
        } catch (e) {
          Front.showBanner("No other sessions found")
          return
        }
      }
      const links = document.querySelectorAll('[data-testid^="awsc-account-menu-other-session-tile"]')
      if (!links.length) {
        Front.showBanner("No other sessions found")
        return
      }
      // close menu before omnibar opens
      Hints.dispatchMouseClick(btn)
      const items = Array.from(links).map((link) => {
        const title = link.querySelector('[class*="key-label-variant"]')?.textContent?.trim() ?? "Unknown"
        const sessionUrl = new URL(link.href)
        const newPrefix = sessionUrl.hostname.replace(".console.aws.amazon.com", "")
        const newRegion = newPrefix.split(".").pop()
        const url = new URL(window.location.href)
        url.hostname = `${newPrefix}.console.aws.amazon.com`
        url.searchParams.set("region", newRegion)
        return { title, url: url.href }
      })
      Front.openOmnibar({ type: "UserURLs", extra: items })
    },
  },
  {
    alias: "r",
    description: "Switch AWS region",
    callback: () => {
      const regions = [
        "us-east-1",
        "us-east-2",
        "us-west-1",
        "us-west-2",
        "ap-south-1",
        "ap-northeast-1",
        "ap-northeast-2",
        "ap-northeast-3",
        "ap-southeast-1",
        "ap-southeast-2",
        "ca-central-1",
        "eu-central-1",
        "eu-west-1",
        "eu-west-2",
        "eu-west-3",
        "eu-north-1",
        "sa-east-1",
        "me-south-1",
        "af-south-1",
      ]
      const items = regions.map((r) => {
        const url = new URL(window.location.href)
        url.searchParams.set("region", r)
        return { title: r, url: url.href }
      })
      Front.openOmnibar({ type: "UserURLs", extra: items })
    },
  },
]


const registerDOI = (
  domain,
  provider = actions.doi.providers.meta_citation_doi
) => {
  if (!maps[domain]) {
    maps[domain] = []
  }
  maps[domain].push({
    alias: "O",
    description: "Open DOI",
    callback: () => {
      const url = actions.doi.getLink(provider)
      if (url) {
        actions.openLink(url, { newTab: true })
      }
    },
    hide: true,
  })
}

const aliases = {
  "wikipedia.org": [
    // Wikimedia sites
    "wiktionary.org",
    "wikiquote.org",
    "wikisource.org",
    "wikimedia.org",
    "mediawiki.org",
    "wikivoyage.org",
    "wikibooks.org",
    "wikinews.org",
    "wikiversity.org",
    "wikidata.org",

    // MediaWiki-powered sites
    "wiki.archlinux.org",
  ],

  "stackoverflow.com": [
    "stackexchange.com",
    "serverfault.com",
    "superuser.com",
    "askubuntu.com",
    "stackapps.com",
    "mathoverflow.net",
  ],
}

export default {
  unmaps,
  maps,
  aliases,
}
