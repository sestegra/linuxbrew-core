class Qt < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.3/single/qt-everywhere-src-6.1.3.tar.xz"
  sha256 "552342a81fa76967656b0301233b4b586d36967fad5cd110765347aebe07413c"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qt5.git", branch: "dev"

  # The first-party website doesn't make version information readily available,
  # so we check the `head` repository tags instead.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ab25be32463c05e36c5d666422c528f6400341e1d1cda03b7b3c4bf32c930e22"
    sha256 cellar: :any, big_sur:       "e5e7ee99f8ad14e2b39cfb8ead227ba60c1837d3bbf0c275d468c35bb9b3e882"
    sha256 cellar: :any, catalina:      "7ff0e85ccebd423a6796c68d80326d384626182360decf4f938f4ba9eb8bd524"
    sha256 cellar: :any, mojave:        "787c45fca83b0a31b3ee19e28d1fd2a000cd1ee9dabe02e7a4818c8ffcb03470"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "ninja"      => :build
  depends_on "pkg-config" => :build
  depends_on xcode: [:build, :test] if MacOS.version <= :mojave

  depends_on "assimp"
  depends_on "brotli"
  depends_on "dbus"
  depends_on "double-conversion"
  depends_on "freetype"
  depends_on "glib"
  depends_on "hunspell"
  depends_on "icu4c"
  depends_on "jasper"
  depends_on "jpeg"
  depends_on "libb2"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pcre2"
  depends_on "python@3.9"
  depends_on "sqlite"
  depends_on "webp"
  depends_on "zstd"

  uses_from_macos "cups"
  uses_from_macos "krb5"
  uses_from_macos "perl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "fontconfig"
    depends_on "glib"
    depends_on "gperf"
    depends_on "icu4c"
    depends_on "libproxy"
    depends_on "libxkbcommon"
    depends_on "libice"
    depends_on "libsm"
    depends_on "libxcomposite"
    depends_on "libdrm"
    depends_on "mesa"
    depends_on "pulseaudio"
    depends_on "sdl2"
    depends_on "systemd"
    depends_on "xcb-util"
    depends_on "xcb-util-image"
    depends_on "xcb-util-keysyms"
    depends_on "xcb-util-renderutil"
    depends_on "xcb-util-wm"
    depends_on "zstd"
    depends_on "wayland"
  end

  def install
    # FIXME: See https://bugreports.qt.io/browse/QTBUG-89559
    # and https://codereview.qt-project.org/c/qt/qtbase/+/327393
    # It is not friendly to Homebrew or macOS
    # because on macOS `/tmp` -> `/private/tmp`
    inreplace "qtbase/CMakeLists.txt", "FATAL_ERROR", ""

    config_args = %W[
      -release

      -prefix #{HOMEBREW_PREFIX}
      -extprefix #{prefix}
      -sysroot #{MacOS.sdk_path}

      -archdatadir share/qt
      -datadir share/qt
      -examplesdir share/qt/examples
      -testsdir share/qt/tests

      -no-feature-relocatable
      -system-sqlite

      -no-sql-mysql
      -no-sql-odbc
      -no-sql-psql
    ]

    # TODO: remove `-DFEATURE_qt3d_system_assimp=ON`
    # and `-DTEST_assimp=ON` when Qt 6.2 is released.
    # See https://bugreports.qt.io/browse/QTBUG-91537
    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST") + %W[
      -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}

      -DINSTALL_MKSPECSDIR=share/qt/mkspecs

      -DFEATURE_pkg_config=ON
      -DFEATURE_qt3d_system_assimp=ON
      -DTEST_assimp=ON
    ]

    system "./configure", *config_args, "--", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    rm bin/"qt-cmake-private-install.cmake"

    inreplace lib/"cmake/Qt6/qt.toolchain.cmake", HOMEBREW_SHIMS_PATH/"mac/super", "/usr/bin"

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    # Tracking issues:
    # https://bugreports.qt.io/browse/QTBUG-86080
    # https://gitlab.kitware.com/cmake/cmake/-/merge_requests/6363
    lib.glob("*.framework") do |f|
      # Some config scripts will only find Qt in a "Frameworks" folder
      frameworks.install_symlink f
      include.install_symlink f/"Headers" => f.stem
    end

    bin.glob("*.app") do |app|
      libexec.install app
      bin.write_exec_script libexec/app.basename/"Contents/MacOS"/app.stem
    end
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION #{Formula["cmake"].version})

      project(test VERSION 1.0.0 LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

      set(CMAKE_AUTOMOC ON)
      set(CMAKE_AUTORCC ON)
      set(CMAKE_AUTOUIC ON)

      find_package(Qt6 COMPONENTS Core Widgets Sql Concurrent
        3DCore Svg Quick3D Network NetworkAuth REQUIRED)

      add_executable(test
          main.cpp
      )

      target_link_libraries(test PRIVATE Qt6::Core Qt6::Widgets
        Qt6::Sql Qt6::Concurrent Qt6::3DCore Qt6::Svg Qt6::Quick3D
        Qt6::Network Qt6::NetworkAuth
      )
    EOS

    (testpath/"test.pro").write <<~EOS
      QT       += core svg 3dcore network networkauth quick3d \
        sql
      TARGET = test
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<~EOS
      #undef QT_NO_DEBUG
      #include <QCoreApplication>
      #include <Qt3DCore>
      #include <QtQuick3D>
      #include <QImageReader>
      #include <QtNetworkAuth>
      #include <QtSql>
      #include <QtSvg>
      #include <QDebug>
      #include <iostream>

      int main(int argc, char *argv[])
      {
        QCoreApplication a(argc, argv);
        QSvgGenerator generator;
        auto *handler = new QOAuthHttpServerReplyHandler();
        delete handler; handler = nullptr;
        auto *root = new Qt3DCore::QEntity();
        delete root; root = nullptr;
        Q_ASSERT(QSqlDatabase::isDriverAvailable("QSQLITE"));
        const auto &list = QImageReader::supportedImageFormats();
        for(const char* fmt:{"bmp", "cur", "gif", "heic", "heif",
          "icns", "ico", "jp2", "jpeg", "jpg", "pbm", "pgm", "png",
          "ppm", "svg", "svgz", "tga", "tif", "tiff", "wbmp", "webp",
          "xbm", "xpm"}) {
          Q_ASSERT(list.contains(fmt));
        }
        return 0;
      }
    EOS

    system "cmake", testpath
    system "make"
    system "./test"

    ENV.delete "CPATH" unless MacOS.version <= :mojave
    system bin/"qmake", testpath/"test.pro"
    system "make"
    system "./test"
  end
end
