# Rules for coding agents in this repo

- `index.html`, `foto/`, `imn/`, `fotbal/` = the web game. It is maintained by Claude and pushed to `main`. **Do not edit these files.** If the app needs a change there, describe it in your final report.
- `ios/` = the native iOS app (SwiftUI + WKWebView). This is the only folder you change.
- Exception — image tasks: when a task in `tasks/` asks you to generate images, you may add files only in the folder that task names (e.g. `isl/raw/`) and fill in that task's report section. Never edit `index.html`.
- Before starting: `git checkout main && git pull`, then create a new branch for the task (e.g. `ios/<short-name>`).
- The web game is copied into the app automatically on every build by `ios/sync_web.sh`. Never commit `ios/PufiStars/WebContent/` or the generated `*.xcodeproj`.
- After any change: build for an iPad and an iPhone simulator (`xcodebuild ... build`), run the app, check the change works, then commit, `git pull --rebase origin main`, push, and open a pull request into `main` with a short report (what changed, how it was tested, anything that needs a change in `index.html`). Do not merge it yourself.
- Kids app: no analytics, no ads, no third-party tracking; external links stay blocked.
- Keep the JS bridge contract (`window.native.call`, `native.on`) unchanged unless the task says otherwise. Details: `ios/README.md` and `ios/CODEX_PROMPT.md`.
- Hory writes tasks in Romanian; reply to him in Romanian.
