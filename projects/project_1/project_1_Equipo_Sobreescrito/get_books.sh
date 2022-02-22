# ----------------------------------------
# This script downloads n random books (with replacement)
# from a given bookshelf. If n > number of
# books in library, you should deterministaclly
# download all books.
# Input:
# - library_id: id of library to download.
# - n: number of random books to download.
#   NOTE1: (n < number of books in library)
#   NOTE2: do not download unnecesary books!
# - env_dir: path to: [./PROJECT HOME]/text_comp/.
# - Hint1: take a look at $RANDOM
# - Hint2: (n % (b-a+1) + a) belongs to [a, b].
# ----------------------------------------

bookshelf_id=$1
n=$2
env_dir=$3
samp=1

if [ ! -d "$env_dir/texts/$bookshelf_id" ]
then
    mkdir "$env_dir/texts/$bookshelf_id"
fi

n_books="$(cat $env_dir/bookshelves/$bookshelf_id/titles.txt | wc -l)"

if [ "$n" -gt "$n_books" ]
then
    # Deterministic case
    n=$n_books
    samp=0
    echo 'Downloading all books'
fi

for i in `seq $n`
do
    ###################################################
    # YOUR CODE GOES HERE
    # TODO: get the information related with the queried
    # book and download the main contents to the desire location.
    ###################################################
    random_num=$(($RANDOM%$n+1))

    echo -i "random_num = $random_num with $i"
    sleep 3
    book_url="$(cat $env_dir/bookshelves/$bookshelf_id/titles.txt | tail -n +2 | head -$random_num | tail -1 | awk -F '\t' '{print $1}')"
    book_id="$(echo -e "$book_url" | sed -En 's;https://.+epub/;;gp' | sed -En 's;/.+;;gp')"
    echo -i "Book id is $book_id"
    echo -i "Book url is $book_url of $i"
    book_path="$env_dir/texts/$bookshelf_id/$book_id"
    if [ ! -d "$book_path" ]
    then
        echo -i "Downloading $book_id now to $book_path"
        mkdir $book_path
        curl $book_url > "$book_path/main_text.txt"
    fi
done
