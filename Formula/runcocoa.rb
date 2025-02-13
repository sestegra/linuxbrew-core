class Runcocoa < Formula
  desc "Tools to run Cocoa/Objective-C and C code from the command-line"
  homepage "https://github.com/michaeltyson/Commandline-Cocoa"
  url "https://github.com/michaeltyson/Commandline-Cocoa/archive/834f73b4b5d0d2be0d336c9869973f5f0db55949.tar.gz"
  version "20120108"
  sha256 "d90079efb92c8eef3c8e2c142683eb0c632ca61120c9e4a617bf9dac5362bf86"

  livecheck do
    skip "No version information available to check"
  end

  def install
    bin.install "runcocoa.sh" => "runcocoa"
    bin.install "runc.sh" => "runc"
  end

  test do
    string = "Hello world!"

    objc_code = "[[NSFileHandle fileHandleWithStandardOutput] " \
                "writeData:[@\"#{string}\" dataUsingEncoding:NSNEXTSTEPStringEncoding]]"
    objc_output = pipe_output("#{bin}/runcocoa", objc_code, 0)
    assert_match string, objc_output

    c_code = "printf(\"#{string}\");"
    c_output = pipe_output("#{bin}/runc", c_code, 0)
    assert_match string, c_output
  end
end
