class V8 < Formula
  desc "Google's JavaScript engine"
  homepage "https://github.com/v8/v8/wiki"
  # Track V8 version from Chrome stable: https://omahaproxy.appspot.com
  url "https://github.com/v8/v8/archive/9.3.345.16.tar.gz"
  sha256 "5be8271738c2da80a89b384ad1fdf8004c1f4d077b85d0a20e924845fb883f2d"
  license "BSD-3-Clause"

  livecheck do
    url "https://omahaproxy.appspot.com/all.json?os=mac&channel=stable"
    regex(/"v8_version": "v?(\d+(?:\.\d+)+)"/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "4ee6250d3b9aa24e105b89c7fab0b15bfe862a75f5d725570f79101852343b56"
    sha256 cellar: :any,                 big_sur:       "fd99ff5ea0e1d8b84bd00991882ed286453c47161cf624b9399c4db09427f127"
    sha256 cellar: :any,                 catalina:      "a7187a1acecba9d9290861411b78d41105e865fd2bac610dac4e74a8f1fe52f5"
    sha256 cellar: :any,                 mojave:        "d0fbae8725488685bfb16f14de16de33eea44eb0ae152c1de65b6cab3c6c6141"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aece5b13f34c53bfbc4bac26fa92023b93030cabbae367b5ac75d4c788c55ad0" # linuxbrew-core
  end

  depends_on "ninja" => :build
  depends_on "python@3.9" => :build

  on_macos do
    depends_on "llvm" => :build
    depends_on xcode: ["10.0", :build] # required by v8
  end

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gcc"
    depends_on "glib"
  end

  fails_with gcc: "5"

  # Look up the correct resource revisions in the DEP file of the specific releases tag
  # e.g. for CIPD dependency gn: https://github.com/v8/v8/blob/9.3.345.16/DEPS#L52
  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
        revision: "24e2f7df92641de0351a96096fb2c490b2436bb8"
  end

  # e.g.: https://github.com/v8/v8/blob/9.3.345.16/DEPS#L93 for the revision of trace event for v8 9.2.230.29
  resource "v8/base/trace_event/common" do
    url "https://chromium.googlesource.com/chromium/src/base/trace_event/common.git",
        revision: "d5bb24e5d9802c8c917fcaa4375d5239a586c168"
  end

  resource "v8/build" do
    url "https://chromium.googlesource.com/chromium/src/build.git",
        revision: "2d999384c270a340f592cce0a0fb3f8f94c15290"
  end

  resource "v8/third_party/googletest/src" do
    url "https://chromium.googlesource.com/external/github.com/google/googletest.git",
        revision: "4ec4cd23f486bf70efcc5d2caa40f24368f752e3"
  end

  resource "v8/third_party/icu" do
    url "https://chromium.googlesource.com/chromium/deps/icu.git",
        revision: "b9dfc58bf9b02ea0365509244aca13841322feb0"
  end

  resource "v8/third_party/jinja2" do
    url "https://chromium.googlesource.com/chromium/src/third_party/jinja2.git",
        revision: "7c54c1f227727e0c4c1d3dc19dd71cd601a2db95"
  end

  resource "v8/third_party/markupsafe" do
    url "https://chromium.googlesource.com/chromium/src/third_party/markupsafe.git",
        revision: "1b882ef6372b58bfd55a3285f37ed801be9137cd"
  end

  resource "v8/third_party/zlib" do
    url "https://chromium.googlesource.com/chromium/src/third_party/zlib.git",
        revision: "dfbc590f5855bc2765256a743cad0abc56330a30"
  end

  def install
    (buildpath/"build").install resource("v8/build")
    (buildpath/"third_party/jinja2").install resource("v8/third_party/jinja2")
    (buildpath/"third_party/markupsafe").install resource("v8/third_party/markupsafe")
    (buildpath/"third_party/googletest/src").install resource("v8/third_party/googletest/src")
    (buildpath/"base/trace_event/common").install resource("v8/base/trace_event/common")
    (buildpath/"third_party/icu").install resource("v8/third_party/icu")
    (buildpath/"third_party/zlib").install resource("v8/third_party/zlib")

    # Build gn from source and add it to the PATH
    (buildpath/"gn").install resource("gn")
    cd "gn" do
      system "python3", "build/gen.py"
      system "ninja", "-C", "out/", "gn"
    end
    ENV.prepend_path "PATH", buildpath/"gn/out"

    # create gclient_args.gni
    (buildpath/"build/config/gclient_args.gni").write <<~EOS
      declare_args() {
        checkout_google_benchmark = false
      }
    EOS

    # setup gn args
    gn_args = {
      is_debug:                     false,
      is_component_build:           true,
      v8_use_external_startup_data: false,
      v8_enable_i18n_support:       true, # enables i18n support with icu
      clang_base_path:              "\"#{Formula["llvm"].opt_prefix}\"", # uses Homebrew clang instead of Google clang
      clang_use_chrome_plugins:     false, # disable the usage of Google's custom clang plugins
      use_custom_libcxx:            false, # uses system libc++ instead of Google's custom one
      treat_warnings_as_errors:     false, # ignore not yet supported clang argument warnings
      use_lld:                      false, # https://github.com/Homebrew/homebrew-core/pull/84351#issuecomment-909621336
    }

    if OS.linux?
      gn_args[:is_clang] = false # use GCC on Linux
      gn_args[:use_sysroot] = false # don't use sysroot
      gn_args[:custom_toolchain] = "\"//build/toolchain/linux/unbundle:default\"" # uses system toolchain
      gn_args[:host_toolchain] = "\"//build/toolchain/linux/unbundle:default\"" # to respect passed LDFLAGS
      ENV["AR"] = DevelopmentTools.locate("ar")
      ENV["NM"] = DevelopmentTools.locate("nm")
      gn_args[:use_rbe] = false
    end

    # use clang from homebrew llvm formula, because the system clang is unreliable
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib # but link against system libc++
    # Make sure private libraries can be found from lib
    ENV.prepend "LDFLAGS", "-Wl,-rpath,#{libexec}"

    # Transform to args string
    gn_args_string = gn_args.map { |k, v| "#{k}=#{v}" }.join(" ")

    # Build with gn + ninja
    system "gn", "gen", "--args=#{gn_args_string}", "out.gn"
    system "ninja", "-j", ENV.make_jobs, "-C", "out.gn", "-v", "d8"

    # Install libraries and headers into libexec so d8 can find them, and into standard directories
    # so other packages can find them and they are linked into HOMEBREW_PREFIX
    (libexec/"include").install Dir["include/*"]
    include.install_symlink Dir[libexec/"include/*"]

    libexec.install Dir["out.gn/d8", "out.gn/icudtl.dat"]
    bin.write_exec_script libexec/"d8"

    libexec.install Dir["out.gn/#{shared_library("*")}"]
    lib.install_symlink Dir[libexec/shared_library("libv8*")]
    rm Dir[lib/"*.TOC"] if OS.linux? # Remove symlinks to .so.TOC text files
  end

  test do
    assert_equal "Hello World!", shell_output("#{bin}/d8 -e 'print(\"Hello World!\");'").chomp
    t = "#{bin}/d8 -e 'print(new Intl.DateTimeFormat(\"en-US\").format(new Date(\"2012-12-20T03:00:00\")));'"
    assert_match %r{12/\d{2}/2012}, shell_output(t).chomp

    (testpath/"test.cpp").write <<~EOS
      #include <libplatform/libplatform.h>
      #include <v8.h>
      int main(){
        static std::unique_ptr<v8::Platform> platform = v8::platform::NewDefaultPlatform();
        v8::V8::InitializePlatform(platform.get());
        v8::V8::Initialize();
        return 0;
      }
    EOS

    # link against installed libc++
    system ENV.cxx, "-std=c++14", "test.cpp",
      "-I#{include}",
      "-L#{lib}", "-lv8", "-lv8_libplatform"
  end
end
