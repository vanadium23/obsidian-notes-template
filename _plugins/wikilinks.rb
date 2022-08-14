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

                    url = note_index[filename].nil? ? "/not-found/" : note_index[filename].url
                    full_url = "#{site.baseurl}#{url}"
                    if title.nil?
                        pattern = "\[\[#{filename}\]\]"
                        replacement = "\[#{filename}\](#{full_url})"
                    else
                        pattern = "\[\[#{filename}\|#{title}\]\]"
                        replacement = "\[#{title}\](#{full_url})"
                    end
                    note.content.gsub!(pattern, replacement)
                end
            end
        end

    end
end

  