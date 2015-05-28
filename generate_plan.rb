#!/usr/bin/env ruby

require 'zip'
require 'nokogiri'

def output str
    @output_file.write(str)
end

def outputln str
    output str + "\n"
end

def process_cell cell, first
    if first
        first = false
    else
        output ' & '
    end
    txt = cell.xpath('.//text:p')
    spanned = !cell['table:number-columns-spanned'].nil?
    sty = cell['table:style-name']
    bold = !sty.nil? && (sty == 'ce1' || sty == 'ce2')
    if !txt.empty?
        output '\multicolumn{2}{c|}{' if spanned
        output '\textbf{' if bold
        output txt.first.content
        output '}' if bold
        output '}' if spanned
    end
    
    first
end

File::open('projektplan.tex', 'w') do |output_file|

    @output_file = output_file

    Zip::File.open('projektplan.ods') do |zip_file|
        xml_code = zip_file.read('content.xml');
        root_node = Nokogiri::XML(xml_code)
        outputln '\begingroup'
        outputln '\small'
        outputln '\begin{tabularx}{\textwidth}{|X|c|c|c|} \hline'
        root_node.xpath('//table:table-row').each do |row|
            first = true
            
            row.xpath('.//table:table-cell').each do |cell|
                repeated = cell['table:number-columns-repeated']
                
                if repeated.nil?
                    first = process_cell(cell, first)
                else
                    repeated.to_i.times do 
                        first = process_cell(cell, first)
                    end
                end
                
               
            end
            outputln ' \\\\ \hline'
        end
        outputln '\end{tabularx}'
    end

end
