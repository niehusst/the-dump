if [ -z "$1" ]
then
    echo "You forgot to provide a file name!"
    exit 1
fi

cat "$1" | aspell list
