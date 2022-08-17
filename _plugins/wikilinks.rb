# frozen_string_literal: true
class WikiLinksConverter < Jekyll::Generator
    """
    Class to convert wikilinks to markdown links
    """
    priority :highest

    def generate(site)
        all_notes = site.collections['notes'].docs
        all_pages = site.pages
    
        all_docs = all_notes + all_pages

        # create filename -> url links
        note_index = {}
        all_docs.each do |note|
            filename_without_extenstion = File.basename(
                note.basename,
                File.extname(note.basename)
            )
            note_index[filename_without_extenstion] = note
        end

        all_docs.each do |note|
            inline_matches = note.content.scan(WikiLinks::REGEX_WIKI_LINK_INLINES)
            if !inline_matches.nil? && inline_matches.size != 0
                inline_matches.each do |wl_match|
                    filename = wl_match[0]
                    title = wl_match[3]

                    no_title = title.nil?
                    no_note = note_index[filename].nil?

                    if no_title and no_note
                        pattern = "\[\[#{filename}\]\]"
                        replacement = "<span class='invalid-link'>\[\[#{filename}\]\]</span>"
                    elsif not no_title and no_note
                        pattern = "\[\[#{filename}\|#{title}\]\]"
                        replacement = "<span class='invalid-link'>\[\[#{title}\]\]</span>"
                    elsif no_title and not no_note
                        pattern = "\[\[#{filename}\]\]"
                        replacement = "\[#{filename}\](#{site.baseurl}#{note_index[filename].url})"
                    else
                        pattern = "\[\[#{filename}\|#{title}\]\]"
                        replacement = "\[#{title}\](#{site.baseurl}#{note_index[filename].url})"
                    end

                    note.content.gsub!(pattern, replacement)
                end
            end
        end

    end
end

# regex.rb
# regex constants defining supported file types and valid names for files, variables, or text
# Source: https://github.com/manunamz/jekyll-wikilinks/blob/main/lib/jekyll-wikilinks/util/regex.rb

module WikiLinks
    #  <regex_variables> only work with 'match' function, not with 'scan' function. :/
    #  oh well...they are there for easier debugging...

    # supported image formats
    # from: https://docs.github.com/en/github/managing-files-in-a-repository/working-with-non-code-files/rendering-and-diffing-images
    SUPPORTED_IMG_FORMATS = Set.new(['.png', '.jpg', '.gif', '.psd', '.svg'])

    # wikilink constants
    REGEX_LINK_LEFT       = /\[\[/
    REGEX_LINK_RIGHT      = /\]\]/
    REGEX_LINK_TYPE       = /\s*::\s*/
    REGEX_LINK_HEADER     = /\#/
    REGEX_LINK_BLOCK      = /\#\^/
    REGEX_LINK_LABEL      = /\|/

    # wikitext usable char requirements
    REGEX_LINK_TYPE_CHARS = /[^\n\s\!\#\^\|\]]+/i
    REGEX_FILENAME_CHARS  = /[^\\:\#\^\|\[\]]+/i
    REGEX_HEADER_CHARS    = /[^\!\#\^\|\[\]]+/i
    REGEX_BLOCK_ID_CHARS  = /[^\\\/:\!\#\^\|\[\]^\n]+/i
    REGEX_LABEL_CHARS     = /(.+?)(?=\]{2}[^\]])/i

    # capture groups
    REGEX_LINK_TYPE_TXT   = /(?<link-type-txt>#{REGEX_LINK_TYPE_CHARS})/i
    REGEX_FILENAME        = /(?<filename>#{REGEX_FILENAME_CHARS})/i
    REGEX_HEADER_TXT      = /(?<header-txt>#{REGEX_HEADER_CHARS})/i
    REGEX_BLOCK_ID_TXT    = /(?<block-id>#{REGEX_BLOCK_ID_CHARS})/i
    REGEX_LABEL_TXT       = /(?<label-txt>#{REGEX_LABEL_CHARS})/i

    # target markdown text (headers, lists, and blocks)
    ## kramdown regexes
    ### atx header: https://github.com/gettalong/kramdown/blob/master/lib/kramdown/parser/kramdown/header.rb#L29
    REGEX_ATX_HEADER      = /^\#{1,6}[\t ]*([^ \t].*)\n/i
    ### setext header: https://github.com/gettalong/kramdown/blob/master/lib/kramdown/parser/kramdown/header.rb#L17
    REGEX_SETEXT_HEADER   = /^\s{0,3}([^ \t].*)\n[-=][-=]*[ \t\r\f\v]*\n/i
    ## list item: https://github.com/gettalong/kramdown/blob/master/lib/kramdown/parser/kramdown/list.rb#L49
    REGEX_BULLET          = /(?<bullet>[+*-])/i
    ## markdown-style block-reference
    REGEX_BLOCK           = /.*\s\^#{REGEX_BLOCK_ID_TXT}/i

    # wikilinks

    ## inline
    REGEX_WIKI_LINK_INLINES = %r{                     # capture indeces
    #{REGEX_LINK_LEFT}
        #{REGEX_FILENAME}                             # 0
        (#{REGEX_LINK_HEADER}#{REGEX_HEADER_TXT})?    # 1
        (#{REGEX_LINK_BLOCK}#{REGEX_BLOCK_ID_TXT})?   # 2
        (#{REGEX_LINK_LABEL}#{REGEX_LABEL_TXT})?      # 3
    #{REGEX_LINK_RIGHT}
    }x

    ## block
    ### single
    REGEX_SINGLE           = /#{REGEX_LINK_LEFT}#{REGEX_FILENAME_CHARS}#{REGEX_LINK_RIGHT}/i
    ### list (comma is responsible for catching the single case)
    REGEX_LIST_COMMA       = /((?:\s*#{REGEX_SINGLE}\s*)(?:,\s*#{REGEX_SINGLE}\s*)*)/i
    REGEX_LIST_MKDN        = /((?<=\n)\s{0,3}#{REGEX_BULLET}\s#{REGEX_SINGLE}\s*)+/i # (see REGEX_LIST_ITEM)
    ### process
    REGEX_BLOCK_TYPES      = /((?<!\n)(?:#{REGEX_LIST_COMMA})|#{REGEX_LIST_MKDN})/i
    REGEX_WIKI_LINK_BLOCKS = /^\s{0,3}#{REGEX_LINK_TYPE_TXT}#{REGEX_LINK_TYPE}(?:\s*|\G)(?<items>#{REGEX_BLOCK_TYPES})\n/i
end
