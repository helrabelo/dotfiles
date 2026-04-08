# Mac Mini Setup Guide — Step by Step

This is a manual walkthrough for setting up the Mac Mini M4 as your AyeEye workstation.
Do these steps in order. Each section depends on the previous one.

---

## Phase 1: First Boot & Apple ID

When you first turn on the Mac Mini:

1. **Language/Region**: English, United States (or your preference)
2. **Connect to Wi-Fi**: Same network as your MacBook
3. **Apple ID**: Sign in with your Apple ID (same as MacBook)
   - This enables iCloud, Universal Clipboard, AirDrop, Universal Control
4. **Create your user account**:
   - **Username: `helrabelo`** — this is critical. All dotfiles paths assume this username
   - Use the same password as your MacBook (or whatever you prefer)
5. **Skip Migration Assistant** — we're doing a clean setup, not a clone
6. **Enable FileVault** (disk encryption) — yes
7. **Enable Location Services** — your call
8. **Dark Mode** — the script sets this, but pick it during setup too

---

## Phase 2: System Settings (Do This First)

Open **System Settings** and configure:

### Display
- Connect the Dell 34" via USB-C
- Set resolution to your preferred scaled option
- If using both the Dell AND the MacBook screen, arrange them in Display settings

### Keyboard
- Key repeat rate: Fast
- Delay until repeat: Short
- Press fn key to: Change Input Source (or your preference)

### Trackpad (if using Apple Trackpad)
- Tap to Click: ON
- Tracking Speed: your preference
- Three Finger Drag: System Settings > Accessibility > Pointer Control > Trackpad Options > Dragging Style > Three Finger Drag

### General > Sharing
- Set Computer Name to something recognizable (e.g., "Hel's Mac Mini")
- This is how it appears on AirDrop and your network

### General > AirDrop & Handoff
- AirDrop: Everyone (or Contacts Only)
- Allow Handoff: ON

### Focus
- Create an "AyeEye" focus mode
- **Share Across Devices: OFF** — you don't want Mini focus modes affecting your MacBook

---

## Phase 3: Install Homebrew

