# Manual Setup Steps

The files in this directory need to be manually actioned for whatever reason. See list below for details.

## Files

### [`userChrome.css`](userChrome.css)

This file is used with Firefox to customise how the browser looks.  
It should be copied to `~/.mozilla/firefox/<profile>/chrome/userChrome.css` where `<profile>` is the name of your Firefox profile.

Then go to `about:config` in Firefox and set `toolkit.legacyUserProfileCustomizations.stylesheets` to `true` to enable the use of this file.

Read the contents of [`userChrome.css`](userChrome.css) to ensure no other preferences need to be changed too.
