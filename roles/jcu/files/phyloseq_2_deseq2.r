#!/home/linuxbrew/.linuxbrew/bin/Rscript

library('getopt')
suppressPackageStartupMessages(library('phyloseq'))
suppressPackageStartupMessages(library('DESeq2'))

options(warn= -1)
#http://saml.rilspace.com/creating-a-galaxy-tool-for-r-scripts-that-output-images-and-pdfs

option_specification = matrix(c(
   'biomfile','b',2,'character',
   'metafile','m',2,'character',
     'factor','f',2,'numeric',
       'test','t',2,'character',
    'fitType','T',2,'character',
     'cutoff','c','2','double',
     'outdir','o',2,'character',
   'result','r',2,'character'
),byrow=TRUE,ncol=4);


options <- getopt(option_specification);
options(bitmapType="cairo")
 

if (!is.null(options$outdir)) {
  # Create the directory
  dir.create(options$outdir,FALSE)
}

gm_mean = function(x, na.rm=TRUE){
  exp(sum(log(x[x > 0]), na.rm=na.rm) / length(x))
}

galaxy_biom <- import_biom(options$biomfile)
galaxy_map <- import_qiime_sample_data(options$metafile)
tax_col_norm <- c("Kingdom","Phylum","Class","Order","Family","Genus","Species")
tax_col_extra <- c("None","Kingdom","Phylum","Class","Order","Family","Genus","Species")

number.of.tax.rank<-length(colnames(tax_table(galaxy_biom)))

if( number.of.tax.rank == 7){
colnames(tax_table(galaxy_biom)) <- tax_col_norm
}else{
colnames(tax_table(galaxy_biom)) <- tax_col_extra
}


AIP_galaxy <- merge_phyloseq(galaxy_biom,galaxy_map)


Infactor<-colnames(galaxy_map)[options$factor]
method<-options$test
Type<-options$fitType
cutoff<-options$cutoff

suppressMessages(deseq2_obj<-phyloseq_to_deseq2(AIP_galaxy,as.formula(paste('~',Infactor,sep=""))))
geoMeans = apply(counts(deseq2_obj), 1, gm_mean)
deseq2_obj = estimateSizeFactors(deseq2_obj, geoMeans = geoMeans)
suppressMessages(deseq2_obj_DE<-DESeq(deseq2_obj,test=method,fitType=Type))


res = results(deseq2_obj_DE,cooksCutoff = FALSE)


significant.table <-res[which(res$padj < cutoff),]

if(nrow(significant.table) == 0){
  out_message <-"no significant result found!"
  write(out_message,file=options$result,sep="\t")
  quit("yes")
}


significant.table <- cbind(as(significant.table,"data.frame"), as(tax_table(AIP_galaxy)[rownames(significant.table),],"matrix"))

#significant.table <- format(round(significant.table, 4), nsmall = 4)

write.table(format(significant.table, digits=4, scientific=F),file=options$result,col.names=T,row.names=T,quote=F,sep="\t")


#colnames(tax_table(AIP_galaxy)) <- tax_col_galaxy


#pdffile <- gsub("[ ]+", "", paste(options$outdir,"/kingdom.pdf"))
#pngfile_kingdom <- gsub("[ ]+", "", paste(options$outdir,"/kingdom.png"))
#htmlfile <- gsub("[ ]+", "", paste(options$htmlfile))


# Produce PDF file
#pdf(pdffile);
#plot_bar(AIP_galaxy,x=x.selectedColumn,facet_grid = paste('~', tax.selected),fill=l.selectedColumn)
#garbage<-dev.off();

#png('kingdom.png')
#bitmap(pngfile_kingdom,"png16m")
#plot_bar(AIP_galaxy,x=x.selectedColumn,facet_grid = paste('~', tax.selected),fill=l.selectedColumn)
#garbage<-dev.off()

# Produce the HTML file
#htmlfile_handle <- file(htmlfile)
#html_output = c('<html><body>',
#	        '<table align="center>',
#		'<tr>',
#		'<td valign="middle" style="vertical-align:middle;">',
#                '<a href="kingdom.pdf"><img src="kingdom.png"/></a>',
#		'</td>',
#		'</tr>',
#		'</table>',
#                '</html></body>');
#writeLines(html_output, htmlfile_handle);
#close(htmlfile_handle);