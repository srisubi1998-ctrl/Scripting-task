#!/bin/bash

mkdir -p my_folder
cd my_folder
echo "Hello from my_file" > my_file.txt
echo "Hello from another_file" > another_file.txt
cat another_file.txt >> my_file.txt
cat my_file.txt
ls -la

touch file{01..20}.txt
for f in file{01..05}.txt; do
    mv "$f" "${f%.txt}.yml"
done
ls -lt | head -n 6
