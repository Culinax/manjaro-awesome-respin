#!/bin/bash
#
# Part of Post Installation Script
#
# Post Installation Script is a script which is developed for Manjaro Awesome
# WM respin, codenamed: Cesious. It's purpose is to provide an easy way for
# users to set up their system, get used to the keybindings, install drivers
# and download and install applications.
#
# Written by Culinax

documentation() {
	cat <<-EOF
	List of added (non-default) keybindings. For default keybindings you can read the manpage of awesome.
	
	Basic keys
	    Mod4 + Shift + q
	        OBLogout
	    Mod4 + p
	        dmenu
	    Mod4 + b
	        Toggle wibox visibilaty
	    Mod4 + Shift + l
	        Lock the screen (slock)
	
	Applications
	    Mod4 + d
	        dwb (web browser)
	    Mod4 + t
	        SpaceFM (file manager)
	
	Switch to specific layout (compared to Mod4 + Space which iterates over all of them)
	    Mod4 + Control + f
	        Floating Mode
	    Mod4 + Control + t
	        Tiling Mode
	    Mod4 + Control + b
	        Bottom Stack
	    Mod4 + Control + s
	        Fair
	    Mod4 + Control + m
	        Maximized
	
	Volume Control
	    XF86AudioRaiseVolume
	        Raise volume (ALSA) while spawning Volnoti to show the current volume
	    XF86AudioLowerVolume
	        Lower volume (ALSA) while spawning Volnoti to show the current volume
	    XF86AudioMute
	        Toggle mute (ALSA) while spawning Volnoti to show the current volume
	
	Brightness Control
	    XF86MonBrightnessUp
	        Raise brightnesss while spawning Volnoti to show the current brightness
	    XF86MonBrightnessDown
	        Lower brightness while spawning Volnoti to show the current brightness
	
	PrintScreen
	    Print
	        Take a screenshot of the whole screen (scrot)
	    Shift + Print
	        Take a screenshot of a windows (scrot)
	EOF
}

apps_aur=("Autoconf" "Automake" "binutils" "Bison" "fakeroot" "flex" "GCC" "libtool" "m4" "Make" "patch" "yaourt")
apps_cal=("calcurse" "Wyrd")
apps_cddvd=("Brasero" "K3b" "Xfburn")
apps_chat=("BitlBee" "Pidgin" "Skype")
apps_email=("Evolution" "Mutt" "Re-Alpine" "Thunderbird")
apps_file=("kdebase-Dolphin" "MC" "Nautilus" "PCManFM" "ranger" "SpaceFM" "Thunar")
apps_graphic=("Blender" "GIMP" "ImageMagick" "Inkscape" "Pinta")
apps_imgview=("feh" "GPicView" "Mirage" "sxiv" "Viewnior")
apps_irc=("HexChat" "Irssi" "WeeChat")
apps_media=("gst-libav" "gst-plugins-bad" "gst-plugins-base" "gst-plugins-good" "gst-plugins-ugly" "gstreamer0.10-bad-plugins" "gstreamer0.10-base-plugins" "gstreamer0.10-good-plugins" "gstreamer0.10-ugly-plugins" "FlashPlugin" "libdvdcss" "IcedTea-Web-Java7")
apps_mpd=("mpc" "ncmpcpp" "Sonata")
apps_music=("Amarok" "Audacious" "Banshee" "Clementine" "cmus" "DeaDBeeF" "MOC" "MPD" "Rhythmbox")
apps_nautilus=("Nautilus-Actions" "Nautilius-Terminal" "Nautilus-Open-Terminal" "Seahorse-Nautilus")
apps_office=("AbiWord" "Calligra" "Gnumeric" "LibreOffice")
apps_pcmanfm=("GVfs")
apps_pdf=("ePDFView" "Evince" "MuPDF" "Xpdf" "zathura-pdf-mupdf" "zathura-pdf-poppler")
apps_printer=("CUPS" "Ghostscript" "gsfonts" "CUPS-PDF" "foomatic-db" "foomatic-db-engine" "foomatic-db-nonfree" "Gutenprint" "SpliX" "HPLIP")
apps_rss=("Liferea" "newsbeuter")
apps_spacefm=("udevil")
apps_sysmon=("Conky" "htop")
apps_term=("GNOME-Terminal" "kdebase-Konsole" "LilyTerm" "LXTerminal" "rxvt-unicode" "sakura" "Terminator" "Xfce4-Terminal" "xterm")
apps_text=("Emacs" "Geany" "gedit" "gVim" "Leafpad" "Vim")
apps_thunar=("GVfs" "Thunar-Archive-Plugin" "Thunar-Media-Tags-Plugin" "Thunar-VolMan" "Tumbler")
apps_torrent=("Deluge" "rTorrent" "Transmission-CLI" "Transmission-GTK" "Transmission-Remote-CLI" "Transmission-Qt")
apps_util=("BleachBit" "ClipIt" "galculator" "Parcellite" "scrot" "tmux")
apps_video=("GNOME-MPlayer" "MPlayer" "mpv" "SMPlayer" "VLC")
apps_web=("Chromium" "dwb" "Firefox" "luakit" "Midori" "Opera" "Uzbl-Tabbed")

