class IrcdIrc2 < Formula
  desc "Original IRC server daemon"
  homepage "http://www.irc.org/"
  url "http://www.irc.org/ftp/irc/server/irc2.11.2p3.tgz"
  version "2.11.2p3"
  sha256 "be94051845f9be7da0e558699c4af7963af7e647745d339351985a697eca2c81"

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "ed3eac7c4635484c94d12579948947bff1eb6a671846fcd9273dd5ed226759fa"
    sha256 big_sur:       "855bb8b0254ee0f410d6bdf3ad8479900f39f0ad120145485d9bdbe146f7a399"
    sha256 catalina:      "35ae4defa513772b1e1b5b0400976d49cb213818a2272a9760a3da3a7e8c0765"
    sha256 mojave:        "e0522b8f4eb95b0d60527e136e69474b4e9fe6f2b77a12919d5a6dd76bb2a4fa"
    sha256 x86_64_linux:  "0e9df9d4035289f08ec4c856aca8ac20ca0b2cc100a916f3b5eab3959306c5d7" # linuxbrew-core
  end

  def default_ircd_conf
    <<~EOS
      # M-Line
      M:irc.localhost::Darwin ircd default configuration::000A

      # A-Line
      A:This is Darwin's default ircd configurations:Please edit your /usr/local/etc/ircd.conf file:Contact <root@localhost> for questions::ExampleNet

      # Y-Lines
      Y:1:90::100:512000:5.5:100.100
      Y:2:90::300:512000:5.5:250.250

      # I-Line
      I:*:::0:1
      I:127.0.0.1/32:::0:1

      # P-Line
      P::::6667:
    EOS
  end

  conflicts_with "ircd-hybrid", because: "both install `ircd` binaries"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--mandir=#{man}",
                          "CFLAGS=-DRLIMIT_FDMAX=0"

    build_dir = `./support/config.guess`.chomp

    # Disable netsplit detection. In a netsplit, joins to new channels do not
    # give chanop status.
    inreplace "#{build_dir}/config.h", /#define DEFAULT_SPLIT_USERS\s+65000/,
      "#define DEFAULT_SPLIT_USERS 0"
    inreplace "#{build_dir}/config.h", /#define DEFAULT_SPLIT_SERVERS\s+80/,
      "#define DEFAULT_SPLIT_SERVERS 0"

    # The directory is something like `i686-apple-darwin13.0.2'
    system "make", "install", "-C", build_dir

    (etc/"ircd.conf").write default_ircd_conf
  end

  service do
    run [opt_sbin/"ircd", "-t"]
    keep_alive false
    working_dir HOMEBREW_PREFIX
    error_log_path var/"ircd.log"
  end

  test do
    system "#{sbin}/ircd", "-version"
  end
end
