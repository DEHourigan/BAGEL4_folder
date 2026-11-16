for file in *hmm 
do awk '/NAME/' $file | sed 's/NAME//g' > /home/david/${file}_list
done
