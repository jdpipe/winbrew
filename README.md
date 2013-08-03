Winbrew
=======
An experimental fork of Homebrew for Windows.

Installation
------------

* Install MinGW, MSYS, with a C and C++ compiler: <http://mingw.org/download/installer>
* Install msysgit: <http://msysgit.github.io/>
* Install Ruby: <http://rubyinstaller.org/>
* Make sure git and ruby are in your path
* `git clone https://github.com/nddrylliog/winbrew.git /usr/local`
* Add to your `.bashrc`:

 ```sh
 export PATH=/usr/local/bin:$PATH
 export LD_LIBRARY_PATH=/usr/local/lib
 ```

* If necessary, add to your `.profile`:

 ```sh
 #!/bin/sh.exe
 if [ -f ${HOME}/.bashrc ]
 then
   . ${HOME}/.bashrc
 fi
 ```

* `brew install $WHATEVER_YOU_WANT`

What Packages Are Available?
----------------------------
1. You can [browse the Formula directory on GitHub](https://github.com/nddrylliog/winbrew/tree/master/Library/Formula).
2. Or type `brew search` for a list.
3. Or run `brew server` to browse packages off of a local web server.
4. Or visit [braumeister](http://braumeister.org) to browse packages online.

Requirement
-----------
* **Ruby** 1.8.6 or newer

More Documentation
------------------
`brew help` or `man brew` or check the Homebrew [wiki](https://github.com/mxcl/homebrew/wiki).