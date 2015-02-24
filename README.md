OTR-DecodeAll
=============

Shell script to decode all downloaded *.otrkey files, send them to multicut, create folders with appropriate file names and move the final movie files there (working with XMBC)


Configuration
-------------

The config file provides a default configuration. Some parts can be overridden by command line parameters, other variables shall use those parameters. Thus the config file is divided in two parts (functions): funcConfigPre and funcConfigPost.
In funcConfigPre the following values have to be set:
    user="OTR-User"
    pass="OTR-Password"
  
    delugeDir="/etc/deluged"                # Config dir of DelugeD
    inDir="/Multimedia/Video/.Downloaded"   # Dir with .otrkeys
    uncutDir="/Multimedia/Video/.Uncut"     # Dir with uncut videos (output of decoder)
    cutDir="/Multimedia/Video/.Uncut"       # Dir with cut videos (output of cutter)
    outDir="/Multimedia/Video/"             # Final dir with videos
  
    torrentDb="/home/deluged/torrents.db"   # File with file names and labels (see at github: OTR-TorrentDb)
    # Possible labels: docu, tvserie, movie, movie-en
    # With these labels the videos will be sorted in subfolders of $outDir
  
    xbmcUrl="user:password@localhost:8080"  # Specify user, password and port for Kodi JSON API (HTTP interface)
    # With this value the script will check whether Kodi is running to prevent stuttering playback
  
    logFile="/home/deluged/otrDecodeAll.log" # path to the log file
    # log levels: 0=off; 1=error; 2=warn; 3=info; 4 debug; 5 verbose debug
    logLevel=2                              # level, which messages shall be written into the log.
    echoLevel=5                             # level, which messages shall be written to stdout.

In funcConfigPost you can use the above variables. Their content may be modified by command line parameters.
    cmdDecode="/usr/bin/otrtool"                      # path to otrkey decoder
    cmdDecodeArgs="-x -e $user -p $pass -D $uncutDir" # for peropeters otrdecoder

    #cmdDecode="/home/pi/bin/qemu-x86_64 -L /home/pi/otr/otr /home/pi/otr/otr/bin64/otrdecoder-64 "
    #cmdDecodeArgs="-e $user -p $pass -o "$uncutDir" -i" # for original otrdecoder

    cmdCut="/home/deluged/multicutmkv.sh"             # path to multicut. Not yet implemented.
    cmdCutArgs=

    cmdSaneRenamix="/home/deluged/saneRenamix.sh"     # path to saneRenamix script. Leave empty to disable
    cmdSaneRenamixArgs="-s -f"
