# /bin/bash

# Warning, this script is for bootstrapping user dot files in a docker
# image.  Use at your own risk.

OS=`uname`
if [ "$OS" = "Linux" ]; then
		READLINK=readlink
elif [ "$OS" = "Darwin" ]; then
		READLINK=stat
		EXT=".dylib"
fi

SRC_DIR="$( cd "$( dirname "$(${READLINK} -f "$0")" )"/../home && pwd )"
DEST_DIR=${HOME}

age_file() {
		file=$1
		newfile=$file.$(date +%F)
		# keep up to 3 copies per day
		if [ -e $newfile.1 ]; then
				mv $newfile.1 $newfile.2
		fi
		if [ -e $newfile ]; then
				mv $newfile $newfile.1
		fi
		if [ -e $file ]; then
				mv $file $newfile
		fi
}

copy_file() {
		src_file=${SRC_DIR}/$1
		dst_file=${DEST_DIR}/$1
		if [ -h $dst_file ]; then
				rm $dst_file
		else
				age_file $dst_file
		fi
		cp $src_file $dst_file
}

link_file() {
		src_file=${SRC_DIR}/$1
		dst_file=${DEST_DIR}/$1
		if [ -h $dst_file ]; then
				rm $dst_file
		else
				age_file $dst_file
		fi
		ln -s $src_file $dst_file
}

# emacs doesn't like to follow symlinks, so copy .emacs so we don't
# have to type 'y' everytime we startup
copy_file .emacs

link_file .bashrc
link_file .gitconfig
link_file .tmux.conf
link_file site-lisp