Open **Terminal.app** (we'll install Ghostty later):

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# IMPORTANT: After install, Homebrew tells you to run two commands.
# They look like this (copy the EXACT output from your terminal):
echo >> /Users/helrabelo/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/helrabelo/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Verify
brew --version
```

---

## Phase 4: Install Git & Clone Dotfiles

```bash
# Git comes with Xcode CLI tools — this will prompt to install them
git --version
# Click "Install" when the dialog appears. Wait for it to finish.

# Clone your dotfiles
mkdir -p ~/code
cd ~/code
git clone git@github.com:helrabelo/dotfiles.git
```

**If git clone fails** (no SSH key yet), use HTTPS first:
```bash
git clone https://github.com/helrabelo/dotfiles.git
```

---

## Phase 5: SSH Keys

You need SSH keys for GitHub, and potentially for work repos. **Do NOT generate new keys** — copy your existing ones from the MacBook.

### Option A: AirDrop (easiest)
1. On **MacBook**: Open Finder, go to `~/.ssh/`
   - Press `Cmd+Shift+G`, type `~/.ssh/`, press Enter
2. Select the key files you need:
   - `helrabelo@gmail.com` + `helrabelo@gmail.com.pub` (GitHub personal)
   - `config` (SSH config with host aliases)
3. Right-click > Share > AirDrop > send to Mac Mini
4. On **Mac Mini**: Move files from Downloads to `~/.ssh/`:
   ```bash
   mkdir -p ~/.ssh
   mv ~/Downloads/helrabelo@gmail.com ~/.ssh/
   mv ~/Downloads/helrabelo@gmail.com.pub ~/.ssh/
   mv ~/Downloads/config ~/.ssh/
   chmod 700 ~/.ssh
   chmod 600 ~/.ssh/helrabelo@gmail.com
   chmod 644 ~/.ssh/helrabelo@gmail.com.pub
   ```

### Option B: scp (from MacBook terminal)
```bash
# On MacBook — find Mac Mini IP first:
# System Settings > General > Sharing > shows the local hostname
# Or on Mac Mini: ifconfig | grep "inet " | grep -v 127.0.0.1

scp ~/.ssh/helrabelo@gmail.com helrabelo@<mini-ip>:~/.ssh/
scp ~/.ssh/helrabelo@gmail.com.pub helrabelo@<mini-ip>:~/.ssh/
scp ~/.ssh/config helrabelo@<mini-ip>:~/.ssh/
```

### After copying keys:
```bash
# On Mac Mini
chmod 700 ~/.ssh
chmod 600 ~/.ssh/helrabelo@gmail.com
chmod 644 ~/.ssh/helrabelo@gmail.com.pub

# Add to ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/helrabelo@gmail.com

# Test GitHub connection
ssh -T git@github.com
# Should say: "Hi helrabelo! You've successfully authenticated..."
```

### If you cloned dotfiles via HTTPS earlier, switch to SSH:
```bash
cd ~/code/dotfiles
git remote set-url origin git@github.com:helrabelo/dotfiles.git
```

---

## Phase 6: Run the Setup Script

```bash
cd ~/code/dotfiles
bash mac-mini-setup.sh
```

This installs everything automated: Homebrew packages, Oh My Zsh, nvm, Node, Python
tooling, Ruby, Claude Code, symlinks all dotfiles, sets macOS preferences.

**Watch for errors.** If something fails, the script stops (`set -e`). Fix the issue
and re-run — it's idempotent (safe to run multiple times).

After it finishes:
```bash
# Restart your shell to pick up all changes
exec zsh
```

---

## Phase 7: Install GUI Apps

These can't be automated (App Store, DMGs, or license-gated):

### From App Store
- **1Password** — sign in with your 1Password account
- **Slack** — sign in to AyeEye workspace (and Planetary if needed)
- **Xcode** — only if you need it for AyeEye (large download, skip if not needed)

### Download & Install
| App | URL | Notes |
|-----|-----|-------|
| **Ghostty** | https://ghostty.org | Your terminal. Config is already symlinked. |
| **VS Code** | https://code.visualstudio.com | Or Cursor if you prefer |
| **Logi Options+** | https://www.logitech.com/en-us/software/logi-options-plus.html | For MX keyboard/mouse |
| **Rectangle Pro** | https://rectangleapp.com/pro | Window management |
| **Alfred 5** | https://www.alfredapp.com | Spotlight replacement |
| **Obsidian** | https://obsidian.md | For Helsky Vault (if syncing) |
| **1Password (desktop)** | https://1password.com/downloads | Browser extension + SSH agent |

### 1Password Setup (Important)
1. Install 1Password from App Store
2. Sign in with your account
3. **Enable the SSH Agent**:
   - 1Password > Settings > Developer
   - Turn on "Use the SSH Agent"
   - Turn on "Integrate with 1Password CLI"
   - This lets 1Password manage your SSH keys and auto-fill `git` auth
4. Install the browser extension for Chrome/Firefox

---

## Phase 8: Authentication

Open **Ghostty** (it should be configured already from the dotfiles).

```bash
# GitHub CLI
brew install gh
gh auth login
# Choose: GitHub.com > SSH > your key > Login with a web browser

# Claude Code
claude
# Follow the auth prompts — it will open a browser to sign in

# npm (if AyeEye needs private packages)
npm login

# Verify git identity
git config --global user.name
git config --global user.email
# Should show "hel rabelo" and "helrabelo@gmail.com"
# (This comes from the symlinked .gitconfig)
```

---

## Phase 9: Clone AyeEye Project

```bash
cd ~/code/work
git clone <ayeeye-repo-url> ayeeye
cd ayeeye

# Install dependencies
npm ci  # or pnpm install, whatever AyeEye uses

# Check for project-level CLAUDE.md
cat CLAUDE.md

# Verify it builds
npm run build  # or equivalent
```

---

## Phase 10: Logitech MX Setup

### Keyboard (MX Keys)
1. Open **Logi Options+**
2. Click "+ Add Device"
3. On the keyboard, press the **Easy-Switch button** (1/2/3 at top)
   - Pick **Channel 1** for the Mac Mini
   - Channel 2 stays paired to the MacBook
4. Hold the channel button for 3 seconds to enter pairing mode
5. Logi Options+ should detect it — follow the pairing flow

### Mouse (MX Master)
1. Same process — flip the mouse, press the Easy-Switch button
2. **Channel 1** = Mac Mini, **Channel 2** = MacBook
3. Hold the channel button for 3 seconds to pair

### Logitech Flow (optional — cursor follows across screens)
1. In Logi Options+, go to **Flow** settings
2. Enable Flow on **both** Macs (need Logi Options+ on both)
3. Both must be on the same Wi-Fi network
4. Arrange screens to match your physical desk layout
5. Your cursor will seamlessly move between Macs at the screen edge

**Note:** If you use a VPN for AyeEye or Planetary, Logitech Flow still works
(unlike Universal Control which breaks with VPN).

---

## Phase 11: Display Configuration

### Single Monitor (Dell 34") — Switching Between Macs
1. Connect Mac Mini to Dell via USB-C (direct)
2. Connect MacBook to Dell via iVANKY dock (or second USB-C input)
3. Use the Dell's **input switching** (button on monitor or Dell Display Manager)
4. Combined with MX Easy-Switch, your workflow is:
   - Press Channel 1 on keyboard → press Dell input button → you're on Mini
   - Press Channel 2 on keyboard → press Dell input button → you're on MacBook

### Dual Screen Setup (Dell + MacBook built-in)
- Keep both Macs connected
- Use Logitech Flow or Universal Control to share keyboard/mouse
- Dell 34" = active work machine, MacBook screen = Slack/reference

### Universal Control (Alternative to Logitech Flow)
1. On **both** Macs: System Settings > Displays > Advanced
2. Enable "Allow your pointer and keyboard to move between any nearby Mac or iPad"
3. Both Macs must be on the same Apple ID, same Wi-Fi, Bluetooth on

---

## Phase 12: VS Code Settings Sync

VS Code has built-in settings sync:

1. Open VS Code on Mac Mini
2. Click the person icon (bottom left) > "Turn on Settings Sync"
3. Sign in with your GitHub account (same as MacBook)
4. Choose what to sync: Settings, Keybindings, Extensions, UI State
5. All your VS Code extensions and preferences will download automatically

This means your VS Code environment is identical on both machines without
any manual configuration.

---

## Phase 13: Final Verification Checklist

Run through this on the Mac Mini to confirm everything works:

```bash
# Shell & tools
echo $SHELL                    # /bin/zsh
git --version                  # git 2.x
node --version                 # v22.x
npm --version                  # 10.x
python3 --version              # 3.12.x
go version                     # go1.24.x
ruby --version                 # 3.4.1
claude --version               # Claude Code 2.x
gh auth status                 # Logged in to github.com

# Dotfiles symlinks
ls -la ~/.zshrc                # -> ~/code/dotfiles/zsh/.zshrc
ls -la ~/.claude               # -> ~/code/dotfiles/claude/.claude
ls -la ~/.gitconfig            # -> ~/code/dotfiles/git/.gitconfig
ls -la ~/.config/ghostty/config # -> ~/code/dotfiles/ghostty/config

# Claude Code
claude                         # Should open without asking to auth
# Type /help to verify commands are loaded

# SSH
ssh -T git@github.com          # Hi helrabelo!

# AyeEye project
cd ~/code/work/ayeeye
npm run dev                    # Should start dev server
```

---

## Storage Management (256GB is tight)

The Mac Mini only has 256GB. Keep it lean:

- **Don't install Xcode** unless you absolutely need it (15+ GB)
- **Don't clone repos you won't use** on the Mini (Planetary repos stay on MacBook)
- **Clean node_modules** regularly: `npx npkill` finds and deletes them
- **Use OrbStack** instead of Docker Desktop (much lighter on disk)
- **Monitor disk**: `df -h /` or install `ncdu` (`brew install ncdu`)
- If AyeEye grows, get an external USB-C SSD for overflow

---

## Daily Workflow

```
MORNING — AyeEye
  1. Sit down, MX keyboard/mouse already on Channel 1 (Mini)
  2. Dell 34" on Mini input
  3. Open Ghostty, cd ~/code/work/ayeeye, start working
  4. MacBook lid open = Slack/comms on built-in screen (optional)

SWITCH — Lunch / Transition
  1. Press Channel 2 on MX keyboard + mouse
  2. Switch Dell input to MacBook
  3. (2 seconds total)

AFTERNOON — Planetary + Currents
  1. MacBook on Dell 34"
  2. Mac Mini stays on, or sleep it
  3. If you need something from Mini, just switch back
```

---

## Keeping Dotfiles in Sync

When you change a config on either machine:

```bash
cd ~/code/dotfiles
git add -A
git commit -m "chore: update <what changed>"
git push

# On the other machine:
cd ~/code/dotfiles
git pull
```

The symlinks mean changes take effect immediately after pull — no re-running setup.sh
unless you add new files that need new symlinks.
