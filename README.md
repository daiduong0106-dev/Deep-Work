# Work Timer

Track your work hours with one tap and see your weekly total against a minimum (default 20h, adjustable in the app). Weeks run Monday → Sunday.

Two versions live in this repo:

## 1. Web app (`docs/`) — no Xcode needed
1. Repo → Settings → Pages → Source: Deploy from a branch → `main` / `/docs` → Save.
2. Open https://daiduong0106-dev.github.io/Deep-Work/ in Safari → Share → Add to Home Screen.
3. Tap START / STOP.

**One-tap Work mode (Shortcuts app):**
- "Work Start": *Set Focus* → Work → Turn On, then *Open URL* `https://daiduong0106-dev.github.io/Deep-Work/#start`
- "Work Stop": *Open URL* `https://daiduong0106-dev.github.io/Deep-Work/#stop`, then *Set Focus* → Turn Off
- Put the shortcuts on the Home Screen or assign them to the Action Button.

## 2. Native iOS app (SwiftUI + widget) — needs Xcode
1. `brew install xcodegen`, then `xcodegen` in the repo root to generate `WorkTimer.xcodeproj`.
2. Open it in Xcode, pick your Team under Signing & Capabilities for both targets, connect the iPhone, Run.
3. Add the "Work Timer" widget to the Home Screen for one-tap Start/Stop.
4. Work mode: create Shortcuts "Work Start" (*Set Focus* On + *Start work*) and "Work Stop" (*Stop work* + *Set Focus* Off).

If the bundle id or App Group is taken, replace `jun1stic` in `project.yml` and `Shared/WorkStore.swift`.
