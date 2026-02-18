# Release App

Guide through the release workflow for a Helsky Labs macOS app.

## Input

$ARGUMENTS

Provide:
- App name (e.g., `DropVox`, `TokenCentric`, `Days as Numbers`)
- Version number (e.g., `1.2.0`) or `bump` for auto-increment

---

## Phase 1: Pre-Release Checks

1. **Identify the project**
   - Locate the project in `/Users/helrabelo/code/helsky-labs/`
   - Read current version from project config (Info.plist, Package.swift, or Xcode project)
   - Verify we're on the correct branch (usually `main`)

2. **Version management**
   - If `bump` specified, determine next version (patch by default)
   - Show current version -> new version for confirmation
   - Do NOT update version files without user approval

3. **Check git status**
   - Ensure working directory is clean
   - Ensure branch is up to date with remote

---

## Phase 2: Build Verification

1. **List build steps** for the user to run locally:
   - Clean build folder
   - Archive build
   - Expected build command (e.g., `xcodebuild archive ...`)

2. **Report what to verify:**
   - Build succeeds without warnings
   - All tests pass
   - App launches and basic functionality works

---

## Phase 3: Release Notes

1. **Gather changes since last release**
   - Find last release tag: `git tag --sort=-version:refname | head -5`
   - Get commit log since last tag: `git log {last-tag}...HEAD --oneline`

2. **Generate release notes**
   - Categorize into: New Features, Improvements, Bug Fixes
   - Write user-facing descriptions (not commit messages)
   - Provide both a full version and a short App Store version

```markdown
### Release Notes: {App Name} v{version}

**What's New:**
- {Feature/improvement descriptions}

**Bug Fixes:**
- {Fix descriptions}
```

---

## Phase 4: Release Checklist

Provide a checklist for the user:

```markdown
## Release Checklist: {App Name} v{version}

### Pre-Release
- [ ] Version bumped in project
- [ ] All tests passing
- [ ] Clean build succeeds
- [ ] Release notes written

### Build & Sign
- [ ] Archive build created
- [ ] Code signed with Developer ID
- [ ] Notarized with Apple (`xcrun notarytool submit`)
- [ ] Stapled (`xcrun stapler staple`)

### Distribute
- [ ] DMG/ZIP created
- [ ] Uploaded to App Store Connect (if App Store)
- [ ] Updated download link on website (if direct)
- [ ] Git tag created: `v{version}`

### Post-Release
- [ ] Verified notarization status (`/check-notarization`)
- [ ] Smoke tested downloaded build
- [ ] Updated changelog
```

---

## Phase 5: Deliverables

1. **Release notes** -- ready for App Store / website
2. **Git tag command** -- `git tag -a v{version} -m "{App} v{version}"`
3. **Checklist** -- copy-paste ready

---

## Reminders

- Do NOT run build commands -- ask the user to build locally
- Do NOT push tags -- provide the command for the user
- Do NOT modify version files without explicit approval
- Pair with `/check-notarization` for post-release verification
