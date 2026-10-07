cask "dsh-remote" do
  version "0.1.5"

  on_macos do
    on_arm do
      sha256 "fa257a426070ed589c8b4125cc220c9ad53dc6701688e33709dbfc2653f1de68"
      url "https://github.com/tkoizumi/dsh-remote/releases/download/v#{version}/dsh-remote_#{version}_darwin_arm64.tar.gz"
    end
    on_intel do
      sha256 "13317f822f66027b100bc613dca182e74bad26a77221cee23fd3ae7e1bd369eb"
      url "https://github.com/tkoizumi/dsh-remote/releases/download/v#{version}/dsh-remote_#{version}_darwin_amd64.tar.gz"
    end
  end
  on_linux do
    on_arm do
      sha256 "bcdbc53bfa7ed6f8710b7f5ec0bd088cc4d5da6e822319be9875ebd82fef651c"
      url "https://github.com/tkoizumi/dsh-remote/releases/download/v#{version}/dsh-remote_#{version}_linux_arm64.tar.gz"
    end
    on_intel do
      sha256 "52e34252f38103176124629ecaabe16d42993966d1e4e3621fbae7ac2cc35618"
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
    if system_command("/usr/bin/xattr", args: ["-h"]).exit_status == 0
      system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "#{staged_path}/dsh-remote"]
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
