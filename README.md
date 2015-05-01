OTR-DecodeAll
=============

This is a Bash script to 
  - decode all downloaded *.otrkey files in a folder with the decoder of your choise,
  - cut them with multicutmkv (or any other tool you want to configure),
  - create folders based on tags (labels) with appropriate names,
  - ask SaneRenamix for appropriate file names of episodes and
  - move the final movie to its destination (so they are recognized by Kodi)


Configuration
-------------

The `config.sample` file provides a default configuration. Please copy it to `config` and modify it to reflect your needs. Some parts of the configuration can be overridden by command line parameters, other variables shall use those parameters. Thus the config file is divided in two parts (functions): `funcConfigPre` and `funcConfigPost`.
In `funcConfigPre` the following values have to be set:

    user="OTR-Email"
    pass="OTR-Password"
  
    delugeDir="/etc/deluged"                # Config dir of DelugeD
    inDir="/Multimedia/Video/.Downloaded"   # Dir with .otrkeys
    tempDir="/Multimedia/Video/.Temp"       # Dir with decoded and cut videos (output of decoder and cutter)
    outDir="/Multimedia/Video"              # Final dir with videos
  
    labelDb="/home/deluged/labeldb/labelsOfTorrents.db"   # File with file names and labels (see at github: Jonny007-MKD/Torrent-Label-DB) (optional)

    # Add label->directory mapping. (optional)
    #   1st arg: Label
    #   2nd arg: Each movie with this label will be moved to this subdirectory of $outDir
    #   3rd arg: (optional) Whether SaneRenamix shall be used for movies with this label (default: false)
    addLabel "movie"    "Filme"             0
    addLabel "movie-en" "Filme-En"          "false"
    addLabel "docu"     "Dokumentationen"
    addLabel "tvserie"  "Serien"            true

    kodiUrl="user:password@localhost:8080"  # Specify user, password and port for Kodi JSON API (HTTP interface)
    # With this value the script will check whether Kodi is running to prevent stuttering playback
  
    logFile="/home/deluged/otrDecodeAll.log" # path to the log file
    # log levels: 0=off; 1=error; 2=warn; 3=info; 4 debug; 5 verbose debug
    logLevel=2                              # which messages shall be written into the log.
    echoLevel=3                             # which messages shall be written to stdout.

In funcConfigPost you can use the variables from above. Their content may be modified by command line parameters.

    # 1st Decoder: otrtool
    cmdDecode="/usr/bin/otrtool"           # path to otrkey decoder
    cmdDecodeArgs="-x -e $user -p $pass -D $uncutDir" # for peropeters otrdecoder

    # 2nd Decoder: otrdecode-64 with qemu
    #cmdDecode="/home/pi/bin/qemu-x86_64 -L /home/pi/otr/otr /home/pi/otr/otr/bin64/otrdecoder-64 "
    #cmdDecodeArgs="-e $user -p $pass -o "$uncutDir" -i" # for original otrdecoder

    # 3rd Decoder: otrpidecoder
    #cmdDecode="/usr/bin/otrpidecoder"     # path to NYrks otrdecoder
    #cmdDecodeArgs="-d -e $user -p $pass"
    #tempDir="$inDir"                      # no output directory can be specified


    cmdCut="/home/deluged/multicutmkv.sh"  # path to multicut  (see at github: Jonny007-MKD/multicutmkv)
    cmdCutArgs="-q -o $tempDir -t $tempDir"


    cmdSaneRenamix="/home/deluged/saneRenamix.sh"     # path to saneRenamix script. Leave empty to disable
    cmdSaneRenamixArgs="-s -f"

My Workflow
-----------

I want to explain my OTR workflow to show you how OTR-DecodeAll fits into it and to give you some hints what is possible.
    - I download the otrkeys with DelugeD, a BitTorrent client. It has several nice features like
        - Remote control on smartphones and desktops
        - A RSS client where I can teach it to automatically download my favourite series
        - Moving finished files to a specified directory
        - Specifing lables which are used later
        - Executing programs when a torrent was added or is finished
    - When a new torrent is added, the script `delugeAddTorrent.sh` from Jonny007-MKD/Torrent-Label-DB is called and a new entry in this database is created
    - The script `refreshDb.sh` from Jonny007-MKD/Torrent-Label-DB is called periodically, so when I change the label of a torrent it gets updated in the database
    - When the torrent is finished, it gets moved to the `Downloaded/` directory
    - The script `otrDecodeAll.sh` from this repository is executed periodically and decodes all files.

Labels
------

Labels are used to specify the type of torrent. I use it to specify the type of the movie and to determine the destination folder. Some examples are:
    - english movies
    - german movies
    - english series
    - german series
    - documentations
Based on these labels `otrDecodeAll` will handle the files differently. If the flag for `saneRenamix` (from Jonny007-MKD/OTR-SaneRename) is set to true this script is executed to determine a nice filename for series files. At the end of the script the movie will be moved to a subfolder based on the label. These settings can be specified in the `config` file:

     addLabel "movie-en"    "Filme-En"         0

This line adds a new label "movie". Files with this label will be moved to the subfolder "Filme-En/" and saneRenamix will not be used.
