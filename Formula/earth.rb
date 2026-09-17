class Earth < Formula
  desc "Build automation tool for the container era"
  homepage "https://github.com/EarthBuild/earthbuild"
  version "0.8.19"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/EarthBuild/earthbuild/releases/download/v#{version}/earth-darwin-arm64"
      sha256 "c485ba6ffbd9de9574deb2fd07d3b9ba1e04471c9d21f7074863ccfe8d07901c"
    end
    on_intel do
      url "https://github.com/EarthBuild/earthbuild/releases/download/v#{version}/earth-darwin-amd64"
      sha256 "9b45d3ece50e287d1711041ce7113cb045c03b629f94df177bf74415e7de8088"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/EarthBuild/earthbuild/releases/download/v#{version}/earth-linux-arm64"
      sha256 "46cc0fc77357a805e161e188bd37ea518fc4c4ec53262f926159efdd18d2f2dd"
    end
    on_intel do
      url "https://github.com/EarthBuild/earthbuild/releases/download/v#{version}/earth-linux-amd64"
      sha256 "485679af8d21d5a87daaf3780e58ca6e7dd85f7710d6f51da76e17bb28261fd1"
    end
  end

  def install
    binary_name = if OS.mac?
      Hardware::CPU.arm? ? "earth-darwin-arm64" : "earth-darwin-amd64"
    else
      Hardware::CPU.arm? ? "earth-linux-arm64" : "earth-linux-amd64"
    end

    chmod 0755, binary_name
    bin.install binary_name => "earth"
    bin.install_symlink "earth" => "earthly"

    generate_completions_from_executable(bin/"earth", "bootstrap", "--source", shells: [:bash, :zsh])
  end

  def caveats
    <<~EOS
      EarthBuild requires a container runtime to function.
      If you don't have one, you can install Docker or Podman:
        brew install --cask docker
        OR
        brew install podman
    EOS
  end

  test do
    (testpath / "Earthfile").write <<~EOS
      VERSION 0.8
      mytesttarget:
      \tRUN echo Homebrew
    EOS
    output = shell_output("#{bin}/earth ls")
    assert_match "+mytesttarget", output
  end
end
