#!/bin/bash
#
# this script demonstrates doing arithmetic

# Task 1: Remove the assignments of numbers to the first and second number variables. Use one or more read commands to get 3 numbers from the user.
# Task 2: Change the output to only show:
#    the sum of the 3 numbers with a label
#    the product of the 3 numbers with a label

echo "Enter the First number:" ; read firstnum
echo "Enter the Second number:" ; read secondnum
echo "Enter the Third number:" ; read thirdnum
sum=$((firstnum + secondnum + thirdnum))
product=$((firstnum * secondnum * thirdnum))
fpproduct=$(awk "BEGIN{printf \"%.2f\", $firstnum*$secondnum*$thirdnum}")

cat <<EOF
Sum of $firstnum , $secondnum and $thirdnum is $sum
Product of $firstnum , $secondnum and $thirdnum is $product
  - More precisely, it is $fpproduct
EOF
