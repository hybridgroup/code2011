class StatGenerator
  # A map of language names to possible shorthand versions.
  LANGS = {
    "Abap" => %w(abap),
    "ActionScript" => %w(actionscript action_script as3 as2 as1 flash flex),
    "Ada" => %w(ada),
    "Apex" => %w(apex),
    "Apl" => %w(apl),
    "AppleScript" => %w(applescript),
    "Assembly" => %w(assembly),
    "Alice" => %w(alice),
    "Awk" => %w(awk),
    "Basic" => %w(basic),
    "Bash" => %w(bash),
    "Boo" => %w(boo),
    "Brightscript" => %w(brightscript),
    "C" => %w(c),
    "C#" => %w(c# csharp c_sharp c-sharp),
    "C++" => %w(c\+\+ cplusplus),
    "Ceylon" => %w(ceylon),
    "Chapel" => %w(chapel),
    "cT" => %w(ct),
    "Clean" => %w(clean),
    "Clojure" => %w(clojure clj),
    "Cobol" => %w(cobol),
    "CoffeeScript" => %w(coffeescript),
    "ColdFusion" => %w(coldfusion cold_fusion cold-fusion cfml),
    "D" => %w(d),
    "Dart" => %w(dart),
    "Delphi" => %w(delphi),
    "Elixir" => %w(elixir),
    "Elm" => %w(elm),
    "Emacs Lisp" => %w(elisp emacs-lisp emacs),
    "Erlang" => %w(erlang),
    "Factor" => %w(factor),
    "Fantom" => %w(fantom),
    "F#" => %w(f# fsharp f_sharp f-sharp),
    "Forth" => %w(forth),
    "Fortran" => %w(fortran),
    "Frink" => %w(frink),
    "Gedemin" => %w(gedemin),
    "GLSL" => %w(glsl),
    "Go" => %w(go golang),
    "Gosu" => %w(gosu),
    "Groovy" => %w(groovy),
    "Haskell" => %w(haskell),
    "Hack" => %w(hack),
    "Haxe" => %w(haxe),
    "Io" => %w(io),
    "J" => %w(j),
    "J#" => %w(j# jsharp j_sharp j-sharp),
    "Java" => %w(java),
    "JavaScript" => %w(javascript js node.js node),
    "Julia" => %w(julia),
    "Ladder Logic" => %w(ladderlogic ladder-logic ladder),
    "Less" => %w(less),
    "Lisp" => %w(lisp),
    "Lingo" => %w(lingo),
    "LiveCode" => %w(livecode Livecode),
    "Livescript" => %w(livescript),
    "Logo" => %w(logo),
    "Lua" => %w(lua),
    "ML" => %w(ml),
    "Matlab" => %w(matlab),
    "Mirah" => %w(mirah),
    "Mathematica" => %w(mathematica),
    "Nimrod" => %w(nimrod),
    "Kotlin" => %w(kotlin),
    "Moonscript" => %w(moonscript),
    "Objective-C" => %w(objectivec objective-c objc objective_c),
    "Ocaml" => %w(ocaml),
    "Octave" => %w(octave),
    "PHP" => %w(php),
    "Pascal" => %w(pascal),
    "Perl" => %w(pl perl),
    "Postscript" => %w(postscript),
    "Pogoscript" => %w(pogoscript pogo),
    "PowerShell" => %w(Powershell, powershell),
    "Prolog" => %w(prolog),
    "Python" => %w(python),
    "Q" => %w(Q),
    "R" => %w(r rlang),
    "Racket" => %w(racket),
    "Rebol" => %w(rebol),
    "Red" => %w(red red\/system red_system),
    "Rexx" => %w(rexx),
    "RPG" => %w(rpg),
    "Ruby" => %w(ruby rb rubby),
    "Rust" => %w(rust),
    "SAS" => %w(sas),
    "Sass" => %w(sass),
    "Seed7" => %w(seed7),
    "SQL" => %w(sql mysql postgresql plsql pl-sql pl\/sql),
    "SPARQL" => %w(sparql),
    "Scala" => %w(scala),
    "Scheme" => %w(scheme),
    "Scratch" => %w(scratch),
    "Smalltalk" => %w(smalltalk),
    "Swift" => %w(swift),
    "TCL" => %w(TCL),
    "Visual Basic" => %w(visual_basic vb),
    "VBScript" => %w(vbscript),
    "VimScript" => %w(vimscript vim-script),
    "zsh" => %w(zsh)
  }

  attr_reader :tweets, :stats, :user_langs

  def initialize(tweets)
    @user_langs = {}
    @stats = {}

    @tweets = tweets.collect do |tweet|
      { user: tweet.attrs["user"]["id"], text: tweet.text }
    end

    @tweets.each { |tweet| @user_langs[tweet[:user]] = [] }
    LANGS.each { |name, _| @stats[name] = 0 }
  end

  def generate
    @tweets.each { |tweet| find_langs_in_tweet(tweet) }
    compile_stats
    @stats
  end

  def find_langs_in_tweet(tweet)
    LANGS.each do |name, strings|
      match = false
      strings.each do |string|
        match = true if tweet[:text].match((/(\s|^|,|#)#{string}(\s|,|\.|$)/i))
      end

      if match
        unless @user_langs[tweet[:user]].include?(name)
          @user_langs[tweet[:user]] << name
        end
      end
    end
  end

  def compile_stats
    @user_langs.each do |user, langs|
      langs.each do |lang|
        @stats[lang] += 1
      end
    end
  end
end
