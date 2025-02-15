#!/bin/sh

echo "Starting the copying script"

folders="nvim kitty i3"

for folder in $folders;
do
	echo "Copying ${folder}"
	cp -r ${folder} ~/.config/${folder}/
done
