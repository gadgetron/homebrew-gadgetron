require "formula"

class Gadgetron < Formula
  homepage "https://gadgetron.github.io"
  url "https://github.com/gadgetron/gadgetron/releases/download/v3.0.0/gadgetron-v3.0.0.tar.gz"
  sha1 "cf8ca84896c48c0ef8319f576f3a2745c2d2b5e2"

  depends_on 'cmake' => :build
  depends_on 'ismrmrd'
  depends_on 'boost'
  depends_on 'ace'
  depends_on 'armadillo'
  depends_on 'qt' => :optional
  depends_on 'docbook-xsl' => :optional
  depends_on 'fop' => :optional
  depends_on 'dcmtk' => :recommended
  depends_on 'python' => :recommended

  def install
    # Gadgetron adds "gadgetron" to the end of CMAKE_INSTALL_PREFIX by default
    inreplace 'CmakeLists.txt' do |s|
        s.gsub! /set\(CMAKE_INSTALL_PREFIX.*/, ''
    end

    args = std_cmake_args

    if build.with? 'python'
      python_prefix = `python-config --prefix`.strip
      args << "-D PYTHON_LIBRARY=#{python_prefix}/Python"
      args << "-D PYTHON_INCLUDE_DIR=#{python_prefix}/Headers"
    end

    mkdir "gadgetron-build" do
        system "cmake", "..", *args
        system "make", "install"
    end
  end

  # test do
  #   ENV['GADGETRON_HOME'] = "#{prefix}"

  #   pid = fork do
  #     exec "#{bin}/gadgetron > /dev/null 2>&1"
  #   end
  #   system 'ismrmrd_create_dataset'

  #   system "#{bin}/mriclient", '-d', 'testdata.h5', '-c', 'default.xml'

  #   assert(File.stat('out.h5').size > 1024,
  #          "Did not receive valid HDF5 reconstruction")

  #   Process.kill 'TERM', pid
  #   Process.wait pid
  # end

  def caveats; <<-EOS.undent
    Export the following environment variable in your shell profile:
      GADGETRON_HOME=#{prefix}
    To start using Gadgetron, copy
      $GADGETRON_HOME/config/gadgetron.xml.example -> $GADGETRON_HOME/config/gadgetron.xml
    EOS
  end

end
