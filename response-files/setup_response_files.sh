# /bin/bash

OS=`uname`
if [ "$OS" = "Linux" ]; then
		READLINK=readlink
elif [ "$OS" = "Darwin" ]; then
		READLINK=stat
		EXT=".dylib"
fi

tempfile=$(mktemp "response-files.XXXXXXXXXXXX")
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
resp_dir=$HOME/.response_files
mkdir -p $resp_dir/files

# first, find files and add them as environment variables
for f in $SRC_DIR/*.response
do
		name=RF_"$(sed -n 's/.*Name: \(.*\)/\1/p' $f)"
		desc="$(sed -n 's/.*Description: \(.*\)/\1/p' $f)"
		#echo "File: $f"
		#echo "Name: $name"
		#echo "Description: $desc"
		#echo
		filename="$resp_dir/files/$(basename $f)"
		command="$(grep -v "#" $f)"
		echo $command > $filename
		export $name="@$filename"
		echo "$name: $desc" >> $tempfile
		echo "  $command" >> $tempfile
		echo >> $tempfile
done

echo "Setting up response-file variables:"
cat $tempfile
mv $tempfile $HOME/.response_files/list

# create function to display list
function show-response-files {
		cat $HOME/.response_files/list
}

