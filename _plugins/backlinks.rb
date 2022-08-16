# frozen_string_literal: true
class BacklinksGenerator < Jekyll::Generator
    """
    Class to add backlinks to notes metadata
    """
    def generate(site)
        all_notes = site.collections['notes'].docs
        # Identify note backlinks and add them to each note
        all_notes.each do |current_note|
            # Nodes: Jekyll
            notes_linking_to_current_note = all_notes.filter do |e|
                e.content.include?(current_note.url)
            end
    
            # Edges: Jekyll
            current_note.data['backlinks'] = notes_linking_to_current_note
        end
    end
end
