`drive-up` - A multi-threaded uploader for Google Drive
=======================================================

Features
--------

* Multi-threaded uploads - will upload using four parallel threads by default. Use `-t` to change the number of threads
* Unlimited retries - if uploads fail for some reason, `drive-up` will retry (forever)

Files are compared on modification date and file size. If the date has changed locally, the file is
compared with a md5sum hash to avoid unneeded uploads. If only the date is changed, but the contents
stay the same, `drive-up` will update the date in Drive.

Installation
------------

* you need a working python 2.7 installation
* on OSX and Linux run `setup.sh`. This will create a virtualenv in the current directory and install the necessary python libraries.
* on Windows you must manually do this, sorry. Run `pip install -r requirements.txt` to install the dependencies.
* Finally, install libmagic (see the [instructions in the python-magic readme](https://github.com/ahupp/python-magic#dependencies)).

### Creating an API key

You will need to obtain your own Google API key using the Google Developer Console. Download the JSON-file that
Google provides and rename it to `client-secret.json`. By default, `drive-up` will look for this file in the current
directory. You can specify a different name and location using the `-k` option.

Usage
-----

To upload the current folder to Google Drive, run `drive-up` with no arguments. You can specify the folder to synchronize as the last argument:

```
$ python drive-up.py ~/MyFolder

[#         ] 17.08% 476/1308 files 4.52/26.49 GB
```

On first run, `drive-up` will ask you to open a URL and allow `drive-up` to access your Google Drive account.
It will then download a list of files and compare this to your local folder and then start uploading any files
that are missing in Google Drive.

**By default, your credentials will be saved in your home-folder under `.drive-up/credentials.json`.**

## Options

### Verbose

To follow the process, start `drive-up` with the verbose flag:

```
$ python drive-up.py --verbose ~/Drive

2014-01-19 10:05:33,283 ./drive-up.py INFO: resolving drive files (0 files received)
2014-01-19 10:05:43,914 ./drive-up.py INFO: resolving drive files (1000 files received)
2014-01-19 10:07:44,055 ./drive-up.py INFO: resolved 1308 files/folders
2014-01-19 10:07:44,056 ./drive-up.py INFO: building drive tree
2014-01-19 10:07:44,221 ./drive-up.py WARNING: duplicate file path: Untitled Document
2014-01-19 10:07:44,254 ./drive-up.py INFO: resolving local files
2014-01-19 10:07:48,157 ./drive-up.py INFO: files new: 1062 (26.49 GB)
2014-01-19 10:07:48,157 ./drive-up.py INFO: files changed: 0 (0 B)
2014-01-19 10:07:48,157 ./drive-up.py INFO: files meta changed: 0
2014-01-19 10:07:48,157 ./drive-up.py INFO: files unchanged: 1308 (3.86 GB)
2014-01-19 10:07:48,410 ./drive-up.py INFO: updating meta changed files
2014-01-19 10:07:48,665 ./drive-up.py INFO: updating changed files
2014-01-19 10:07:48,665 ./drive-up.py INFO: creating directories
2014-01-19 10:07:48,985 ./drive-up.py INFO: uploading new files

[#         ] 17.08% 476/1308 files 4.52/26.49 GB
```

This prints out the process of downloading the file list from Drive, and gives you a report on the work needed to be done.
There is also a debug flag available, which will spam you with files and folders. :)

### Test (but don't upload)

If you only want to know what `drive-up` intends to do, run it with the resolve-only flag:

```
$ python drive-up.py --verbose --resolve-only ~/Drive

2014-01-19 10:05:33,283 ./drive-up.py INFO: resolving drive files (0 files received)
2014-01-19 10:05:43,914 ./drive-up.py INFO: resolving drive files (1000 files received)
2014-01-19 10:07:44,055 ./drive-up.py INFO: resolved 1308 files/folders
2014-01-19 10:07:44,056 ./drive-up.py INFO: building drive tree
2014-01-19 10:07:44,221 ./drive-up.py WARNING: duplicate file path: photos/20130730_abb_lysefjord/IMG_0054.JPG
2014-01-19 10:07:44,254 ./drive-up.py INFO: resolving local files
2014-01-19 10:07:48,157 ./drive-up.py INFO: files new: 1062 (26.49 GB)
2014-01-19 10:07:48,157 ./drive-up.py INFO: files changed: 0 (0 B)
2014-01-19 10:07:48,157 ./drive-up.py INFO: files meta changed: 0
2014-01-19 10:07:48,157 ./drive-up.py INFO: files unchanged: 1308 (3.86 GB)

$
```

### Threads

`drive-up` will automatically use 4 threads to upload files in parallel. You can change the number of parallel
 upload by using the `-t` option. To start 3 parallel upload connections, use:

```
$ python drive-up.py --verbose --threads 3 ~/Drive

2014-01-19 10:05:33,283 ./drive-up.py INFO: resolving drive files (0 files received)
2014-01-19 10:05:43,914 ./drive-up.py INFO: resolving drive files (1000 files received)
2014-01-19 10:07:44,055 ./drive-up.py INFO: resolved 1308 files/folders
2014-01-19 10:07:44,056 ./drive-up.py INFO: building drive tree
2014-01-19 10:07:44,221 ./drive-up.py WARNING: duplicate file path: photos/20130730_abb_lysefjord/IMG_0054.JPG
2014-01-19 10:07:44,254 ./drive-up.py INFO: resolving local files
2014-01-19 10:07:48,157 ./drive-up.py INFO: files new: 1062 (26.49 GB)
2014-01-19 10:07:48,157 ./drive-up.py INFO: files changed: 0 (0 B)
2014-01-19 10:07:48,157 ./drive-up.py INFO: files meta changed: 0
2014-01-19 10:07:48,157 ./drive-up.py INFO: files unchanged: 1308 (3.86 GB)
2014-01-19 10:07:48,410 ./drive-up.py INFO: updating meta changed files
2014-01-19 10:07:48,665 ./drive-up.py INFO: updating changed files
2014-01-19 10:07:48,665 ./drive-up.py INFO: creating directories
2014-01-19 10:07:48,985 ./drive-up.py INFO: uploading new files (parallel upload 1)
2014-01-19 10:07:48,985 ./drive-up.py INFO: uploading new files (parallel upload 2)
2014-01-19 10:07:48,985 ./drive-up.py INFO: uploading new files (parallel upload 3)

[#         ] 17.08% 476/1308 files 4.52/26.49 GB
```

### Help

To see more options, run `drive-up` with the help flag:

```
$ python drive-up.py --help
```

## Version history and release notes

### Version 0.1.0, 2015-05-25

- new: will upload symlinked files on file-systems that support this (disable with `--skip-symlinks`)
- new: display average upload speed
- new: display estimated time till complete
- new: display elapsed time
- new: display upload progress per file (only when `--debug` is specified)
- change: use 4 upload threads by default (use `-t N` to use N number of threads)
- first version that carries a version number
