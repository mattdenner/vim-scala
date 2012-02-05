# Scala plugin for VIM
This is my first attempt at a plugin for VIM and I've built it whilst learning VIM script & Scala, so it's bound to have a number of issues.  It offers both syntax highlighting
and indentation with the following caveats:

The syntax highlighting is there for me to learn the language and identify my mistakes, so some things appear to be odd:

* I've made both `Symbol` and `Nil` constants, rather than having them picked up as class names, purely because I see these as different;
* You'll also notice that, at the moment, class names can be a little picky, using alphabetic camelcase: I've not required digits in there yet;
* Numerics, in particular, may behave a bit oddly in highlighting but I believe I've caught the most common cases;
* I like whitespace around things so sometimes you may find just adding that will make things highlight.

The indentation code is a massive work in progress:

* It works on most of the files I've met in my Scala research but I know there are holes;
* The leveling of `{` and `}` is based on my personal preference for these and my style of writing C/C++/Java;
* Multi-line assignments will behave oddly, especially with blocks, but shouldn't bleed outside of methods.

The last is particularly troublesome at the moment with:

    var x =
      if (true) {
        1
      } else {
        2
      }

    var y = 1

Ending up with indentation something akin to:

    var x =
      if (true) {
    1
      } else {
    2
      }

      var y = 1

The indentation of `var y = 1` will cause the rest of the code after it to be indented at that level until the end of the the method.  I highly recommend not doing assignments
like this unless you are prepared for the offset, or can keep the method short.  Personally I can see that as a bit of a win for my code style, but I will be trying to fix it.

Note that the indentation is being worked on but I'm having to learn VIM script as I go, so it might take a while!

## Problems & fixes
If you find problems feel free to fork & submit a pull request if you have a fix.

## Notes
Inspiration for this has come from the main VIM Scala plugin which can be found here: https://github.com/derekwyatt/vim-scala

