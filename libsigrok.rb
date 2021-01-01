class Libsigrok < Formula
  url 'http://sigrok.org/download/source/libsigrok/libsigrok-0.5.2.tar.gz'
  homepage 'http://sigrok.org/'
  head 'git://sigrok.org/libsigrok', branch: "master", shallow: false
  sha256 '4d341f90b6220d3e8cb251dacf726c41165285612248f2c52d15df4590a1ce3c'

  option "with-cxx", "Enable C++ bindings, required for pulseview"
  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  # depends_on "libtool" => :build

  depends_on "pkg-config" => :build
  depends_on 'swig' => :build
  depends_on "doxygen"
  depends_on "hidapi"
  depends_on "glib" => :build
  depends_on "glibmm" => :build
  depends_on "libftdi" => :build
  depends_on "libserialport" => :build
  depends_on 'libtool'
  depends_on "libusb" => :build
  depends_on 'libzip'
  depends_on "nettle" => :build
  depends_on "libffi" => :build
  # depends_on "python@3.9" => :build
  # depends_on "python@2.7" => :build


  # TODO: this formula file can not find the glibmm pkg
  # ...however when running `autogen.sh` outside of brew the setup script finds all
  # ... necessary packages

  def install
    # ENV.prepend_path "PKG_CONFIG_PATH", Formula["lua@5.1"].opt_libexec/"lib/pkgconfig"
    # ENV.prepend_path "PKG_CONFIG_PATH", Formula["glibmm"].opt_libexec/"lib/pkgconfig"
    # Fix autotools glibmm
    # inreplace "configure.ac", "[glibmm-2.4 >= 2.32.0]", "[glibmm], [yes], [no]"
    # ENV.delete "PYTHONPATH"
    args = %W[
      --enable-bindings
      CFLAGS=-I#{Formula["gettext"].include}
      LDFLAGS=-L#{Formula["gettext"].lib}

      CPPFLAGS=-I#{Formula["libffi"].include}
      LDFLAGS=-L#{Formula["libffi"].lib}

      CPPFLAGS=-I#{Formula["glibmm"].include}
      LDFLAGS=-L#{Formula["glibmm"].lib}
    ]
    # "--disable-java", "--disable-sysclk-lwla"

    args << "--enable-cxx" if build.with? "cxx"

    if build.head?
      system "./autogen.sh", *args
    end

    system "./configure", *args, "--prefix=#{prefix}"
    system "make", "install"
    # system "ln", "-s", "/usr/local/share/", "#{prefix}/share"
  end

    def caveats
    <<-EOS
    pulseview requires this package be built with C++ bindings
    EOS
  end


end
