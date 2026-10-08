cask "dsh-remote" do
  version "0.1.10"

  on_macos do
    on_arm do
      sha256 "38ef49002fe29874cf42a620588c9e241576557c76f916fcca4f5f0abd8a77ec"
      url "https://github.com/tkoizumi/dsh-remote/releases/download/v#{version}/dsh-remote_#{version}_darwin_arm64.tar.gz"
    end
    on_intel do
      sha256 "9ac402b414585fb89045744389d68604258701d7514f92f26bb68d41ff264499"
      url "https://github.com/tkoizumi/dsh-remote/releases/download/v#{version}/dsh-remote_#{version}_darwin_amd64.tar.gz"
    end
  end
  on_linux do
    on_arm do
      sha256 "c39e6f26fc2621934b8df083da9d561f630c36103d79ebf8a37288c96a0a95fc"
      url "https://github.com/tkoizumi/dsh-remote/releases/download/v#{version}/dsh-remote_#{version}_linux_arm64.tar.gz"
    end
    on_intel do
      sha256 "16fc6761229dee13624a9a584b4b7a3938bcf03dd852299598ab5cfbb42b5532"
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
