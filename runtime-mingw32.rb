require "formula"

class RuntimeMingw32 < Formula
  homepage "http://mingw-w64.sourceforge.net/"
  url "http://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v3.1.0.tar.bz2"
  sha256 "ece7a7e7e1ab5e25d5ce469f8e4de7223696146fffa71c16e2a9b017d0e017d2"

  depends_on "gcc48" => :build
  depends_on "cosmo0920/mingw_w64/binutils-mingw64"
  depends_on "cosmo0920/mingw_w64/mingw-headers64"

  def install
    install_prefix="/usr/local/mingw/"
    path = ENV["PATH"]
    ENV.prepend_path 'PATH', "#{install_prefix}/bin"
    target_arch = "i686-w64-mingw32"

    # create symlink to `/usr/local/mingw//mingw/include`
    chdir "#{install_prefix}" do
      system "rm mingw" if Dir.exist?("mingw")
      system "ln -s #{target_arch} mingw"
    end

    args = %W[
      CC=gcc-4.8
      CXX=g++-4.8
      CPP=cpp-4.8
      LD=gcc-4.8
      --host=#{target_arch}
      --prefix=#{install_prefix}/#{target_arch}
      --with-sysroot=#{install_prefix}
    ]

    mkdir "build-crt" do
      system "../mingw-w64-crt/configure", *args
      system "make"
      system "make install"
    end
    # restore PATH
    ENV["PATH"] = path
  end

end
