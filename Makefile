# size of n-grams for n-gram analysis
n?=3

all: word-report.html ngram-report.html

clean:
	rm -f words.txt word-histogram.tsv word-histogram.png word-report.md word-report.html

word-report.html: word-report.rmd word-histogram.tsv word-histogram.png
	Rscript -e 'rmarkdown::render("$<")'

ngram-report.html: ngram-report.rmd ngram-histogram.tsv ngram-histogram.png
	Rscript -e 'rmarkdown::render("$<")'

word-histogram.png: word-histogram.tsv
	Rscript -e 'library(ggplot2); qplot(Length, Freq, data=read.delim("$<")); ggsave("$@")'
	rm Rplots.pdf

ngram-histogram.png: ngram-histogram.tsv
	Rscript -e 'library(ggplot2); qplot(Length, Freq, data=read.delim("$<")); ggsave("$@")'
	rm Rplots.pdf

word-histogram.tsv: word-histogram.r words.txt
	Rscript $<

ngram-histogram.tsv: ngram-histogram.py words.txt
	python3 ngram-histogram.py words.txt $(n) > ngram_histogram.tsv

words.txt: /usr/share/dict/words
	cp $< $@

# words.txt:
#	Rscript -e 'download.file("http://svnweb.freebsd.org/base/head/share/dict/web2?view=co", destfile = "words.txt", quiet = TRUE)'
