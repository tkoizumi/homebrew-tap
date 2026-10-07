cask "dsh-remote" do
  version "0.1.7"

  on_macos do
    on_arm do
      sha256 "7959d58c2461480c03eb3ccb5cba99f5c81093dcb2b6b0902e09146e546efda0"
      url "https://github.com/tkoizumi/dsh-remote/releases/download/v#{version}/dsh-remote_#{version}_darwin_arm64.tar.gz"
    end
    on_intel do
      sha256 "a0547f080520da1cbbecd0b5616d59b0f51312bf8326f7945e05671e4599f4e0"
      url "https://github.com/tkoizumi/dsh-remote/releases/download/v#{version}/dsh-remote_#{version}_darwin_amd64.tar.gz"
    end
  end
  on_linux do
    on_arm do
      sha256 "e5d0fd2e70ef1a2915fe354649504a59a909d3996cdd4bccc4274a2c40665818"
      url "https://github.com/tkoizumi/dsh-remote/releases/download/v#{version}/dsh-remote_#{version}_linux_arm64.tar.gz"
    end
    on_intel do
      sha256 "cd2b4c310372c4dc5dc1ac9ccaadb09f178658bac42a2e234f7c244bc93c453e"
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
