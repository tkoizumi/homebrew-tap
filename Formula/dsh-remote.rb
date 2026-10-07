class DshRemote < Formula
  desc "One stable Tailscale URL for a locally running DeepSeek Harness"
  homepage "https://github.com/tkoizumi/dsh-remote"
  url "https://github.com/tkoizumi/dsh-remote/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "9ccfa72c9cfd6e7bb920a5d9b3c977eb7dadd900b04b777297d4e45f4755ac62"
  license "MIT"
  head "https://github.com/tkoizumi/dsh-remote.git", branch: "main"

  depends_on "go" => :build
  depends_on "node"

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dsh-remote"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dsh-remote version")
  end

  caveats <<~EOS
    dsh-remote launches `dsh web`, so DeepSeek Harness is fetched on demand
    via npx on first start.

    It also needs Tailscale, and `tailscale serve` requires root or an
    operator. Enable that once:

      sudo tailscale set --operator=$USER

    Then start the stable URL and scan the QR code from your phone:

      dsh-remote start

    To keep it running across reboots, install the user service:

      dsh-remote install
      sudo loginctl enable-linger $USER
  EOS
end
