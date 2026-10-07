cask "dsh-remote" do
  version "0.1.6"

  on_macos do
    on_arm do
      sha256 "e87f41bf31b397cbca2d36361d310ae6e7a42843006419ffd4fde4c21c4dbc04"
      url "https://github.com/tkoizumi/dsh-remote/releases/download/v#{version}/dsh-remote_#{version}_darwin_arm64.tar.gz"
    end
    on_intel do
      sha256 "54863be13a87953a299fafc4346542cea44446e484728b4a45fa71ca45db5b24"
      url "https://github.com/tkoizumi/dsh-remote/releases/download/v#{version}/dsh-remote_#{version}_darwin_amd64.tar.gz"
    end
  end
  on_linux do
    on_arm do
      sha256 "1e1ad61e065bc7fb30a09229d902c9b1fa589ca08f68aae7b5f481bfe7ec511e"
      url "https://github.com/tkoizumi/dsh-remote/releases/download/v#{version}/dsh-remote_#{version}_linux_arm64.tar.gz"
    end
    on_intel do
      sha256 "0cd10372ee7837b7abf8bc6e13f425900110b68068037977bdedd8d85976fba4"
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
