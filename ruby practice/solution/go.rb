# return an array of words produced by removing a letter
def remove(orig, all_words, viewed_words)
	results = []
	#produce a word by removing one letter at a time
	(0..orig.length-1).each do |position|
		#remove the letter
		temp = orig[0,position]+orig[position+1,orig.length-position-1]
		#collect the new word if we haven't collected it already, and we haven't come across it yet
		results << temp if all_words.has_key?(temp) and not viewed_words.has_key?(temp)
	end
	results
end

#return an array of words produced by adding a letter
def add(orig, all_words, viewed_words) 
	results = []
	#produce a word by adding one letter at a time
	(0..orig.length).each do |position|
		#iterate over all letters in the alphabet
		('a'..'z').each do |letter| 
			#insert the letter
			temp = orig[0,position] + letter + orig[position,orig.length-position]
			#collect the new word if we haven't collected it already, and we haven't come across it yet
			results << temp if all_words.has_key?(temp) and not viewed_words.has_key?(temp)
		end
	end
	results
end

# return an array of words produced by switching a letter
def switch(orig, all_words, viewed_words)
	results = []
	#produce a word by switching out one letter at a time
	(0..orig.length-1).each do |position|
		#iterate over all letters in the alphabet
		('a'..'z').each do |letter|
			temp = orig.dup
			#replace the letter
			temp[position]=letter
			#collect the new word if: 
			# - the new word is not the same as the origional
			# - the new word has not already been collected 
			# - we have not come across the word yet
			results << temp if (temp != orig and all_words.has_key?(temp) and not viewed_words.has_key?(temp))
		end
	end
	results
end

#initial thoughts
#we're limited by the list of words
#on a single pass, we create friends
#on multiple passes, we create additional friends

start = Time.now
puts "START: #{start}"

root = 'causes'
#hash has unique keys, use this to avoid duplicate words
hash = {}
#array for storing the list of words
queue = []
#hash to store the original list of words
all_words = {}

#read the file into the array
File.open('source.txt','r').read.split("\n").each {|x| all_words[x] = ''}

#initial pass, create friends

#collect words by removing letters
queue = remove(root, all_words, hash)
#collect words by adding letters
queue = queue + add(root, all_words, hash)
#collect words by switching letters
queue = queue + switch(root, all_words, hash)

# add the root word to the hash
hash['causes'] = ''

#multiple passes, create additional friends
while(not queue.empty?)
	# remove the word from the FRONT of the array
	word = queue.shift
	
	# if the hash already has the word, skip to the next loop
	next if hash.has_key?(word)
	
	# add the new word to the hash
	hash[word] = ''
	
	# add new friends to the BACK of the array using new words as they are found
	# eventually, we will exhaust all combinations
	queue = queue + remove(word, all_words, hash)
	queue = queue + add(word, all_words, hash)
	queue = queue + switch(word, all_words, hash)
end

File.open('out.txt','w') do |f|
	hash.keys.each {|x| f.puts x}
end


time_end = Time.now
puts "END: #{time_end}"
puts "TOTAL TIME: #{time_end - start}"
puts "\nThe social network for the word:#{root} has #{hash.size} members."