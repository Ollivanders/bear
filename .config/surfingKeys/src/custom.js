
const { Clipboard, Front, Hints } = api;

api.mapkey('<Space>j', 'copy jira ticket from url', function() {
  const match = window.location.href.match(/\/browse\/([A-Z]+-\d+)/);
  if (match) {
    api.Clipboard.write(match[1]);
    api.Front.showBanner('copied: ' + match[1]);
  } else {
    api.Front.showBanner('no jira ticket found in url');
  }
});
