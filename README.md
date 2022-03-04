# Perl Navigator Language Server
Provides syntax checking, autocompletion, perlcritic, code navigation, hover for Perl.

Implemented as a Language Server using the Microsoft LSP libraries along with Perl doing the syntax checking and parsing.  

Works on Windows, MacOS, and Linux. The vscode extension includes everything needed to work, no additional installation should be necessary.
Works on almost any version of Perl, tested all the way back to Perl 5.8. Has full support for multi-root workspaces, single file editing, and multiple open windows.

Install the vscode extension from here: https://marketplace.visualstudio.com/items?itemName=bscan.perlnavigator 

## Currently Implemented Features:
* Syntax Checking
* Perl Critic static code analysis/suggestions
* Smart context-aware autocompletion and navigation
* Code Navigation ("Go To Definition") anywhere, including to installed modules and compile-time dependencies
* Code formatting via Perl::Tidy
* Outline view
* Hover for more details about objects, subs, and modules
* Does not write any cache directories or temp files.
* Works well with single files and large multi-folder workspaces
* Support for Classes including Moo/Moose style classes

## Visual Studio Code Demo

![gif of Navigator in vscode](https://raw.githubusercontent.com/bscan/PerlNavigator/main/Demo.gif)


## Vscode Installation
Install the VSCode extension and it should just work. All required dependencies are bundled with the extension. 
Please file a bug report if the Perl Navigator does not work out of the box.
Perl::Critic is not currently bundled and needs to be installed separately, but the remaining features (e.g. navigation, autocomplete, syntax check) do not require it.


### Perl paths
If you have a nonstandard install of Perl, please set the setting "perlnavigator.perlPath"
You can also add additional include paths that will be added to the perl search path (@INC) via "perlnavigator.includePaths" 


### Perl Critic Customization 
You should specify a Perl::Critic profile via "perlnavigator.perlcriticProfile". If this is not set, it will check for "~./perlcriticrc".
If that also does not exist, a default profile will be used. This default profile is not very strict.
The default severities are reasonable, (primarily used for coloring the squiggly underlines) but you can change "perlnavigator.severity1" through severity5. Allowable options are error, warning, info, and hint.

### Perl Tidy Customization
It is recommended to set "perlnavigator.perltidyProfile" if you would like customized formatting. Otherwise, the default settings will be used. I might create a default profile at some point. 

## Installation For Other Editors
Currently, this is not yet packaged for other editors but you can build from source. You'll need to have node.js and npm installed.
```
git clone https://github.com/bscan/PerlNavigator
cd PerlNavigator/
npm install
cd server/
npm install
tsc
```

### Sublime Text
Sublime Text requires the following minimum settings under LSP settings (modify depending on your install location and editor)
```
{
    "clients": {
        "perlnavigator": {
            "enabled": true,
            "command": ["node", "C:\\temp\\PerlNavigator\\server\\out\\server.js","--stdio"],
            "selector": "source.perl",
        },
    }
}
```

![gif of Navigator in sublime](https://raw.githubusercontent.com/bscan/PerlNavigator/main/images/Sublime.gif)

### Emacs
Emacs requires lsp-mode. You can use something similar to the following configuration. 
```
  (require 'lsp-mode)
(add-to-list 'lsp-language-id-configuration '(perl-mode . "perl"))
(add-to-list 'lsp-language-id-configuration '(cperl-mode . "perl"))
(lsp-register-client
(make-lsp-client :new-connection (lsp-stdio-connection '("node" "/home/username/src/PerlNavigator/server/out/server.js" "--stdio"))
;; :activation-fn (lsp-activate-on "perl")
:major-modes '(cperl-mode perl-mode)
:priority 10
:server-id 'perl-ls))
```

## Packaging

This is relevant for maintainers only. To build the extension `perlnavigator-*.vsix`:

* clone the repo
* `npm install`
* set up a Perl environment amenable to installing modules: [perlbrew](https://perlbrew.pl/) or similar is fine, a system Perl should work too provided the usual headers and development files exist; `local::lib` is untested
* set up cpanminus: `perlbrew install-cpanm` or `cpan App::cpanminus` or get a copy from [cpanmin.us](https://cpanmin.us)
* `npm run vsix`

## Licenses / Acknowledgments
The Perl Navigator is free software licensed under the MIT License. It has a number of bundled dependencies as well, all of which have their respective open source licenses and copyright attributions included.
This work is only possible due to Class::Inspector, Devel::Symdump, Perl::Critic, PPI, Sub::Util, Perl itself, Microsoft LSP libraries, and ideas from Perl::LanguageServer and PLS.