declare -A apps_descr=(
    ["AbiWord"]="A fully-featured word processor"
    ["Amarok"]="The powerful music player for KDE"
    ["Audacious"]="Lightweight, advanced audio player focused on audio quality"
    ["Autoconf"]="A GNU tool for automatically configuring source code"
    ["Automake"]="A GNU tool for automatically creating Makefiles"
    ["Banshee"]="Music management and playback for GNOME"
    ["binutils"]="A set of programs to assemble and manipulate binary and object files"
    ["Bison"]="The GNU general-purpose parser generator"
    ["BitlBee"]="Brings instant messaging (XMPP, MSN, Yahoo!, AIM, ICQ, Twitter to IRC)"
    ["BleachBit"]="Deletes unneeded files to free disk space and maintain privacy"
    ["Blender"]="A fully integrated 3D graphics creation suite"
    ["Brasero"]="A disc burning application for Gnome"
    ["calcurse"]="A text-based personal organizer."
    ["Calligra"]="Actively developed fork of KOffice, the KDE office suite"
    ["Chromium"]="The open-source project behind Google Chrome, an attempt at creating a safer, faster, and more stable browser"
    ["Clementine"]="A music player and library organizer"
    ["ClipIt"]="Lightweight GTK+ clipboard manager (fork of Parcellite)"
    ["cmus"]="Very feature-rich ncurses-based music player"
    ["Conky"]="Lightweight system monitor for X"
    ["CUPS"]="The CUPS Printing System - daemon package"
    ["CUPS-PDF"]="PDF printer for cups"
    ["DeaDBeeF"]="An audio player for GNU/Linux based on GTK2."
    ["Deluge"]="A BitTorrent client with multiple use interfaces in a client/server model"
    ["dwb"]="A webkit web browser with vi-like keyboard shortcuts, stable snapshot"
    ["Emacs"]="The extensible, customizable, self-documenting real-time display editor"
    ["ePDFView"]="A free lightweight PDF document viewer."
    ["Evince"]="Simply a document viewer"
    ["Evolution"]="Manage your email, contacts and schedule"
    ["fakeroot"]="Gives a fake root environment, useful for building packages as a non-privileged user"
    ["feh"]="Fast and light imlib2-based image viewer"
    ["Firefox"]="Standalone web browser from mozilla.org"
    ["FlashPlugin"]="Adobe Flash Player"
    ["flex"]="A tool for generating text-scanning program"
    ["foomatic-db"]="Foomatic - The collected knowledge about printers, drivers, and driver options in XML files, used by foomatic-db-engine to generate PPD files."
    ["foomatic-db-engine"]="Foomatic - Foomatic's database engine generates PPD files from the data in Foomatic's XML database. It also contains scripts to directly generate print queues and handle jobs."
    ["foomatic-db-nonfree"]="Foomatic - database extension consisting of manufacturer-supplied PPD files released under non-free licenses"
    ["galculator"]="GTK+ based scientific calculator"
    ["GCC"]="The GNU Compiler Collection - C and C++ frontends"
    ["Geany"]="Fast and lightweight IDE"
    ["gedit"]="A text editor for GNOME"
    ["Ghostscript"]="An interpreter for the PostScript language"
    ["GIMP"]="GNU Image Manipulation Program"
    ["GNOME-MPlayer"]="A simple MPlayer GUI"
    ["GNOME-Terminal"]="The GNOME Terminal Emulator"
    ["Gnumeric"]="A GNOME Spreadsheet Program"
    ["GPicView"]="lightweight image viewer"
    ["gsfonts"]="Standard Ghostscript Type1 fonts from URW"
    ["gst-libav"]="Gstreamer libav Plugin"
    ["gst-plugins-bad"]="GStreamer Multimedia Framework Bad Plugins"
    ["gst-plugins-base"]="GStreamer Multimedia Framework Base Plugins"
    ["gst-plugins-good"]="GStreamer Multimedia Framework Good Plugins"
    ["gst-plugins-ugly"]="GStreamer Multimedia Framework Ugly Plugins"
    ["gstreamer0.10-bad-plugins"]="GStreamer Multimedia Framework Bad Plugins (gst-plugins-bad)"
    ["gstreamer0.10-base-plugins"]="GStreamer Multimedia Framework Base Plugins (gst-plugins-base)"
    ["gstreamer0.10-good-plugins"]="GStreamer Multimedia Framework Good Plugins (gst-plugins-good)"
    ["gstreamer0.10-ugly-plugins"]="GStreamer Multimedia Framework Ugly Plugins (gst-plugins-ugly)"
    ["Gutenprint"]="Top quality printer drivers for POSIX systems"
    ["GVfs"]="For trash support, mounting with udisk and remote filesystems"
    ["gVim"]="Vi Improved (with features, such as a GUI)"
    ["HexChat"]="A popular and easy to use graphical IRC (chat client)"
    ["HPLIP"]="Drivers for HP DeskJet, OfficeJet, Photosmart, Business Inkjet and some LaserJet"
    ["htop"]="Interactive process viewer"
    ["IcedTea-Web-Java7"]="provides a Free Software web browser plugin running applets written in the Java programming language and an implementation of Java Web Start, originally based on the NetX project"
    ["ImageMagick"]="An image viewing/manipulation program"
    ["Inkscape"]="Vector graphics editor using the SVG file format"
    ["Irssi"]="Modular text mode IRC client with Perl scripting"
    ["K3b"]="Feature-rich and easy to handle CD burning application"
    ["kdebase-Dolphin"]="File Manager"
    ["kdebase-Konsole"]="Terminal"
    ["Leafpad"]="A notepad clone for GTK+ 2.0"
    ["libdvdcss"]="Portable abstraction library for DVD decryption"
    ["LibreOffice"]="A productivity suite that is compatible with other major office suites"
    ["libtool"]="A generic library support script"
    ["Liferea"]="A desktop news aggregator for online news feeds and weblogs"
    ["LilyTerm"]="A light and easy to use libvte based X terminal emulator"
    ["luakit"]="Fast, small, webkit based browser framework extensible by Lua"
    ["LXTerminal"]="VTE-based terminal emulator (part of LXDE)"
    ["m4"]="The GNU macro processor"
    ["Make"]="GNU make utility to maintain groups of programs"
    ["MC"]="Midnight Commander is a text based filemanager/shell that emulates Norton Commander"
    ["Midori"]="Lightweight web browser based on Gtk WebKit"
    ["Mirage"]="A simple GTK+ Image Viewer"
    ["MOC"]="An ncurses console audio player designed to be powerful and easy to use"
    ["mpc"]="Minimalist command line interface to MPD"
    ["MPD"]="Flexible, powerful, server-side application for playing music"
    ["MPlayer"]="A movie player for Linux"
    ["mpv"]="Video player based on MPlayer/mplayer2"
    ["MuPDF"]="Lightweight PDF and XPS viewer"
    ["Mutt"]="Small but very powerful text-based mail client"
    ["Nautilus"]="GNOME file manager"
    ["Nautilus-Actions"]="Configures programs to be launched when files are selected in Nautilus"
    ["Nautilus-Open-Terminal"]="A nautilus plugin for opening terminals in arbitrary local paths"
    ["Nautilus-Terminal"]="An integrated terminal for Nautilus"
    ["ncmpcpp"]="Almost exact clone of ncmpc with some new features"
    ["newsbeuter"]="A RSS feed reader for the text console with special Podcast support"
    ["Opera"]="Fast and secure web browser and Internet suite"
    ["Parcellite"]="Lightweight GTK+ clipboard manager"
    ["patch"]="A utility to apply patch files to original sources"
    ["PCManFM"]="An extremely fast and lightweight file manager"
    ["Pidgin"]="Multi-protocol instant messaging client"
    ["Pinta"]="A drawing/editing program modeled after Paint.NET."
    ["ranger"]="A simple, vim-like file manager"
    ["Rhythmbox"]="An iTunes-like music playback and management application"
    ["Re-Alpine"]="The continuation of the Alpine email client from University of Washington"
    ["rTorrent"]="Ncurses BitTorrent client based on libTorrent"
    ["rxvt-unicode"]="An unicode enabled rxvt-clone terminal emulator (urxvt)"
    ["sakura"]="A terminal emulator based on GTK and VTE"
    ["scrot"]="A simple command-line screenshot utility for X"
    ["Seahorse-Nautilus"]="PGP encryption and signing for nautilus"
    ["Skype"]="P2P software for high-quality voice communication"
    ["SMPlayer"]="A complete front-end for MPlayer"
    ["Sonata"]="Elegant GTK+ music client for MPD"
    ["SpaceFM"]="Multi-panel tabbed file manager"
    ["SpliX"]="CUPS drivers for SPL (Samsung Printer Language) printers"
    ["sxiv"]="Simple X Image Viewer"
    ["Terminator"]="Terminal emulator that supports tabs and grids"
    ["Thunar"]="Modern file manager for Xfce"
    ["Thunar-Archive-Plugin"]="Create and deflate archives"
    ["Thunar-Media-Tags-Plugin"]="View/edit id3/ogg tags"
    ["Thunar-VolMan"]="Manages removable devices"
    ["Thunderbird"]="Standalone Mail/News reader"
    ["tmux"]="A terminal multiplexer"
    ["Transmission-CLI"]="Fast, easy, and free BitTorrent client (CLI tools, daemon and web client)"
    ["Transmission-GTK"]="Fast, easy, and free BitTorrent client (GTK+ GUI)"
    ["Transmission-Qt"]="Fast, easy, and free BitTorrent client (Qt GUI)"
    ["Transmission-Remote-CLI"]="Curses interface for the daemon of the BitTorrent client Transmission"
    ["Tumbler"]="For thumbnail previews"
    ["udevil"]="Mount as non-root user and mount networks"
    ["Uzbl-Tabbed"]="Tabbing manager providing multiple uzbl-browser instances in 1 window"
    ["Viewnior"]="A simple, fast and elegant image viewer program"
    ["Vim"]="Vi Improved, a highly configurable, improved version of the vi text editor"
    ["VLC"]="A multi-platform MPEG, VCD/DVD, and DivX player"
    ["WeeChat"]="Fast, light and extensible IRC client (curses UI)"
    ["Wyrd"]="A text-based front-end to Remind."
    ["Xfburn"]="A simple CD/DVD burning tool based on libburnia libraries"
    ["Xfce4-Terminal"]="A modern terminal emulator primarly for the Xfce desktop environment"
    ["Xpdf"]="Viewer for Portable Document Format (PDF files)"
    ["xterm"]="X Terminal Emulator"
    ["yaourt"]="A pacman wrapper with extended features and AUR support"
    ["zathura-pdf-mupdf"]="Adds pdf support to zathura by using the mupdf library"
    ["zathura-pdf-poppler"]="Adds pdf support to zathura by using the poppler engine"
)
