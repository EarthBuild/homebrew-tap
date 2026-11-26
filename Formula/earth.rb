class Earth < Formula
  desc "Build automation tool for the container era"
  homepage "https://github.com/EarthBuild/earthbuild"
  version "0.8.20"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/EarthBuild/earthbuild/releases/download/v#{version}/earth-darwin-arm64"
      sha256 "44326ae9c9d3add654c9bfc0f8a32378397c251836fb885353c6c439a15a9a74"
    end
    on_intel do
      url "https://github.com/EarthBuild/earthbuild/releases/download/v#{version}/earth-darwin-amd64"
      sha256 "5eb154ad807144e6227a66fdf50511b39b8547459fb1190e6b85a582e601d8ee"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/EarthBuild/earthbuild/releases/download/v#{version}/earth-linux-arm64"
      sha256 "b78d374ee5c481806f0025ae2a088231689b1c41c1a8633b4c0ed1acd57a9d1b"
    end
    on_intel do
      url "https://github.com/EarthBuild/earthbuild/releases/download/v#{version}/earth-linux-amd64"
      sha256 "e85ac1221f3297f0a85e5b06fd3956d624b734973c2e4313183e8d61ae67dac1"
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
