# tkoizumi/homebrew-tap

Personal Homebrew tap.

## Install

```bash
brew tap tkoizumi/tap
brew install dsh-remote
```

Add `--cask` if you prefer to be explicit.

## Casks

### dsh-remote

One stable Tailscale URL for a locally running DeepSeek Harness (`dsh web`).
Installs a prebuilt static binary — no Go toolchain or build step — for macOS
(Intel and Apple silicon) and Linux (including Ubuntu), on both amd64 and arm64.

```bash
dsh-remote start     # launch DSH, the proxy, and Tailscale Serve; prints a QR code
dsh-remote status    # what is running
dsh-remote stop      # stop everything and restore the previous Serve mapping
dsh-remote qr        # print the QR code again
dsh-remote install   # systemd user service (Linux) so it survives reboot
```

Requires Node.js/npm (for `npx`) and an authenticated Tailscale. Because
`tailscale serve` needs root or an operator, run this once:

```bash
sudo tailscale set --operator=$USER
```

Funnel is never used: the service stays inside your tailnet.

### otter

Runtime for reliable Python jobs. Published as a cask with prebuilt release
binaries.
