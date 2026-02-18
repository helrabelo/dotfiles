Check the notarization status for all Helsky Labs macOS apps using Apple's notarytool.

Read the credentials from `/Users/helrabelo/code/helsky-labs/.env.notarization` to get the Apple ID, Team ID, and app-specific passwords.

For each app that has an app-specific password configured (non-empty, non-commented), run:

```
xcrun notarytool history --apple-id "$APPLE_ID" --team-id "$APPLE_TEAM_ID" --password "$APP_PASSWORD"
```

Then summarize the results in a table showing:
- App name
- Most recent submission date
- Status (Accepted / In Progress / Invalid / etc.)
- Submission ID

If any submission has status "Accepted", also pull the log using `xcrun notarytool log <id>` and confirm there are no issues.

If any submission has status "Invalid", pull the log and show what went wrong.

Current apps to check:
- DropVox (password key: DROPVOX_APP_SPECIFIC_PASSWORD)
- TokenCentric (password key: TOKENCENTRIC_APP_SPECIFIC_PASSWORD)

As more apps are added to .env.notarization, include them automatically.
