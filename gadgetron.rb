require "formula"

class Gadgetron < Formula
  homepage "https://gadgetron.github.io"
  url "https://github.com/gadgetron/gadgetron/archive/v3.1.0.tar.gz"
  sha1 "477ed925ec05399adc9c96967146719084655f93"

  depends_on 'cmake' => :build
  depends_on 'ismrmrd'
  depends_on 'boost'
  depends_on 'ace'
  depends_on 'armadillo'
  depends_on 'qt' => :recommended
  depends_on 'dcmtk' => :recommended
  depends_on 'numpy' => :recommended
  depends_on 'boost-python' => :recommended

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
        if !File.exist? "#{prefix}/config/gadgetron.xml"
            cp "#{prefix}/config/gadgetron.xml.example", "#{prefix}/config/gadgetron.xml"
        end
    end
  end

end
