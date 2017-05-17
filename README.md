# XcodeImageCreator


A Simple Bash Script to generate image assets for Xcode projects and place it in to appropriate locations.

## Prerequisites
You need install [ImageMagick](https://www.imagemagick.org), [jq](https://github.com/stedolan/jq) and [rename](http://plasmasturm.org/code/rename/) via [Homebrew](https://brew.sh/)

```bash
  brew install imagemagick
```
```bash
  brew install jq
```
```bash
  brew install rename
```

## Installation

* clone this repo

```bash
    git https://github.com/knightbat/KBDrawingView.git
```
* cd to path

```bash
    cd XcodeImageCreator
```

## Usage
* Go to project folder and create a folder named images and copy all images
* (optional) If you want to generate icon for the project set it's name as icon and copy it in to images folder
* In terminal (which is pointing to this repo) run
``` bash
    ./xcode_image_creator.sh -p /path/to/project/folder
```
* Done. if you want you can delete the images folder.
