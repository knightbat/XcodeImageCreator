#!/bin/bash

original_path=$(pwd)

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "$package - Xcode image creator"
      echo " "
      echo "$package [options] application [arguments]"
      echo " "
      echo "options:"
      echo "-h, --help                show brief help"
      echo "-p, --path                path to project folder"
      exit 0
    ;;
    -p|--path)

      shift
        export original_path=$1

      shift
    ;;

    *)
      break
    ;;
  esac
done


echo "************* working on $original_path **********"

scriptdir=$(cd "`dirname $0`" && pwd)

echo "************* script on $scriptdir **********"


cd $original_path
assets_path=$(find . -path '*.xcassets')
echo "Assets path $assets_path"

if [[ $assets_path ]]; then

  if [[ -d images ]]; then

    #######################################################################################################
    ####################################### images ########################################################
    #######################################################################################################

    image_json_file="$(cat "$scriptdir/image.json")"
    echo $image_json_file
    rm -rf /tmp/xcode_images
    mkdir /tmp/xcode_images

    cp images/* /tmp/xcode_images
    cd /tmp/xcode_images

    #rename spaces in name with underscore

    find /tmp/xcode_images/ -depth -name "* *" -execdir rename 's/ /_/g' "{}" \;

    # loop
    for fullname in *
    do

      echo "image name is $i"


      filename=$(echo $fullname | cut -f 1 -d '.')
      echo "filename $filename"
      mv $fullname $filename.png

      # get image size
      width3=$(identify -ping -format '%w' $filename.png)
      height3=$(identify -ping -format '%h' $filename.png)

      # calculate size for 2x image
      width2=$(($width3*2/3))
      height2=$(($height3*2/3))

      # calculate size for 1x image
      width=$(($width3*1/3))
      height=$(($height3*1/3))

      json_file=$image_json_file

      # create 3x image
      cp $filename.png $filename@3x.png

      string_to_replace_with=$filename@3x.png
      echo $string_to_replace_with
      json_file="${json_file/3x.png/$string_to_replace_with}"


      # create 2x image
      convert $filename.png    -resize $height2x$width2\> $filename@2x.png

      string_to_replace_with=$filename@2x.png
      echo $string_to_replace_with
      json_file="${json_file/2x.png/$string_to_replace_with}"

      # create 1x image
      convert $filename.png   -resize $heightx$width\> $filename.png

      string_to_replace_with=$filename.png
      echo $string_to_replace_with
      json_file="${json_file/1x.png/$string_to_replace_with}"


      #move to image set folder
      mkdir temp
      mv $filename* temp
      echo $json_file > temp/Contents.json
      mv temp $filename.imageset
    done

    #find path of Assets.xcassets

    cd "$original_path"
    path=$(find . -path '*.xcassets')

    # copy all image set to xcassets and delete temp files
    cp -Rf /tmp/xcode_images/*.imageset "$path" && rm -rf /tmp/xcode_images/*.imageset

    #######################################################################################################


    #######################################################################################################
    ##################################### App Icon ########################################################
    #######################################################################################################

    if [ -f images/icon.* ]; then
      cp images/icon.* /tmp/xcode_images
      cd /tmp/xcode_images
      icon=$(ls)

      echo "*************** $icon"
      convert $icon    -resize 40x40\! Icon-20.0@2x.png
      convert $icon    -resize 60x60\! Icon-20.0@3x.png
      convert $icon    -resize 29x29\! Icon-29.0@1x.png
      convert $icon    -resize 58x58\! Icon-29.0@2x.png
      convert $icon    -resize 87x87\! Icon-29.0@3x.png
      convert $icon    -resize 40x40\! Icon-40.0@1x.png
      convert $icon    -resize 80x80\! Icon-40.0@2x.png
      convert $icon    -resize 120x120\! Icon-40.0@3x.png
      convert $icon    -resize 50x50\! Icon-50.0@1x.png
      convert $icon    -resize 100x100\! Icon-50.0@2x.png
      convert $icon    -resize 57x57\! Icon-57.0@1x.png
      convert $icon    -resize 114x114\! Icon-57.0@2x.png
      convert $icon    -resize 120x120\! Icon-60.0@2x.png
      convert $icon    -resize 180x180\! Icon-60.0@3x.png
      convert $icon    -resize 72x72\! Icon-72.0@1x.png
      convert $icon    -resize 144x144\! Icon-72.0@2x.png
      convert $icon    -resize 76x76\! Icon-76.0@1x.png
      convert $icon    -resize 152x152\! Icon-76.0@2x.png
      convert $icon    -resize 167x167\! Icon-83.5@2x.png

      cd "$original_path"
      path=$(find . -path '*.appiconset')
      mv /tmp/xcode_images/Icon-* "$path"
      cp "$scriptdir/icon.json" "$path/Contents.json"
      rm /tmp/xcode_images/$icon

    else
      echo "no icon images found."
    fi
    #######################################################################################################

    rm -rf /tmp/xcode_images
  else
    echo "image folder not found. please copy all images to directory \"images\""
  fi
else
  echo "Cant find xcassets folder"
fi
