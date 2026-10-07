cask "dsh-remote" do
  version "0.1.8"

  on_macos do
    on_arm do
      sha256 "2a28d92c0471ad1d0ee66cb37cd6ab922dd60cbd87f67c5b497b6e522e58cd65"
      url "https://github.com/tkoizumi/dsh-remote/releases/download/v#{version}/dsh-remote_#{version}_darwin_arm64.tar.gz"
    end
    on_intel do
      sha256 "c3af03fe30aaf329788aa3eec5924a7c88cd6434469930d7b298edbdef3908e3"
      url "https://github.com/tkoizumi/dsh-remote/releases/download/v#{version}/dsh-remote_#{version}_darwin_amd64.tar.gz"
    end
  end
  on_linux do
    on_arm do
      sha256 "b83446cd49a7972084ef9da0b50090a119d0510eb3e82b1ec0ce61e5eef496f3"
      url "https://github.com/tkoizumi/dsh-remote/releases/download/v#{version}/dsh-remote_#{version}_linux_arm64.tar.gz"
    end
    on_intel do
      sha256 "146563e31143b688d2ce1c891113ce35c01bb0a3a5e12ddecadcc10b15b1c751"
      url "https://github.com/tkoizumi/dsh-remote/releases/download/v#{version}/dsh-remote_#{version}_linux_amd64.tar.gz"
    end
  end

  name "dsh-remote"
  desc "One stable Tailscale URL for a locally running DeepSeek Harness"
  homepage "https://github.com/tkoizumi/dsh-remote"

  livecheck do
    skip "Auto-generated on release."
  end

  binary "dsh-remote"

  postflight do
    # macOS only: clear the quarantine attribute so Gatekeeper does not block
    # the binary. This mirrors Homebrew's OS.mac? check (RbConfig is core Ruby,
    # so it cannot fail on constant lookup), and the cask DSL's system_command
    # raises on failure, hence must_succeed: false -- a missing attribute, or an
    # absent /usr/bin/xattr on Linux, must never fail the install.
    xattr = "/usr/bin/xattr"
    if RbConfig::CONFIG["host_os"].include?("darwin") && File.executable?(xattr)
      system_command xattr,
                     args:         ["-dr", "com.apple.quarantine", "#{staged_path}/dsh-remote"],
                     must_succeed: false
    end
  end

  # No zap stanza required

  caveats <<~EOS
    dsh-remote launches DeepSeek Harness through npx, so Node.js/npm must be
    on your PATH. It also needs an authenticated Tailscale, and
    `tailscale serve` requires root or an operator. Enable that once:

      sudo tailscale set --operator=$USER

    Then start the stable URL and scan the QR code from your phone:

      dsh-remote start

    To keep it running across reboots on Linux, install the user service:

      dsh-remote install
      sudo loginctl enable-linger $USER
  EOS
end
